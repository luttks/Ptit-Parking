package vn.bacon.parking.controller.client;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.service.StaffService;
import vn.bacon.parking.service.AccountService;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Controller
@RequestMapping("/staff")
public class StaffProfileController {

    private final StaffService staffService;
    private final AccountService accountService;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public StaffProfileController(StaffService staffService, AccountService accountService) {
        this.staffService = staffService;
        this.accountService = accountService;
    }

    private String formatDate(LocalDate date) {
        return date != null ? date.format(DATE_FORMATTER) : "";
    }

    // View staff profile
    @GetMapping("/profile")
    public String viewProfile(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        Optional<Staff> staff = staffService.getStaffById(username);
        if (staff.isPresent() && "Giảng viên".equals(staff.get().getChucVu())) {
            model.addAttribute("staff", staff.get());
            model.addAttribute("formattedNgayVaoLam", formatDate(staff.get().getNgayVaoLam()));
            return "client/staff/profile/profile";
        }
        return "redirect:/";
    }

    // Show edit profile form
    @GetMapping("/profile/edit")
    public String showEditForm(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        Optional<Staff> staff = staffService.getStaffById(username);
        if (staff.isPresent() && "Giảng viên".equals(staff.get().getChucVu())) {
            model.addAttribute("staff", staff.get());
            model.addAttribute("formattedNgayVaoLam", formatDate(staff.get().getNgayVaoLam()));
            return "client/staff/profile/editprofile";
        }
        return "redirect:/staff/profile";
    }

    @PostMapping("/profile/edit")
    public String updateProfile(
            @Valid @ModelAttribute("staff") Staff updatedStaff,
            BindingResult result,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            model.addAttribute("formattedNgayVaoLam", formatDate(updatedStaff.getNgayVaoLam()));
            return "client/staff/profile/editprofile";
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        Optional<Staff> existingStaffOpt = staffService.getStaffById(username);
        if (!existingStaffOpt.isPresent() || !"Giảng viên".equals(existingStaffOpt.get().getChucVu())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thông tin giảng viên!");
            return "redirect:/staff/profile";
        }

        Staff existingStaff = existingStaffOpt.get();

        // Validate phone number uniqueness
        if (updatedStaff.getSdt() != null && !updatedStaff.getSdt().equals(existingStaff.getSdt()) &&
                staffService.existsBySdtAndNotMaNV(updatedStaff.getSdt(), username)) {
            result.rejectValue("sdt", "error.staff", "Số điện thoại đã tồn tại!");
            model.addAttribute("formattedNgayVaoLam", formatDate(updatedStaff.getNgayVaoLam()));
            return "client/staff/profile/editprofile";
        }

        // Validate email uniqueness
        if (updatedStaff.getEmail() != null && !updatedStaff.getEmail().equals(existingStaff.getEmail()) &&
                staffService.existsByEmailAndNotMaNV(updatedStaff.getEmail(), username)) {
            result.rejectValue("email", "error.staff", "Email đã tồn tại!");
            model.addAttribute("formattedNgayVaoLam", formatDate(updatedStaff.getNgayVaoLam()));
            return "client/staff/profile/editprofile";
        }

        // Validate CCCD uniqueness
        if (updatedStaff.getCccd() != null && !updatedStaff.getCccd().equals(existingStaff.getCccd()) &&
                staffService.existsByCccdAndNotMaNV(updatedStaff.getCccd(), username)) {
            result.rejectValue("cccd", "error.staff", "CCCD đã tồn tại!");
            model.addAttribute("formattedNgayVaoLam", formatDate(updatedStaff.getNgayVaoLam()));
            return "client/staff/profile/editprofile";
        }

        // Update mutable fields
        existingStaff.setSdt(updatedStaff.getSdt());
        existingStaff.setEmail(updatedStaff.getEmail());
        existingStaff.setCccd(updatedStaff.getCccd());

        // Handle avatar upload
        if (!avatarFile.isEmpty()) {
            try {
                String avatarFileName = staffService.handleAvatarUpload(avatarFile, "avatars");
                if (avatarFileName.isEmpty()) {
                    result.rejectValue("avatar", "error.staff", "Không thể upload ảnh đại diện!");
                    model.addAttribute("formattedNgayVaoLam", formatDate(updatedStaff.getNgayVaoLam()));
                    return "client/staff/profile/editprofile";
                }
                existingStaff.setAvatar(avatarFileName);
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Không thể lưu ảnh đại diện: " + e.getMessage());
                return "redirect:/staff/profile";
            }
        }

        try {
            staffService.saveStaff(existingStaff);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin thành công!");
            return "redirect:/staff/profile";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật thông tin: " + e.getMessage());
            return "redirect:/staff/profile";
        }
    }

    // Show change password form
    @GetMapping("/profile/change-password")
    public String showChangePasswordForm() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Optional<Staff> staff = staffService.getStaffById(username);
        if (staff.isPresent() && "Giảng viên".equals(staff.get().getChucVu())) {
            return "client/staff/profile/changepassword";
        }
        return "redirect:/";
    }

    // Change password
    @PostMapping("/profile/change-password")
    public String changePassword(
            @RequestParam("oldPassword") String oldPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Optional<Staff> staffOpt = staffService.getStaffById(username);
        if (!staffOpt.isPresent() || !"Giảng viên".equals(staffOpt.get().getChucVu())) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thông tin giảng viên!");
            return "redirect:/staff/profile";
        }
        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu mới và xác nhận không khớp!");
            return "redirect:/staff/profile/change-password";
        }
        boolean changed = accountService.changePassword(username, oldPassword, newPassword);
        if (changed) {
            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công!");
            return "redirect:/staff/profile";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu cũ không đúng!");
            return "redirect:/staff/profile/change-password";
        }
    }
}