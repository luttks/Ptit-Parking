package vn.bacon.parking.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import vn.bacon.parking.domain.Account;
import vn.bacon.parking.domain.Role;
import vn.bacon.parking.domain.Student;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.repository.AccountRepository;
import vn.bacon.parking.repository.RoleRepository;
import vn.bacon.parking.repository.StaffRepository;
import vn.bacon.parking.repository.StudentRepository;

import java.util.Optional;

@Service
public class AccountService {

    private final AccountRepository accountRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;
    private final StudentRepository studentRepository;
    private final StaffRepository staffRepository;

    public AccountService(AccountRepository accountRepository, RoleRepository roleRepository,
            PasswordEncoder passwordEncoder, StudentRepository studentRepository, StaffRepository staffRepository) {
        this.studentRepository = studentRepository;
        this.staffRepository = staffRepository;
        this.accountRepository = accountRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<Account> getAccountByUsername(String username) {
        return accountRepository.findById(username);
    }

    public Account saveAccount(Account account) {
        if (account.getMaSV() == null && account.getMaNV() == null) {
            throw new IllegalArgumentException("Either MaSV or MaNV must be non-null");
        }
        return accountRepository.save(account);
    }

    public void deleteAccountByUsername(String username) {
        Optional<Account> accountOpt = accountRepository.findById(username);
        if (accountOpt.isPresent()) {
            Account account = accountOpt.get();
            // Ngắt tham chiếu từ Student hoặc Staff
            if (account.getMaSV() != null) {
                Optional<Student> studentOpt = studentRepository.findById(account.getMaSV().getMaSV());
                if (studentOpt.isPresent()) {
                    Student student = studentOpt.get();
                    student.setAccount(null);
                    studentRepository.save(student);
                }
            } else if (account.getMaNV() != null) {
                Optional<Staff> staffOpt = staffRepository.findById(account.getMaNV().getMaNV());
                if (staffOpt.isPresent()) {
                    Staff staff = staffOpt.get();
                    staff.setAccount(null);
                    staffRepository.save(staff);
                }
            }
            // Xóa Account
            accountRepository.deleteById(username);
        }
    }

    public boolean existsByUsername(String username) {
        return accountRepository.existsByUsername(username);
    }

    public Account createAccountForStudent(Student student, Integer roleId) {
        if (student == null || student.getMaSV() == null || student.getMaSV().trim().isEmpty()) {
            throw new IllegalArgumentException("Student or MaSV cannot be null or empty");
        }
        if (existsByUsername(student.getMaSV())) {
            throw new IllegalStateException("Account already exists for MaSV: " + student.getMaSV());
        }
        Account account = new Account();
        account.setUsername(student.getMaSV());
        account.setPassword(passwordEncoder.encode("123"));
        account.setEnabled(true);
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid role ID: " + roleId));
        account.setRole(role);
        account.setMaSV(student);
        account.setMaNV(null);
        return saveAccount(account);
    }

    public Account createAccountForStaff(Staff staff, Integer roleId) {
        if (staff == null || staff.getMaNV() == null || staff.getMaNV().trim().isEmpty()) {
            throw new IllegalArgumentException("Staff or MaNV cannot be null or empty");
        }
        if (existsByUsername(staff.getMaNV())) {
            throw new IllegalStateException("Account already exists for MaNV: " + staff.getMaNV());
        }
        Account account = new Account();
        account.setUsername(staff.getMaNV());
        account.setPassword(passwordEncoder.encode("123"));
        account.setEnabled(true);
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new IllegalArgumentException("Invalid role ID: " + roleId));
        account.setRole(role);
        account.setMaNV(staff);
        account.setMaSV(null);
        return saveAccount(account);
    }

    public Account updateAccount(Account account, String newPassword, Boolean enabled, Integer roleId) {
        if (newPassword != null && !newPassword.isEmpty()) {
            account.setPassword(passwordEncoder.encode(newPassword));
        }
        if (enabled != null) {
            account.setEnabled(enabled);
        }
        if (roleId != null) {
            Role role = roleRepository.findById(roleId)
                    .orElseThrow(() -> new IllegalArgumentException("Invalid role ID: " + roleId));
            account.setRole(role);
        }
        return saveAccount(account);
    }

    public boolean isStudentAccount(Account account) {
        return account.getMaSV() != null;
    }

    public boolean changePassword(String username, String oldPassword, String newPassword) {
        Optional<Account> accountOpt = accountRepository.findById(username);
        if (!accountOpt.isPresent())
            return false;
        Account account = accountOpt.get();
        if (!passwordEncoder.matches(oldPassword, account.getPassword())) {
            return false;
        }
        account.setPassword(passwordEncoder.encode(newPassword));
        accountRepository.save(account);
        return true;
    }

    public Page<Account> getAllAccounts(Pageable pageable) {
        return accountRepository.findAll(pageable);
    }

    public Page<Account> searchAccountsByUsername(String username, Pageable pageable) {
        return accountRepository.findByUsernameContainingIgnoreCase(username, pageable);
    }

    public Page<Account> getAccountsByRoleId(Integer roleId, Pageable pageable) {
        return accountRepository.findByRole_RoleID(roleId, pageable);
    }
}