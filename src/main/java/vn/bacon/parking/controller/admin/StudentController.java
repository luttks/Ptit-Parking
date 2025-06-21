
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
import vn.bacon.parking.domain.Student;
import vn.bacon.parking.service.AccountService;
import vn.bacon.parking.service.StudentService;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class StudentController {

    private final StudentService studentService;
    private final AccountService accountService;

    public StudentController(StudentService studentService, AccountService accountService) {
        this.accountService = accountService;
        this.studentService = studentService;
    }

    @GetMapping("/student")
    public String listStudents(@RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String maLop,
            Model model) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Student> studentPage = studentService.getStudentPage(pageable, maLop);
        model.addAttribute("studentPage", studentPage);
        model.addAttribute("classes", studentService.getAllClasses());
        model.addAttribute("selectedMaLop", maLop);
        return "admin/student/show";
    }

    @GetMapping("/student/create")
    public String showCreateForm(Model model) {
        model.addAttribute("student", new Student());
        model.addAttribute("classes", studentService.getAllClasses());
        return "admin/student/create";
    }

    @PostMapping("/student/create")
    public String createStudent(@Valid @ModelAttribute("student") Student student,
            BindingResult result,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/create";
        }

        // Check if maSV already exists
        if (studentService.existsByMaSV(student.getMaSV())) {
            result.rejectValue("maSV", "error.student", "Mã sinh viên đã tồn tại!");
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/create";
        }

        if (studentService.existsBySdt(student.getSdt())) {
            result.rejectValue("sdt", "error.student", "Số điện thoại đã tồn tại!");
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/create";
        }

        if (studentService.existsByEmail(student.getEmail())) {
            result.rejectValue("email", "error.student", "Email đã tồn tại!");
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/create";
        }

        if (!avatarFile.isEmpty()) {
            String avatarFileName = studentService.handleAvatarUpload(avatarFile, "students");
            if (avatarFileName.isEmpty()) {
                result.rejectValue("avatar", "error.student", "Không thể upload avatar!");
                model.addAttribute("classes", studentService.getAllClasses());
                return "admin/student/create";
            }
            student.setAvatar(avatarFileName);
        }

        try {
            studentService.saveStudent(student);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Thêm sinh viên " + student.getMaSV() + " thành công");
            return "redirect:/admin/student";
        } catch (IllegalArgumentException e) {
            result.rejectValue("maSV", "error.student", e.getMessage());
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/create";
        } catch (DataIntegrityViolationException e) {
            String message = e.getMostSpecificCause().getMessage();
            if (message.contains("SDT")) {
                result.rejectValue("sdt", "error.student", "Số điện thoại đã tồn tại!");
            } else if (message.contains("Email")) {
                result.rejectValue("email", "error.student", "Email đã tồn tại!");
            } else {
                result.rejectValue("maSV", "error.student", "Lỗi cơ sở dữ liệu: " + message);
            }
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/create";
        }
    }

    @GetMapping("/student/{maSV}")
    public String viewStudent(@PathVariable String maSV, Model model) {
        Optional<Student> student = studentService.getStudentById(maSV);
        if (student.isPresent()) {
            model.addAttribute("student", student.get());
            return "admin/student/view";
        }
        return "redirect:/admin/student";
    }

    @GetMapping("/student/update/{maSV}")
    public String showUpdateForm(@PathVariable String maSV, Model model) {
        Optional<Student> student = studentService.getStudentById(maSV);
        if (student.isPresent()) {
            Student s = student.get();
            System.out.println("Loading student with maSV: " + s.getMaSV() + ", ngaySinh: " + s.getNgaySinh());
            model.addAttribute("student", s);
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/update";
        }
        return "redirect:/admin/student";
    }

    @PostMapping("/student/update")
    public String updateStudent(@Valid @ModelAttribute("student") Student updatedStudent,
            BindingResult result,
            @RequestParam("avatarFile") MultipartFile avatarFile,
            Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/update";
        }

        Optional<Student> existingStudentOpt = studentService.getStudentById(updatedStudent.getMaSV());
        if (!existingStudentOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Sinh viên không tồn tại!");
            return "redirect:/admin/student";
        }
        Student existingStudent = existingStudentOpt.get();

        if (updatedStudent.getSdt() != null && !updatedStudent.getSdt().equals(existingStudent.getSdt()) &&
                studentService.existsBySdtAndNotMaSV(updatedStudent.getSdt(), updatedStudent.getMaSV())) {
            result.rejectValue("sdt", "error.student", "Số điện thoại đã tồn tại!");
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/update";
        }

        if (updatedStudent.getEmail() != null && !updatedStudent.getEmail().equals(existingStudent.getEmail()) &&
                studentService.existsByEmailAndNotMaSV(updatedStudent.getEmail(), updatedStudent.getMaSV())) {
            result.rejectValue("email", "error.student", "Email đã tồn tại!");
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/update";
        }

        existingStudent.setHoTen(updatedStudent.getHoTen());
        existingStudent.setDiaChi(updatedStudent.getDiaChi());
        existingStudent.setSdt(updatedStudent.getSdt());
        existingStudent.setEmail(updatedStudent.getEmail());
        existingStudent.setQueQuan(updatedStudent.getQueQuan());
        existingStudent.setLop(updatedStudent.getLop());

        if (updatedStudent.getNgaySinh() != null) {
            existingStudent.setNgaySinh(updatedStudent.getNgaySinh());
        }

        if (!avatarFile.isEmpty()) {
            String avatarFileName = studentService.handleAvatarUpload(avatarFile, "students");
            if (avatarFileName.isEmpty()) {
                result.rejectValue("avatar", "error.student", "Không thể upload avatar!");
                model.addAttribute("classes", studentService.getAllClasses());
                return "admin/student/update";
            }
            existingStudent.setAvatar(avatarFileName);
        }

        try {
            studentService.saveStudent(existingStudent);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Cập nhật sinh viên " + existingStudent.getMaSV() + " thành công");
            return "redirect:/admin/student";
        } catch (IllegalArgumentException e) {
            result.rejectValue("maSV", "error.student", e.getMessage());
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/update";
        } catch (DataIntegrityViolationException e) {
            String message = e.getMostSpecificCause().getMessage();
            if (message.contains("SDT")) {
                result.rejectValue("sdt", "error.student", "Số điện thoại đã tồn tại!");
            } else if (message.contains("Email")) {
                result.rejectValue("email", "error.student", "Email đã tồn tại!");
            } else {
                result.rejectValue("maSV", "error.student", "Lỗi cơ sở dữ liệu: " + message);
            }
            model.addAttribute("classes", studentService.getAllClasses());
            return "admin/student/update";
        }
    }

    @GetMapping("/student/delete/confirm/{maSV}")
    public String showDeleteConfirm(@PathVariable String maSV, Model model) {
        Optional<Student> student = studentService.getStudentById(maSV);
        if (student.isPresent()) {
            model.addAttribute("maSV", maSV);
            boolean hasAccount = accountService.existsByUsername(maSV);
            model.addAttribute("hasAccount", hasAccount);
            return "admin/student/delete";
        }
        return "redirect:/admin/student";
    }

    @GetMapping("/student/delete/{maSV}")
    public String deleteStudent(@PathVariable String maSV, RedirectAttributes redirectAttributes) {
        try {
            Optional<Student> studentOpt = studentService.getStudentById(maSV);
            if (studentOpt.isPresent()) {
                studentService.deleteStudentById(maSV);
                redirectAttributes.addFlashAttribute("successMessage", "Xóa sinh viên " + maSV + " thành công");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Sinh viên với mã " + maSV + " không tồn tại!");
            }
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/student/delete/confirm/" + maSV;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa sinh viên: " + e.getMessage());
            return "redirect:/admin/student/delete/confirm/" + maSV;
        }
        return "redirect:/admin/student";
    }
}
