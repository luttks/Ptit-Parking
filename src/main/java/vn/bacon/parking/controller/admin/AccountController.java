package vn.bacon.parking.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import vn.bacon.parking.domain.Account;
import vn.bacon.parking.domain.Student;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.domain.Role;
import vn.bacon.parking.service.AccountService;
import vn.bacon.parking.service.StudentService;
import vn.bacon.parking.service.StaffService;
import vn.bacon.parking.repository.RoleRepository;

import jakarta.validation.Valid;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/account")
public class AccountController {

    private final AccountService accountService;
    private final StudentService studentService;
    private final StaffService staffService;
    private final RoleRepository roleRepository;

    public AccountController(AccountService accountService, StudentService studentService, StaffService staffService,
            RoleRepository roleRepository) {
        this.accountService = accountService;
        this.studentService = studentService;
        this.staffService = staffService;
        this.roleRepository = roleRepository;
    }

    @GetMapping
    public String listAccounts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String searchUsername,
            @RequestParam(required = false) Integer filterRoleId,
            Model model) {

        Pageable pageable = PageRequest.of(page, size);
        Page<Account> accountPage;

        if (searchUsername != null && !searchUsername.trim().isEmpty()) {
            accountPage = accountService.searchAccountsByUsername(searchUsername, pageable);
        } else if (filterRoleId != null) {
            accountPage = accountService.getAccountsByRoleId(filterRoleId, pageable);
        } else {
            accountPage = accountService.getAllAccounts(pageable);
        }

        model.addAttribute("accountPage", accountPage);
        model.addAttribute("searchUsername", searchUsername);
        model.addAttribute("filterRoleId", filterRoleId);
        model.addAttribute("roles", roleRepository.findAll());

        return "admin/account/show";
    }

    @GetMapping("/create/{id}")
    public String showCreateForm(@PathVariable String id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Student> student = studentService.getStudentById(id);
        Optional<Staff> staff = staffService.getStaffById(id);

        if (student.isPresent()) {
            if (accountService.existsByUsername(id)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Tài khoản đã tồn tại cho sinh viên " + id);
                return "redirect:/admin/student";
            }
            model.addAttribute("account", new Account());
            model.addAttribute("userType", "student");
            model.addAttribute("userId", id);
            model.addAttribute("roles", roleRepository.findAll());
            model.addAttribute("selectedRole", 3); // Default to ROLE_STUDENT
            return "admin/account/create";
        } else if (staff.isPresent()) {
            if (accountService.existsByUsername(id)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Tài khoản đã tồn tại cho nhân viên " + id);
                return "redirect:/admin/staff";
            }
            model.addAttribute("account", new Account());
            model.addAttribute("userType", "staff");
            model.addAttribute("userId", id);
            model.addAttribute("roles", roleRepository.findAll());
            model.addAttribute("selectedRole", staff.get().getChucVu().equals("Giảng viên") ? 4 : 2); // ROLE_TEACHER or
                                                                                                      // ROLE_EMPLOYEE
            return "admin/account/create";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Không tìm thấy sinh viên hoặc nhân viên với ID " + id);
            return "redirect:/admin";
        }
    }

    @PostMapping("/create")
    public String createAccount(@ModelAttribute("account") Account accountForm,
            @RequestParam String userType,
            @RequestParam String userId,
            @RequestParam(required = false) Integer roleId,
            RedirectAttributes redirectAttributes) {
        try {
            if (roleId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng chọn một vai trò.");
                return "redirect:/admin/account/create/" + userId;
            }
            if (userType.equals("student")) {
                Optional<Student> student = studentService.getStudentById(userId);
                if (student.isPresent()) {
                    accountService.createAccountForStudent(student.get(), roleId);
                    redirectAttributes.addFlashAttribute("successMessage",
                            "Tạo tài khoản cho sinh viên " + userId + " thành công");
                    return "redirect:/admin/student";
                } else {
                    throw new IllegalArgumentException("Sinh viên với ID " + userId + " không tồn tại");
                }
            } else if (userType.equals("staff")) {
                Optional<Staff> staff = staffService.getStaffById(userId);
                if (staff.isPresent()) {
                    accountService.createAccountForStaff(staff.get(), roleId);
                    redirectAttributes.addFlashAttribute("successMessage",
                            "Tạo tài khoản cho nhân viên " + userId + " thành công");
                    return "redirect:/admin/staff";
                } else {
                    throw new IllegalArgumentException("Nhân viên với ID " + userId + " không tồn tại");
                }
            } else {
                throw new IllegalArgumentException("Loại người dùng không hợp lệ: " + userType);
            }
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/" + userType;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi tạo tài khoản: " + e.getMessage());
            return "redirect:/admin/" + userType;
        }
    }

    @GetMapping("/update/{username}")
    public String showUpdateForm(@PathVariable String username, Model model, RedirectAttributes redirectAttributes) {
        Optional<Account> account = accountService.getAccountByUsername(username);
        if (account.isPresent()) {
            model.addAttribute("account", account.get());
            model.addAttribute("username", username);
            model.addAttribute("roles", roleRepository.findAll());
            model.addAttribute("selectedRole", account.get().getRole().getRoleID());
            return "admin/account/update";
        }
        redirectAttributes.addFlashAttribute("errorMessage", "Tài khoản không tồn tại");
        return "redirect:/admin";
    }

    @PostMapping("/update")
    public String updateAccount(@Valid @ModelAttribute("account") Account account,
            @RequestParam String newPassword,
            @RequestParam Boolean enabled,
            @RequestParam(required = false) Integer roleId,
            BindingResult result,
            RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "admin/account/update";
        }
        Optional<Account> existingAccount = accountService.getAccountByUsername(account.getUsername());
        if (!existingAccount.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Tài khoản không tồn tại");
            return "redirect:/admin";
        }
        try {
            if (roleId == null) {
                redirectAttributes.addFlashAttribute("errorMessage", "Vui lòng chọn một vai trò.");
                return "redirect:/admin/account/update/" + account.getUsername();
            }
            accountService.updateAccount(existingAccount.get(), newPassword, enabled, roleId);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Cập nhật tài khoản " + account.getUsername() + " thành công");
            // Redirect based on whether the account is for a student or staff
            String redirectUrl = accountService.isStudentAccount(existingAccount.get()) ? "/admin/student"
                    : "/admin/staff";
            return "redirect:" + redirectUrl;
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/account/update/" + account.getUsername();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi cập nhật tài khoản: " + e.getMessage());
            return "redirect:/admin/account/update/" + account.getUsername();
        }
    }

    @GetMapping("/delete/confirm/{username}")
    public String showDeleteConfirm(@PathVariable String username, Model model) {
        Optional<Account> account = accountService.getAccountByUsername(username);
        if (account.isPresent()) {
            model.addAttribute("username", username);
            String redirectAfterDelete = accountService.isStudentAccount(account.get())
                    ? "/admin/student/delete/confirm/" + username
                    : "/admin/staff/delete/confirm/" + username;
            model.addAttribute("redirectAfterDelete", redirectAfterDelete);
            return "admin/account/delete";
        }
        return "redirect:/admin";
    }

    @GetMapping("/delete/{username}")
    public String deleteAccount(@PathVariable String username, RedirectAttributes redirectAttributes) {
        Optional<Account> account = accountService.getAccountByUsername(username);
        if (account.isPresent()) {
            try {
                accountService.deleteAccountByUsername(username);
                redirectAttributes.addFlashAttribute("successMessage", "Xóa tài khoản " + username + " thành công");
                String redirectUrl = accountService.isStudentAccount(account.get())
                        ? "/admin/student/delete/confirm/" + username
                        : "/admin/staff/delete/confirm/" + username;
                return "redirect:" + redirectUrl;
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa tài khoản: " + e.getMessage());
                return "redirect:/admin/account/delete/confirm/" + username;
            }
        }
        redirectAttributes.addFlashAttribute("errorMessage", "Tài khoản không tồn tại");
        return "redirect:/admin";
    }
}