package vn.bacon.parking.service;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import vn.bacon.parking.domain.Student;
import vn.bacon.parking.domain.Class;
import vn.bacon.parking.repository.ClassRepository;
import vn.bacon.parking.repository.StudentRepository;
import vn.bacon.parking.repository.VehicleRepository;

@Service
public class StudentService {
    private static final Logger logger = LoggerFactory.getLogger(StudentService.class);

    private final StudentRepository studentRepository;
    private final UploadService uploadService;
    private final ClassRepository classRepository;
    private final AccountService accountService;
    private final VehicleRepository vehicleRepository;

    public StudentService(StudentRepository studentRepository, UploadService uploadService,
            ClassRepository classRepository, AccountService accountService, VehicleRepository vehicleRepository) {
        this.uploadService = uploadService;
        this.studentRepository = studentRepository;
        this.classRepository = classRepository;
        this.accountService = accountService;
        this.vehicleRepository = vehicleRepository;
    }

    public List<Student> getAllStudents() {
        return this.studentRepository.findAll();
    }

    public Student saveStudent(Student student) {

        // Kiểm tra xem sinh viên đã tồn tại trong cơ sở dữ liệu chưa
        Optional<Student> existingStudent = studentRepository.findById(student.getMaSV());

        // Nếu đây là cập nhật (sinh viên đã tồn tại) và maSV không thay đổi, bỏ qua
        // kiểm tra trùng lặp
        if (existingStudent.isPresent() && existingStudent.get().getMaSV().equals(student.getMaSV())) {

            return studentRepository.save(student);
        }

        // Nếu đây là tạo mới hoặc maSV thay đổi, kiểm tra trùng lặp
        if (existsByMaSV(student.getMaSV())) {
            throw new IllegalArgumentException("Mã sinh viên " + student.getMaSV() + " đã tồn tại!");
        }

        return studentRepository.save(student);
    }

    public Optional<Student> getStudentById(String maSV) {
        return this.studentRepository.findById(maSV);
    }

    public void deleteStudentById(String maSV) {
        logger.info("Đang cố gắng xóa sinh viên với maSV: {}", maSV);
        Optional<Student> studentOpt = studentRepository.findById(maSV);
        if (studentOpt.isPresent()) {
            Student student = studentOpt.get();

            // Kiểm tra tài khoản liên quan
            if (accountService.existsByUsername(maSV)) {
                logger.warn("Sinh viên với maSV {} vẫn có tài khoản liên quan", maSV);
                throw new IllegalStateException("Vui lòng xóa tài khoản liên quan trước khi xóa sinh viên");
            }

            // Kiểm tra xe đã đăng ký
            if (hasRegisteredVehicle(maSV)) {
                logger.warn("Sinh viên với maSV {} đã đăng ký xe", maSV);
                throw new IllegalStateException("Không thể xóa sinh viên vì sinh viên này đã đăng ký xe!");
            }

            // Ngắt tham chiếu với Class nếu không hợp lệ
            if (student.getLop() != null) {
                Optional<Class> classOpt = classRepository.findById(student.getLop().getMaLop());
                if (!classOpt.isPresent()) {
                    logger.warn("Lớp với maLop {} không tồn tại cho sinh viên {}", student.getLop().getMaLop(), maSV);
                    student.setLop(null);
                    studentRepository.save(student);
                }
            }

            studentRepository.deleteById(maSV);
            logger.info("Xóa sinh viên với maSV {} thành công", maSV);
        } else {
            logger.warn("Sinh viên với maSV {} không tồn tại", maSV);
            throw new IllegalStateException("Sinh viên với mã " + maSV + " không tồn tại!");
        }
    }

    public boolean hasRegisteredVehicle(String maSV) {
        return vehicleRepository.existsByMaSV_MaSV(maSV);
    }

    public Page<Student> getStudentPage(Pageable pageable, String maLop) {
        Pageable sortedByMaSVDesc = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(),
                Sort.by("maSV").descending());
        if (maLop != null && !maLop.isEmpty()) {
            return studentRepository.findByLopMaLop(maLop, sortedByMaSVDesc);
        }
        return studentRepository.findAll(sortedByMaSVDesc);
    }

    public List<Class> getAllClasses() {
        return classRepository.findAll(Sort.by("maLop").descending());
    }

    // Check if phone number exists
    public boolean existsBySdt(String sdt) {
        return studentRepository.existsBySdt(sdt);
    }

    // Check if email exists
    public boolean existsByEmail(String email) {
        return email != null && !email.isEmpty() && studentRepository.existsByEmail(email);
    }

    // Check if phone number exists for another student (used in update)
    public boolean existsBySdtAndNotMaSV(String sdt, String maSV) {
        return studentRepository.existsBySdtAndMaSVNot(sdt, maSV);
    }

    // Check if email exists for another student (used in update)
    public boolean existsByEmailAndNotMaSV(String email, String maSV) {
        return email != null && !email.isEmpty() && studentRepository.existsByEmailAndMaSVNot(email, maSV);
    }

    public String handleAvatarUpload(MultipartFile file, String targetFolder) {
        return uploadService.handleSaveUploadFile(file, targetFolder);
    }

    public boolean existsByMaSV(String maSV) {
        return studentRepository.existsById(maSV);
    }

    public Optional<Student> findByMaSV(String maSV) {
        return studentRepository.findById(maSV);
    }

    public String saveAvatar(MultipartFile file, String studentId) throws IOException {
        if (file.isEmpty()) {
            return "";
        }
        String fileName = studentId + "_" + System.currentTimeMillis() + "_" + file.getOriginalFilename();
        return uploadService.handleSaveUploadFile(file, "students");
    }

}
