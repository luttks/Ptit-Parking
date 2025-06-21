package vn.bacon.parking.controller.client;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.domain.RegisterMonth;
import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.repository.ParkingModeRepository;
import vn.bacon.parking.repository.PriceRepository;
import vn.bacon.parking.service.RegisterMonthService;
import vn.bacon.parking.service.VehicleService;

@Controller
@RequestMapping("/student")
public class MonthlyRegistrationController {

    private static final Logger logger = LoggerFactory.getLogger(MonthlyRegistrationController.class);

    private final RegisterMonthService registerMonthService;
    private final VehicleService vehicleService;
    private final PriceRepository priceRepository;
    private final ParkingModeRepository parkingModeRepository;

    public MonthlyRegistrationController(
            RegisterMonthService registerMonthService,
            VehicleService vehicleService,
            PriceRepository priceRepository,
            ParkingModeRepository parkingModeRepository) {
        this.registerMonthService = registerMonthService;
        this.vehicleService = vehicleService;
        this.priceRepository = priceRepository;
        this.parkingModeRepository = parkingModeRepository;
    }

    @GetMapping("/request-monthly-registration")
    public String showForm(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String maSV = auth.getName().trim();
        Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStudentId(maSV, PageRequest.of(0, Integer.MAX_VALUE));
        List<Vehicle> vehicles = vehiclePage.getContent();
        model.addAttribute("registration", new RegisterMonth());
        model.addAttribute("vehicles", vehicles);
        model.addAttribute("maSV", maSV);
        return "client/student/request-monthly-registration/request";
    }

    @PostMapping("/request-monthly-registration")
    public String submitRequest(
            @RequestParam String bienSoXe,
            @RequestParam("ngayBatDau") String ngayBatDau,
            @RequestParam("soThang") int soThang,
            Model model) {
        logger.info("Đang xử lý yêu cầu POST cho /student/request-monthly-registration");
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String maSV = auth.getName().trim();

        try {
            // Validate inputs
            if (bienSoXe == null || bienSoXe.trim().isEmpty()) {
                throw new IllegalArgumentException("Biển số xe không được để trống.");
            }
            if (ngayBatDau == null || ngayBatDau.trim().isEmpty()) {
                throw new IllegalArgumentException("Ngày bắt đầu không được để trống.");
            }
            if (soThang != 1 && soThang != 3 && soThang != 6) {
                throw new IllegalArgumentException("Số tháng phải là 1, 3 hoặc 6.");
            }

            String maDangKy = registerMonthService.getNextMaDangKy();
            LocalDate ngayDangKy = LocalDate.now();
            LocalDate parsedNgayBatDau = LocalDate.parse(ngayBatDau);
            LocalDate ngayKetThuc = parsedNgayBatDau.plusMonths(soThang);

            Vehicle vehicle = vehicleService.getVehicleById(bienSoXe)
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy xe với biển số: " + bienSoXe));

            // Kiểm tra quyền sở hữu xe
            if (vehicle.getMaSV() == null || !vehicle.getMaSV().getMaSV().trim().equals(maSV)) {
                throw new IllegalArgumentException("Bạn không sở hữu xe này.");
            }

            RegisterMonth registration = new RegisterMonth();
            registration.setMaDangKy(maDangKy);
            registration.setBienSoXe(vehicle);
            registration.setNgayDangKy(ngayDangKy);
            registration.setNgayBatDau(parsedNgayBatDau);
            registration.setNgayKetThuc(ngayKetThuc);
            registration.setTrangThai("Chờ duyệt");

            ParkingMode hinhThuc = parkingModeRepository.findById("HT002")
                    .orElseThrow(() -> new IllegalArgumentException("Hình thức gửi tháng (HT002) không tồn tại."));
            Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc, vehicle.getMaLoaiXe());
            if (price == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy giá cho xe " + bienSoXe + " với hình thức gửi tháng.");
            }
            registration.setBangGia(price);
            registration.setGia(price.getGia() * soThang);

            registerMonthService.createRegistration(registration);
            model.addAttribute("message", "Yêu cầu đã được gửi thành công!");
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStudentId(maSV,
                    PageRequest.of(0, Integer.MAX_VALUE));
            List<Vehicle> vehicles = vehiclePage.getContent();
            model.addAttribute("registration", new RegisterMonth());
            model.addAttribute("vehicles", vehicles);
            model.addAttribute("maSV", maSV);
            return "client/student/request-monthly-registration/request";
        } catch (Exception e) {
            logger.error("Lỗi khi gửi yêu cầu đăng ký: {}", e.getMessage(), e);
            model.addAttribute("error", "Đã xảy ra lỗi bất ngờ: " + e.getMessage());
            Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStudentId(maSV,
                    PageRequest.of(0, Integer.MAX_VALUE));
            List<Vehicle> vehicles = vehiclePage.getContent();
            model.addAttribute("registration", new RegisterMonth());
            model.addAttribute("vehicles", vehicles);
            model.addAttribute("maSV", maSV);
            return "client/student/request-monthly-registration/request";
        }
        return "client/student/request-monthly-registration/request";
    }

    @GetMapping("/request-monthly-registration/edit")
    public String showEditForm(@RequestParam String maDangKy, Model model, RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String maSV = auth.getName().trim();
        String trimmedMaDangKy = maDangKy.trim();
        logger.info("Đang cố gắng chỉnh sửa đăng ký với Mã: '{}', đã trim: '{}', cho sinh viên: '{}'", maDangKy,
                trimmedMaDangKy, maSV);

        Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
        if (!registrationOpt.isPresent()) {
            logger.warn("Không tìm thấy đăng ký với Mã: '{}'", trimmedMaDangKy);
            redirectAttributes.addFlashAttribute("errorMessage", "Đăng ký không tồn tại!");
            return "redirect:/student/request-history";
        }

        RegisterMonth registration = registrationOpt.get();
        String requestMaSV = registration.getBienSoXe().getMaSV() != null
                ? registration.getBienSoXe().getMaSV().getMaSV().trim()
                : null;
        if (requestMaSV == null || !requestMaSV.equals(maSV)) {
            logger.warn("Sinh viên '{}' không sở hữu đăng ký '{}'. MaSV của xe: '{}'", maSV, trimmedMaDangKy,
                    requestMaSV);
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền chỉnh sửa đăng ký này!");
            return "redirect:/student/request-history";
        }

        if (!"Chờ duyệt".equals(registration.getTrangThai())) {
            logger.warn("Đăng ký {} có trạng thái '{}', không phải 'Chờ duyệt'", trimmedMaDangKy,
                    registration.getTrangThai());
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Chỉ có thể chỉnh sửa đăng ký đang ở trạng thái 'Chờ duyệt'!");
            return "redirect:/student/request-history";
        }

        // Calculate soThang
        long soThang = java.time.temporal.ChronoUnit.MONTHS.between(
                registration.getNgayBatDau().withDayOfMonth(1),
                registration.getNgayKetThuc().withDayOfMonth(1));
        if (soThang != 1 && soThang != 3 && soThang != 6) {
            soThang = 1; // Default to 1 if invalid
        }

        Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStudentId(maSV, PageRequest.of(0, Integer.MAX_VALUE));
        List<Vehicle> vehicles = vehiclePage.getContent();
        model.addAttribute("registration", registration);
        model.addAttribute("vehicles", vehicles);
        model.addAttribute("maSV", maSV);
        model.addAttribute("soThang", soThang);
        return "client/student/request-monthly-registration/edit";
    }

    @PostMapping("/request-monthly-registration/edit")
    public String updateRequest(
            @RequestParam String maDangKy,
            @RequestParam String bienSoXe,
            @RequestParam("ngayBatDau") String ngayBatDau,
            @RequestParam("soThang") int soThang,
            Model model,
            RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String maSV = auth.getName().trim();
        String trimmedMaDangKy = maDangKy != null ? maDangKy.trim() : "";
        logger.info(
                "Đang cập nhật đăng ký với Mã: '{}', đã trim: '{}', cho sinh viên: '{}', bienSoXe: '{}', ngayBatDau: '{}', soThang: '{}'",
                maDangKy, trimmedMaDangKy, maSV, bienSoXe, ngayBatDau, soThang);

        try {
            if (trimmedMaDangKy.isEmpty()) {
                throw new IllegalArgumentException("Mã đăng ký không được để trống.");
            }
            if (bienSoXe == null || bienSoXe.trim().isEmpty()) {
                throw new IllegalArgumentException("Biển số xe không được để trống.");
            }
            if (ngayBatDau == null || ngayBatDau.trim().isEmpty()) {
                throw new IllegalArgumentException("Ngày bắt đầu không được để trống.");
            }
            if (soThang != 1 && soThang != 3 && soThang != 6) {
                throw new IllegalArgumentException("Số tháng phải là 1, 3 hoặc 6.");
            }

            Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
            if (!registrationOpt.isPresent()) {
                logger.warn("Không tìm thấy đăng ký với Mã: '{}'", trimmedMaDangKy);
                redirectAttributes.addFlashAttribute("errorMessage", "Đăng ký không tồn tại!");
                return "redirect:/student/request-history";
            }

            RegisterMonth existingRegistration = registrationOpt.get();
            String requestMaSV = existingRegistration.getBienSoXe().getMaSV() != null
                    ? existingRegistration.getBienSoXe().getMaSV().getMaSV().trim()
                    : null;
            if (requestMaSV == null || !requestMaSV.equals(maSV)) {
                logger.warn("Sinh viên '{}' không sở hữu đăng ký '{}'. MaSV của xe: '{}'", maSV, trimmedMaDangKy,
                        requestMaSV);
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền chỉnh sửa đăng ký này!");
                return "redirect:/student/request-history";
            }

            if (!"Chờ duyệt".equals(existingRegistration.getTrangThai())) {
                logger.warn("Đăng ký {} có trạng thái '{}', không phải 'Chờ duyệt'", trimmedMaDangKy,
                        existingRegistration.getTrangThai());
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Chỉ có thể chỉnh sửa đăng ký đang ở trạng thái 'Chờ duyệt'!");
                return "redirect:/student/request-history";
            }

            LocalDate parsedNgayBatDau = LocalDate.parse(ngayBatDau);
            LocalDate ngayKetThuc = parsedNgayBatDau.plusMonths(soThang);

            Vehicle vehicle = vehicleService.getVehicleById(bienSoXe)
                    .orElseThrow(() -> new IllegalArgumentException("Xe không tồn tại với biển số: " + bienSoXe));

            if (vehicle.getMaSV() == null || !vehicle.getMaSV().getMaSV().trim().equals(maSV)) {
                throw new IllegalArgumentException("Bạn không sở hữu xe này.");
            }

            existingRegistration.setBienSoXe(vehicle);
            existingRegistration.setNgayBatDau(parsedNgayBatDau);
            existingRegistration.setNgayKetThuc(ngayKetThuc);
            existingRegistration.setNgayDangKy(LocalDate.now());

            ParkingMode hinhThuc = parkingModeRepository.findById("HT002")
                    .orElseThrow(() -> new IllegalArgumentException("Hình thức gửi tháng (HT002) không tồn tại."));
            Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc, vehicle.getMaLoaiXe());
            if (price == null) {
                throw new IllegalArgumentException(
                        "Không tìm thấy giá cho xe " + bienSoXe + " với hình thức gửi tháng.");
            }
            existingRegistration.setBangGia(price);
            existingRegistration.setGia(price.getGia() * soThang);

            registerMonthService.updateRegistration(existingRegistration);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật đăng ký thành công!");
            return "redirect:/student/request-history";
        } catch (IllegalArgumentException e) {
            logger.error("Lỗi tham số khi cập nhật đăng ký: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            List<Vehicle> vehicles = vehicleService.getVehiclesByStudentId(maSV, PageRequest.of(0, Integer.MAX_VALUE))
                    .getContent();
            Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
            model.addAttribute("registration", registrationOpt.orElse(new RegisterMonth()));
            model.addAttribute("vehicles", vehicles);
            model.addAttribute("maSV", maSV);
            return "client/student/request-monthly-registration/edit";
        } catch (Exception e) {
            logger.error("Lỗi bất ngờ khi cập nhật đăng ký: {}", e.getMessage(), e);
            model.addAttribute("error", "Lỗi khi cập nhật đăng ký: " + e.getMessage());
            List<Vehicle> vehicles = vehicleService.getVehiclesByStudentId(maSV, PageRequest.of(0, Integer.MAX_VALUE))
                    .getContent();
            Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
            model.addAttribute("registration", registrationOpt.orElse(new RegisterMonth()));
            model.addAttribute("vehicles", vehicles);
            model.addAttribute("maSV", maSV);
            return "client/student/request-monthly-registration/edit";
        }
    }

    @GetMapping("/request-history")
    public String viewRequestHistory(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String maSV = auth.getName().trim();
        List<Vehicle> vehicles = vehicleService.getVehiclesByStudentId(maSV, PageRequest.of(0, Integer.MAX_VALUE))
                .getContent();
        // Lấy tất cả đăng ký của các xe thuộc sinh viên
        List<RegisterMonth> registrations = vehicles.stream()
                .flatMap(v -> registerMonthService.getRegistrationsByVehicleId(v.getBienSoXe()).stream())
                .toList();
        model.addAttribute("registrations", registrations);
        model.addAttribute("maSV", maSV);
        return "client/student/request-monthly-registration/history";
    }

    @GetMapping("/request-monthly-registration/delete")
    public String deleteRequest(
            @RequestParam String maDangKy,
            RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String maSV = auth.getName().trim();
        String trimmedMaDangKy = maDangKy.trim();
        logger.info("Đang cố gắng xóa đăng ký với Mã: '{}', đã trim: '{}', cho sinh viên: '{}'", maDangKy,
                trimmedMaDangKy, maSV);

        try {
            Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
            if (!registrationOpt.isPresent()) {
                logger.warn("Không tìm thấy đăng ký với Mã: '{}'", trimmedMaDangKy);
                redirectAttributes.addFlashAttribute("errorMessage", "Đăng ký không tồn tại!");
                return "redirect:/student/request-history";
            }

            RegisterMonth registration = registrationOpt.get();
            // Kiểm tra quyền sở hữu xe
            String requestMaSV = registration.getBienSoXe().getMaSV() != null
                    ? registration.getBienSoXe().getMaSV().getMaSV().trim()
                    : null;
            if (requestMaSV == null || !requestMaSV.equals(maSV)) {
                logger.warn("Sinh viên '{}' không sở hữu đăng ký '{}'. MaSV của xe: '{}'", maSV, trimmedMaDangKy,
                        requestMaSV);
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền xóa đăng ký này!");
                return "redirect:/student/request-history";
            }

            // Kiểm tra trạng thái "Chờ duyệt"
            if (!"Chờ duyệt".equals(registration.getTrangThai())) {
                logger.warn("Đăng ký {} có trạng thái '{}', không phải 'Chờ duyệt'", trimmedMaDangKy,
                        registration.getTrangThai());
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Chỉ có thể xóa đăng ký đang ở trạng thái 'Chờ duyệt'!");
                return "redirect:/student/request-history";
            }

            // Xóa đăng ký
            registerMonthService.deleteRegisterMonthById(trimmedMaDangKy);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa đăng ký thành công!");
        } catch (Exception e) {
            logger.error("Lỗi khi xóa đăng ký '{}': {}", trimmedMaDangKy, e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Lỗi khi xóa đăng ký: " + e.getMessage());
        }
        return "redirect:/student/request-history";
    }

    @GetMapping("/request-monthly-registration/view")
    public String viewRegistration(@RequestParam String maDangKy, Model model, RedirectAttributes redirectAttributes) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) {
            return "redirect:/login";
        }
        String maSV = auth.getName().trim();
        String trimmedMaDangKy = maDangKy.trim();
        logger.info("Đang xem đăng ký với Mã: '{}', đã trim: '{}', cho sinh viên: '{}'", maDangKy, trimmedMaDangKy,
                maSV);

        Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
        if (!registrationOpt.isPresent()) {
            logger.warn("Không tìm thấy đăng ký với Mã: '{}'", trimmedMaDangKy);
            redirectAttributes.addFlashAttribute("errorMessage", "Đăng ký không tồn tại!");
            return "redirect:/student/request-history";
        }

        RegisterMonth registration = registrationOpt.get();
        String requestMaSV = registration.getBienSoXe().getMaSV() != null
                ? registration.getBienSoXe().getMaSV().getMaSV().trim()
                : null;
        if (requestMaSV == null || !requestMaSV.equals(maSV)) {
            logger.warn("Sinh viên '{}' không sở hữu đăng ký '{}'. MaSV của xe: '{}'", maSV, trimmedMaDangKy,
                    requestMaSV);
            redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền xem đăng ký này!");
            return "redirect:/student/request-history";
        }

        model.addAttribute("registration", registration);
        model.addAttribute("maSV", maSV);
        return "client/student/request-monthly-registration/view";
    }
}