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
import vn.bacon.parking.domain.Student;
import vn.bacon.parking.service.StudentService;
import vn.bacon.parking.service.AccountService;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Controller
@RequestMapping("/student")
public class StudentProfileController {

    private final StudentService studentService;
    private final AccountService accountService;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public StudentProfileController(StudentService studentService, AccountService accountService) {
        this.studentService = studentService;
        this.accountService = accountService;
    }

    private String formatDate(LocalDate date) {
        return date != null ? date.format(DATE_FORMATTER) : "";
    }

    @GetMapping("/profile")
    public String viewProfile(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        Optional<Student> student = studentService.getStudentById(username);
        if (student.isPresent()) {
            model.addAttribute("student", student.get());
            model.addAttribute("formattedNgaySinh", formatDate(student.get().getNgaySinh()));
            return "client/student/profile/profile";
        }
        return "redirect:/";
    }

    @GetMapping("/profile/edit")
    public String showEditForm(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        Optional<Student> student = studentService.getStudentById(username);
        if (student.isPresent()) {
            model.addAttribute("student", student.get());
            model.addAttribute("formattedNgaySinh", formatDate(student.get().getNgaySinh()));
            model.addAttribute("classes", studentService.getAllClasses());
            return "client/student/profile/editprofile";
        }
        return "redirect:/student/profile";
    }

    @PostMapping("/profile/edit")
    public String updateProfile(
            @Valid @ModelAttribute("student") Student updatedStudent,
            BindingResult result,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            model.addAttribute("formattedNgaySinh", formatDate(updatedStudent.getNgaySinh()));
            model.addAttribute("classes", studentService.getAllClasses());
            return "client/student/profile/editprofile";
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();

        Optional<Student> existingStudentOpt = studentService.getStudentById(username);
        if (!existingStudentOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thông tin sinh viên!");
            return "redirect:/student/profile";
        }

        Student existingStudent = existingStudentOpt.get();

        if (updatedStudent.getSdt() != null && !updatedStudent.getSdt().equals(existingStudent.getSdt()) &&
                studentService.existsBySdtAndNotMaSV(updatedStudent.getSdt(), username)) {
            result.rejectValue("sdt", "error.student", "Số điện thoại đã tồn tại!");
            model.addAttribute("formattedNgaySinh", formatDate(updatedStudent.getNgaySinh()));
            model.addAttribute("classes", studentService.getAllClasses());
            return "client/student/profile/editprofile";
        }

        if (updatedStudent.getEmail() != null && !updatedStudent.getEmail().equals(existingStudent.getEmail()) &&
                studentService.existsByEmailAndNotMaSV(updatedStudent.getEmail(), username)) {
            result.rejectValue("email", "error.student", "Email đã tồn tại!");
            model.addAttribute("formattedNgaySinh", formatDate(updatedStudent.getNgaySinh()));
            model.addAttribute("classes", studentService.getAllClasses());
            return "client/student/profile/editprofile";
        }

        // Cập nhật tất cả các trường thông tin
        existingStudent.setHoTen(updatedStudent.getHoTen());
        existingStudent.setNgaySinh(updatedStudent.getNgaySinh());
        existingStudent.setDiaChi(updatedStudent.getDiaChi());
        existingStudent.setSdt(updatedStudent.getSdt());
        existingStudent.setEmail(updatedStudent.getEmail());
        existingStudent.setQueQuan(updatedStudent.getQueQuan());
        existingStudent.setLop(updatedStudent.getLop());

        if (!avatarFile.isEmpty()) {
            String avatarFileName = studentService.handleAvatarUpload(avatarFile, "students");
            if (avatarFileName.isEmpty()) {
                result.rejectValue("avatar", "error.student", "Không thể upload avatar!");
                model.addAttribute("formattedNgaySinh", formatDate(updatedStudent.getNgaySinh()));
                model.addAttribute("classes", studentService.getAllClasses());
                return "client/student/profile/editprofile";
            }
            existingStudent.setAvatar(avatarFileName);
        }

        try {
            studentService.saveStudent(existingStudent);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin thành công!");
            return "redirect:/student/profile";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật thông tin: " + e.getMessage());
            return "redirect:/student/profile";
        }
    }

    // Show change password form
    @GetMapping("/profile/change-password")
    public String showChangePasswordForm() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Optional<Student> student = studentService.getStudentById(username);
        if (student.isPresent()) {
            return "client/student/profile/changepassword";
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
        Optional<Student> studentOpt = studentService.getStudentById(username);
        if (!studentOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy thông tin sinh viên!");
            return "redirect:/student/profile";
        }
        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu mới và xác nhận không khớp!");
            return "redirect:/student/profile/change-password";
        }
        boolean changed = accountService.changePassword(username, oldPassword, newPassword);
        if (changed) {
            redirectAttributes.addFlashAttribute("successMessage", "Đổi mật khẩu thành công!");
            return "redirect:/student/profile";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Mật khẩu cũ không đúng!");
            return "redirect:/student/profile/change-password";
        }
    }
}
