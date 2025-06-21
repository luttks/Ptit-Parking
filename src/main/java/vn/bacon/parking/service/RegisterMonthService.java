package vn.bacon.parking.service;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.domain.RegisterMonth;
import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.repository.ParkingModeRepository;
import vn.bacon.parking.repository.PriceRepository;
import vn.bacon.parking.repository.RegisterMonthRepository;

@Service
public class RegisterMonthService {
    private final RegisterMonthRepository registerMonthRepository;
    private final JavaMailSender mailSender;
    private final ParkingModeRepository parkingModeRepository;
    private final PriceRepository priceRepository;

    public RegisterMonthService(
            RegisterMonthRepository registerMonthRepository,
            JavaMailSender mailSender,
            ParkingModeRepository parkingModeRepository,
            PriceRepository priceRepository) {
        this.registerMonthRepository = registerMonthRepository;
        this.mailSender = mailSender;
        this.parkingModeRepository = parkingModeRepository;
        this.priceRepository = priceRepository;
    }

    public RegisterMonth createRegistration(RegisterMonth registration) {
        if (registration.getBienSoXe() == null) {
            throw new IllegalArgumentException("Xe là bắt buộc.");
        }
        if (registration.getGia() == null || registration.getGia() <= 0) {
            throw new IllegalArgumentException("Giá tiền không được để trống hoặc không hợp lệ.");
        }
        if (registration.getNgayBatDau() == null || registration.getNgayKetThuc() == null) {
            throw new IllegalArgumentException("Ngày bắt đầu và ngày kết thúc không được để trống.");
        }

        // Check for overlapping date ranges
        String bienSoXe = registration.getBienSoXe().getBienSoXe();
        LocalDate ngayBatDau = registration.getNgayBatDau();
        LocalDate ngayKetThuc = registration.getNgayKetThuc();
        if (registerMonthRepository.existsByBienSoXe_BienSoXeAndDateRangeOverlap(bienSoXe, ngayBatDau, ngayKetThuc)) {
            throw new IllegalArgumentException(
                    "Xe này đã có đăng ký trong khoảng thời gian từ " + ngayBatDau + " đến " + ngayKetThuc + ".");
        }

        Vehicle vehicle = registration.getBienSoXe();
        ParkingMode hinhThuc = parkingModeRepository.findById("HT002")
                .orElseThrow(() -> new IllegalArgumentException("Hình thức gửi tháng (HT002) không tồn tại."));
        Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc, vehicle.getMaLoaiXe());
        if (price == null) {
            throw new IllegalArgumentException(
                    "Không tìm thấy giá cho xe " + vehicle.getBienSoXe() + " với hình thức gửi tháng.");
        }
        registration.setBangGia(price);

        return registerMonthRepository.save(registration);
    }

    // New method to check for valid and approved monthly registration
    public boolean hasValidApprovedMonthlyRegistration(String bienSoXe) {
        LocalDate today = LocalDate.now();
        return registerMonthRepository
                .existsByBienSoXe_BienSoXeAndTrangThaiAndNgayBatDauLessThanEqualAndNgayKetThucGreaterThanEqual(
                        bienSoXe, "Đã duyệt", today, today);
    }

    // Existing method (updated to exclude "Chờ duyệt" if needed)
    public boolean hasActiveRegistrationForVehicle(String bienSoXe) {
        return registerMonthRepository.existsByBienSoXe_BienSoXeAndTrangThaiInAndNgayKetThucGreaterThanEqual(
                bienSoXe, Arrays.asList("Đã duyệt"), LocalDate.now());
    }

    public boolean hasActiveRegistrationForVehicleExcludingId(String bienSoXe, String maDangKy) {
        return registerMonthRepository
                .existsByBienSoXe_BienSoXeAndMaDangKyNotAndTrangThaiInAndNgayKetThucGreaterThanEqual(
                        bienSoXe, maDangKy, Arrays.asList("Chờ duyệt", "Đã duyệt"), LocalDate.now());
    }

    // Updated to check for overlapping registrations
    public boolean hasOverlappingRegistration(String bienSoXe, LocalDate ngayBatDau, LocalDate ngayKetThuc) {
        return registerMonthRepository.existsByBienSoXe_BienSoXeAndDateRangeOverlap(
                bienSoXe, ngayBatDau, ngayKetThuc);
    }

    // Updated to check for overlapping registrations excluding a specific maDangKy
    public boolean hasOverlappingRegistrationExcludingId(String bienSoXe, String maDangKy, LocalDate ngayBatDau,
            LocalDate ngayKetThuc) {
        return registerMonthRepository.existsByBienSoXe_BienSoXeAndMaDangKyNotAndDateRangeOverlap(
                bienSoXe, maDangKy, ngayBatDau, ngayKetThuc);
    }

    // New method to validate new registration date range
    public boolean isValidNewRegistrationDateRange(String bienSoXe, LocalDate ngayBatDau, LocalDate ngayKetThuc) {
        // Check for overlap with any existing registration
        if (hasOverlappingRegistration(bienSoXe, ngayBatDau, ngayKetThuc)) {
            return false;
        }

        // Find the latest ngayKetThuc for the vehicle
        Optional<LocalDate> latestKetThuc = registerMonthRepository.findLatestNgayKetThucByBienSoXe(bienSoXe);
        if (latestKetThuc.isPresent()) {
            // New ngayBatDau must be after or on the latest ngayKetThuc
            return !ngayBatDau.isBefore(latestKetThuc.get());
        }

        // No existing registrations, any future date is valid
        return true;
    }

    public List<RegisterMonth> getRegistrationsByVehicleId(String bienSoXe) {
        return registerMonthRepository.findByBienSoXe_BienSoXe(bienSoXe);
    }

    public Optional<RegisterMonth> getRegistrationById(String maDangKy) {
        return registerMonthRepository.findById(maDangKy);
    }

    public String getNextMaDangKy() {
        Long maxId = registerMonthRepository.findMaxMaDangKy();
        return String.valueOf(maxId != null ? maxId + 1 : 1);
    }

    @Transactional
    public RegisterMonth updateRegistration(RegisterMonth registration) {
        if (registration.getMaDangKy() == null) {
            throw new IllegalArgumentException("Mã đăng ký không được để trống.");
        }
        if (registration.getBienSoXe() == null) {
            throw new IllegalArgumentException("Xe là bắt buộc.");
        }
        if (registration.getGia() == null || registration.getGia() <= 0) {
            throw new IllegalArgumentException("Giá tiền không được để trống hoặc không hợp lệ.");
        }
        if (registration.getNgayBatDau() == null || registration.getNgayKetThuc() == null) {
            throw new IllegalArgumentException("Ngày bắt đầu và ngày kết thúc không được để trống.");
        }

        // Check for overlapping date ranges, excluding the current registration
        String bienSoXe = registration.getBienSoXe().getBienSoXe();
        String maDangKy = registration.getMaDangKy();
        LocalDate ngayBatDau = registration.getNgayBatDau();
        LocalDate ngayKetThuc = registration.getNgayKetThuc();
        if (registerMonthRepository.existsByBienSoXe_BienSoXeAndMaDangKyNotAndDateRangeOverlap(
                bienSoXe, maDangKy, ngayBatDau, ngayKetThuc)) {
            throw new IllegalArgumentException(
                    "Xe này đã có đăng ký khác trong khoảng thời gian từ " + ngayBatDau + " đến " + ngayKetThuc + ".");
        }

        Vehicle vehicle = registration.getBienSoXe();
        ParkingMode hinhThuc = parkingModeRepository.findById("HT002")
                .orElseThrow(() -> new IllegalArgumentException("Hình thức gửi tháng (HT002) không tồn tại."));
        Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc, vehicle.getMaLoaiXe());
        if (price == null) {
            throw new IllegalArgumentException(
                    "Không tìm thấy giá cho xe " + vehicle.getBienSoXe() + " với hình thức gửi tháng.");
        }
        registration.setBangGia(price);

        return registerMonthRepository.save(registration);
    }

    public List<RegisterMonth> getAllRegisterMonths() {
        return registerMonthRepository.findAll();
    }

    public void deleteRegisterMonthById(String maDangKy) {
        try {
            registerMonthRepository.deleteById(maDangKy);
        } catch (Exception e) {
            throw new RuntimeException("Không thể xóa đăng ký tháng. Có thể do ràng buộc dữ liệu.", e);
        }
    }

    public List<RegisterMonth> timKiemTheoBienSoXe(String tuKhoa) {
        return registerMonthRepository.timKiemTheoBienSoXe(tuKhoa);
    }

    public List<RegisterMonth> timDangKyConHieuLuc() {
        return registerMonthRepository.timDangKyConHieuLuc(LocalDate.now());
    }

    public List<RegisterMonth> timDangKyDaHetHan() {
        return registerMonthRepository.timDangKyDaHetHan(LocalDate.now());
    }

    public List<RegisterMonth> getRegisterMonthsExpiringSoon() {
        LocalDate now = LocalDate.now();
        LocalDate soon = now.plusDays(5);
        return registerMonthRepository.findAll().stream()
                .filter(dk -> !dk.getNgayKetThuc().isBefore(now) && !dk.getNgayKetThuc().isAfter(soon))
                .toList();
    }

    public RegisterMonth saveRegisterMonth(RegisterMonth registerMonth) {
        if (registerMonth.getNgayDangKy().isAfter(registerMonth.getNgayKetThuc())) {
            throw new IllegalArgumentException("Ngày đăng ký phải trước ngày kết thúc.");
        }
        if (registerMonth.getBienSoXe() == null || registerMonth.getBienSoXe().getBienSoXe() == null
                || registerMonth.getBienSoXe().getBienSoXe().trim().isEmpty()) {
            throw new IllegalArgumentException("Biển số xe không được để trống.");
        }
        return registerMonthRepository.save(registerMonth);
    }

    public RegisterMonth giaHanDangKy(String maDangKy, int soThang) {
        if (soThang != 1 && soThang != 6 && soThang != 12) {
            throw new IllegalArgumentException("Thời gian gia hạn phải là 1, 6 hoặc 12 tháng");
        }

        RegisterMonth registerMonth = registerMonthRepository.findById(maDangKy)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký tháng"));
        LocalDate ngayKetThucMoi = registerMonth.getNgayKetThuc().plusMonths(soThang);
        registerMonth.setNgayKetThuc(ngayKetThucMoi);
        return registerMonthRepository.save(registerMonth);
    }

    public void testGuiEmailThongBao(String maDangKy) {
        RegisterMonth registerMonth = registerMonthRepository.findById(maDangKy)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đăng ký tháng"));
        guiEmailThongBao(registerMonth);
    }

    private void guiEmailThongBao(RegisterMonth registerMonth) {
        SimpleMailMessage message = new SimpleMailMessage();
        String email = "";
        String ten = "";
        if (registerMonth.getBienSoXe().getMaNV() != null) {
            email = registerMonth.getBienSoXe().getMaNV().getEmail();
            ten = registerMonth.getBienSoXe().getMaNV().getHoTen();
        } else if (registerMonth.getBienSoXe().getMaSV() != null) {
            email = registerMonth.getBienSoXe().getMaSV().getEmail();
            ten = registerMonth.getBienSoXe().getMaSV().getHoTen();
        }
        message.setTo(email);
        message.setSubject("Thông báo sắp hết hạn đăng ký tháng");
        message.setText(String.format(
                "Kính gửi %s,\n\n" +
                        "Đăng ký tháng của xe %s sẽ hết hạn vào ngày %s.\n" +
                        "Vui lòng gia hạn trước ngày hết hạn để tránh gián đoạn dịch vụ.\n\n" +
                        "Trân trọng,\n" +
                        "Hệ thống quản lý bãi đỗ xe",
                ten,
                registerMonth.getBienSoXe().getBienSoXe(),
                registerMonth.getNgayKetThuc().toString()));
        mailSender.send(message);
    }

    @Scheduled(cron = "0 0 9 * * ?")
    public void kiemTraVaGuiThongBao() {
        LocalDate ngayHienTai = LocalDate.now();
        LocalDate ngayCanhBao = ngayHienTai.plusDays(5);
        List<RegisterMonth> dangKySapHetHan = registerMonthRepository.findAll().stream()
                .filter(dk -> dk.getNgayKetThuc().equals(ngayCanhBao))
                .toList();
        dangKySapHetHan.forEach(this::guiEmailThongBao);
    }

    public Page<RegisterMonth> getRegisterMonthPage(Pageable pageable) {
        return registerMonthRepository.findAll(pageable);
    }

    public Page<RegisterMonth> getActiveRegisterMonthPage(Pageable pageable) {
        return registerMonthRepository.findByNgayKetThucGreaterThanEqual(LocalDate.now(), pageable);
    }

    public Page<RegisterMonth> getExpiredRegisterMonthPage(Pageable pageable) {
        return registerMonthRepository.findByNgayKetThucLessThan(LocalDate.now(), pageable);
    }

    

}