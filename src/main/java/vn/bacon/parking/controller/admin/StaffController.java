package vn.bacon.parking.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.service.AccountService;
import vn.bacon.parking.service.StaffService;
import java.util.Optional;

@Controller
@RequestMapping("/admin/staff")
public class StaffController {
    private final StaffService staffService;
    private final AccountService accountService;

    public StaffController(StaffService staffService, AccountService accountService) {
        this.accountService = accountService;
        this.staffService = staffService;
    }

    @GetMapping
    public String listStaff(@RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Staff> staffPage = staffService.getStaffPage(pageable);
        model.addAttribute("staffPage", staffPage);
        model.addAttribute("staffList", staffPage.getContent());
        return "admin/staff/show";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("newStaff", new Staff());
        return "admin/staff/create";
    }

    @PostMapping("/create")
    public String createStaff(@Valid @ModelAttribute("newStaff") Staff staff,
            BindingResult result,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "admin/staff/create";
        }
        // Check if maNV already exists
        if (staffService.existsByMaNV(staff.getMaNV())) {
            result.rejectValue("maNV", "error.staff", "Mã nhân viên đã tồn tại!");
            return "admin/staff/create";
        }

        if (staffService.existsBySdt(staff.getSdt())) {
            result.rejectValue("sdt", "error.staff", "Số điện thoại đã tồn tại!");
            return "admin/staff/create";
        }

        if (staffService.existsByEmail(staff.getEmail())) {
            result.rejectValue("email", "error.staff", "Email đã tồn tại!");
            return "admin/staff/create";
        }

        if (staffService.existsByCccd(staff.getCccd())) {
            result.rejectValue("cccd", "error.staff", "CCCD đã tồn tại!");
            return "admin/staff/create";
        }

        if (!avatarFile.isEmpty()) {
            String avatarFileName = staffService.handleAvatarUpload(avatarFile, "avatars");
            if (avatarFileName.isEmpty()) {
                result.rejectValue("avatar", "error.staff", "Không thể upload avatar!");
                return "admin/staff/create";
            }
            staff.setAvatar(avatarFileName);
        }

        try {
            staffService.saveStaff(staff);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Thêm nhân viên " + staff.getMaNV() + " thành công");
            return "redirect:/admin/staff";
        } catch (DataIntegrityViolationException e) {
            String message = e.getMostSpecificCause().getMessage();
            if (message.contains("SDT")) {
                result.rejectValue("sdt", "error.staff", "Số điện thoại đã tồn tại!");
            } else if (message.contains("Email")) {
                result.rejectValue("email", "error.staff", "Email đã tồn tại!");
            } else if (message.contains("CCCD")) {
                result.rejectValue("cccd", "error.staff", "CCCD đã tồn tại!");
            } else {
                result.rejectValue("maNV", "error.staff", "Lỗi cơ sở dữ liệu: " + message);
            }
            return "admin/staff/create";
        }
    }

    @GetMapping("/{maNV}")
    public String viewStaff(@PathVariable String maNV, Model model) {
        Optional<Staff> staff = staffService.getStaffById(maNV);
        if (staff.isPresent()) {
            model.addAttribute("staff", staff.get());
            return "admin/staff/view";
        }
        return "redirect:/admin/staff";
    }

    @GetMapping("/update/{maNV}")
    public String showUpdateForm(@PathVariable String maNV, Model model) {
        Optional<Staff> staff = staffService.getStaffById(maNV);
        if (staff.isPresent()) {
            model.addAttribute("newStaff", staff.get());
            return "admin/staff/update";
        }
        return "redirect:/admin/staff";
    }

    @PostMapping("/update")
    public String updateStaff(@Valid @ModelAttribute("newStaff") Staff updatedStaff,
            BindingResult result,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "admin/staff/update";
        }

        Optional<Staff> existingStaffOpt = staffService.getStaffById(updatedStaff.getMaNV());
        if (!existingStaffOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Nhân viên không tồn tại!");
            return "redirect:/admin/staff";
        }
        Staff existingStaff = existingStaffOpt.get();

        if (updatedStaff.getSdt() != null && !updatedStaff.getSdt().equals(existingStaff.getSdt()) &&
                staffService.existsBySdtAndNotMaNV(updatedStaff.getSdt(), updatedStaff.getMaNV())) {
            result.rejectValue("sdt", "error.staff", "Số điện thoại đã tồn tại!");
            return "admin/staff/update";
        }

        if (updatedStaff.getEmail() != null && !updatedStaff.getEmail().equals(existingStaff.getEmail()) &&
                staffService.existsByEmailAndNotMaNV(updatedStaff.getEmail(), updatedStaff.getMaNV())) {
            result.rejectValue("email", "error.staff", "Email đã tồn tại!");
            return "admin/staff/update";
        }

        if (updatedStaff.getCccd() != null && !updatedStaff.getCccd().equals(existingStaff.getCccd()) &&
                staffService.existsByCccdAndNotMaNV(updatedStaff.getCccd(), updatedStaff.getMaNV())) {
            result.rejectValue("cccd", "error.staff", "CCCD đã tồn tại!");
            return "admin/staff/update";
        }

        // Cập nhật các trường bắt buộc
        existingStaff.setHoTen(updatedStaff.getHoTen());
        existingStaff.setSdt(updatedStaff.getSdt());
        existingStaff.setEmail(updatedStaff.getEmail());
        existingStaff.setCccd(updatedStaff.getCccd());
        existingStaff.setChucVu(updatedStaff.getChucVu());

        // Chỉ cập nhật ngayVaoLam nếu người dùng nhập giá trị mới
        if (updatedStaff.getNgayVaoLam() != null) {
            existingStaff.setNgayVaoLam(updatedStaff.getNgayVaoLam());
        }

        // Cập nhật avatar nếu có file mới
        if (!avatarFile.isEmpty()) {
            String avatarFileName = staffService.handleAvatarUpload(avatarFile, "avatars");
            if (avatarFileName.isEmpty()) {
                result.rejectValue("avatar", "error.staff", "Không thể upload avatar!");
                return "admin/staff/update";
            }
            existingStaff.setAvatar(avatarFileName);
        }

        try {
            staffService.saveStaff(existingStaff);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Cập nhật nhân viên " + existingStaff.getMaNV() + " thành công");
            return "redirect:/admin/staff";
        } catch (DataIntegrityViolationException e) {
            String message = e.getMostSpecificCause().getMessage();
            if (message.contains("SDT")) {
                result.rejectValue("sdt", "error.staff", "Số điện thoại đã tồn tại!");
            } else if (message.contains("Email")) {
                result.rejectValue("email", "error.staff", "Email đã tồn tại!");
            } else if (message.contains("CCCD")) {
                result.rejectValue("cccd", "error.staff", "CCCD đã tồn tại!");
            } else {
                result.rejectValue("maNV", "error.staff", "Lỗi cơ sở dữ liệu: " + message);
            }
            return "admin/staff/update";
        }
    }

    @GetMapping("/delete/confirm/{maNV}")
    public String showDeleteConfirm(@PathVariable String maNV, Model model) {
        Optional<Staff> staff = staffService.getStaffById(maNV);
        if (staff.isPresent()) {
            model.addAttribute("maNV", maNV);
            boolean hasAccount = accountService.existsByUsername(maNV);
            boolean vehicleRegistered = staffService.hasRegisteredVehicle(maNV);
            model.addAttribute("hasAccount", hasAccount);
            model.addAttribute("vehicleRegistered", vehicleRegistered);
            return "admin/staff/delete";
        }
        return "redirect:/admin/staff";
    }

    @GetMapping("/delete/{maNV}")
    public String deleteStaff(@PathVariable String maNV, RedirectAttributes redirectAttributes) {
        try {
            staffService.deleteStaffById(maNV);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa nhân viên " + maNV + " thành công");
        } catch (IllegalStateException e) {

            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/staff/delete/confirm/" + maNV;
        } catch (Exception e) {

            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa nhân viên: " + e.getMessage());
            return "redirect:/admin/staff/delete/confirm/" + maNV;
        }
        return "redirect:/admin/staff";
    }
}
