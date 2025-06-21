package vn.bacon.parking.controller.admin;

import java.time.LocalDate;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.domain.RegisterMonth;
import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.repository.ParkingModeRepository;
import vn.bacon.parking.repository.PriceRepository;
import vn.bacon.parking.service.RegisterMonthService;
import vn.bacon.parking.service.StaffService;
import vn.bacon.parking.service.VehicleService;

@Controller
@RequestMapping("/admin/request")
public class MonthlyRegisterDashboardController {

    private static final Logger logger = LoggerFactory.getLogger(MonthlyRegisterDashboardController.class);

    private final RegisterMonthService registerMonthService;
    private final StaffService staffService;
    private final PriceRepository priceRepository;
    private final VehicleService vehicleService;
    private final ParkingModeRepository parkingModeRepository;

    public MonthlyRegisterDashboardController(RegisterMonthService registerMonthService, StaffService staffService,
            PriceRepository priceRepository, VehicleService vehicleService,
            ParkingModeRepository parkingModeRepository) {
        this.registerMonthService = registerMonthService;
        this.staffService = staffService;
        this.priceRepository = priceRepository;
        this.vehicleService = vehicleService;
        this.parkingModeRepository = parkingModeRepository;
    }

    @GetMapping
    public String listRequests(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String sortByStatus,
            @RequestParam(defaultValue = "all") String filter,
            Model model) {
        Sort sort = Sort.by("trangThai").ascending();
        if ("desc".equalsIgnoreCase(sortByStatus)) {
            sort = Sort.by("trangThai").descending();
        }
        Pageable pageable = PageRequest.of(page, size, sort);

        Page<RegisterMonth> requestPage;
        switch (filter.toLowerCase()) {
            case "active":
                requestPage = registerMonthService.getActiveRegisterMonthPage(pageable);
                break;
            case "expired":
                requestPage = registerMonthService.getExpiredRegisterMonthPage(pageable);
                break;
            default:
                requestPage = registerMonthService.getRegisterMonthPage(pageable);
                break;
        }

        model.addAttribute("requestPage", requestPage);
        model.addAttribute("currentSort", sortByStatus);
        model.addAttribute("currentFilter", filter);
        return "admin/request-register/show";
    }

    @GetMapping("/approve/{maDangKy}")
    public String showApproveForm(@PathVariable String maDangKy, Model model, RedirectAttributes redirectAttributes) {
        String trimmedMaDangKy = maDangKy.trim();
        logger.info("Đang cố gắng duyệt yêu cầu với Mã: '{}', đã trim: '{}'", maDangKy, trimmedMaDangKy);

        Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
        if (!registrationOpt.isPresent()) {
            logger.warn("Không tìm thấy yêu cầu với Mã: '{}'", trimmedMaDangKy);
            redirectAttributes.addFlashAttribute("errorMessage", "Yêu cầu không tồn tại!");
            return "redirect:/admin/request";
        }

        RegisterMonth registration = registrationOpt.get();
        if (!"Chờ duyệt".equals(registration.getTrangThai())) {
            logger.warn("Yêu cầu {} có trạng thái '{}', không phải 'Chờ duyệt'", trimmedMaDangKy,
                    registration.getTrangThai());
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Chỉ có thể duyệt yêu cầu đang ở trạng thái 'Chờ duyệt'!");
            return "redirect:/admin/request";
        }

        model.addAttribute("registration", registration);
        return "admin/request-register/approve";
    }

    @PostMapping("/approve")
    public String approveRequest(@RequestParam String maDangKy,
            @RequestParam(required = false) String ghiChu,
            RedirectAttributes redirectAttributes) {
        String trimmedMaDangKy = maDangKy.trim();
        logger.info("Đang xử lý duyệt yêu cầu với Mã: '{}', đã trim: '{}'", maDangKy, trimmedMaDangKy);

        Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
        if (!registrationOpt.isPresent()) {
            logger.warn("Không tìm thấy yêu cầu với Mã: '{}'", trimmedMaDangKy);
            redirectAttributes.addFlashAttribute("errorMessage", "Yêu cầu không tồn tại!");
            return "redirect:/admin/request";
        }

        RegisterMonth registration = registrationOpt.get();
        if (!"Chờ duyệt".equals(registration.getTrangThai())) {
            logger.warn("Yêu cầu {} có trạng thái '{}', không phải 'Chờ duyệt'", trimmedMaDangKy,
                    registration.getTrangThai());
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Chỉ có thể duyệt yêu cầu đang ở trạng thái 'Chờ duyệt'!");
            return "redirect:/admin/request";
        }

        registration.setMaNV(staffService.getCurrentStaff());
        registration.setGhiChu(ghiChu);
        registration.setTrangThai("Đã duyệt");
        registerMonthService.saveRegisterMonth(registration);
        redirectAttributes.addFlashAttribute("successMessage", "Yêu cầu " + trimmedMaDangKy + " đã được duyệt!");
        return "redirect:/admin/request";
    }

    @PostMapping("/reject")
    public String rejectRequest(@RequestParam String maDangKy,
            @RequestParam String ghiChu,
            RedirectAttributes redirectAttributes) {
        String trimmedMaDangKy = maDangKy.trim();
        logger.info("Đang xử lý từ chối yêu cầu với Mã: '{}', đã trim: '{}'", maDangKy, trimmedMaDangKy);

        Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
        if (!registrationOpt.isPresent()) {
            logger.warn("Không tìm thấy yêu cầu với Mã: '{}'", trimmedMaDangKy);
            redirectAttributes.addFlashAttribute("errorMessage", "Yêu cầu không tồn tại!");
            return "redirect:/admin/request";
        }

        RegisterMonth registration = registrationOpt.get();
        if (!"Chờ duyệt".equals(registration.getTrangThai())) {
            logger.warn("Yêu cầu {} có trạng thái '{}', không phải 'Chờ duyệt'", trimmedMaDangKy,
                    registration.getTrangThai());
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Chỉ có thể từ chối yêu cầu đang ở trạng thái 'Chờ duyệt'!");
            return "redirect:/admin/request";
        }

        registration.setMaNV(staffService.getCurrentStaff());
        registration.setGhiChu(ghiChu);
        registration.setTrangThai("Từ chối");
        registerMonthService.saveRegisterMonth(registration);
        redirectAttributes.addFlashAttribute("successMessage", "Yêu cầu " + trimmedMaDangKy + " đã bị từ chối!");
        return "redirect:/admin/request";
    }

    @GetMapping("/view/{maDangKy}")
    public String viewRequest(@PathVariable String maDangKy, Model model, RedirectAttributes redirectAttributes) {
        String trimmedMaDangKy = maDangKy.trim();
        logger.info("Đang xem yêu cầu với Mã: '{}', đã trim: '{}'", maDangKy, trimmedMaDangKy);

        Optional<RegisterMonth> registrationOpt = registerMonthService.getRegistrationById(trimmedMaDangKy);
        if (!registrationOpt.isPresent()) {
            logger.warn("Không tìm thấy yêu cầu với Mã: '{}'", trimmedMaDangKy);
            redirectAttributes.addFlashAttribute("errorMessage", "Yêu cầu không tồn tại!");
            return "redirect:/admin/request";
        }

        model.addAttribute("registration", registrationOpt.get());
        return "admin/request-register/view";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("registration", new RegisterMonth());
        return "admin/request-register/create";
    }

    @PostMapping("/create")
    public String createRegistration(
            @RequestParam String bienSoXe,
            @RequestParam int soThang,
            @RequestParam String ngayBatDau,
            @RequestParam(required = false) String ghiChu,
            RedirectAttributes redirectAttributes) {
        try {
            // Validate inputs
            if (bienSoXe == null || bienSoXe.trim().isEmpty()) {
                throw new IllegalArgumentException("Biển số xe không được để trống.");
            }
            if (soThang != 1 && soThang != 3 && soThang != 6) {
                throw new IllegalArgumentException("Số tháng phải là 1, 3 hoặc 6.");
            }
            LocalDate startDate = LocalDate.parse(ngayBatDau);
            if (startDate.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException("Ngày bắt đầu phải từ hôm nay trở đi.");
            }

            // Check if vehicle exists
            Optional<Vehicle> vehicleOpt = vehicleService.findByBienSoXe(bienSoXe.trim());
            if (!vehicleOpt.isPresent()) {
                throw new IllegalArgumentException("Xe với biển số " + bienSoXe + " không tồn tại trong hệ thống.");
            }
            Vehicle vehicle = vehicleOpt.get();

            // Check if vehicle is owned by a student
            if (vehicle.getMaSV() == null || vehicle.getMaNV() != null) {
                throw new IllegalArgumentException("Xe với biển số " + bienSoXe + " không thuộc sở hữu của sinh viên.");
            }

            // Create new registration
            RegisterMonth registration = new RegisterMonth();
            registration.setMaDangKy(registerMonthService.getNextMaDangKy());
            registration.setBienSoXe(vehicle);
            registration.setMaNV(staffService.getCurrentStaff());
            registration.setNgayDangKy(LocalDate.now());
            registration.setNgayBatDau(startDate);
            registration.setNgayKetThuc(startDate.plusMonths(soThang));
            registration.setTrangThai("Đã duyệt"); // Auto-approved for admin
            registration.setGhiChu(ghiChu);

            // Fetch ParkingMode
            Optional<ParkingMode> parkingModeOpt = parkingModeRepository.findById("HT002");
            if (!parkingModeOpt.isPresent()) {
                throw new IllegalArgumentException("Hình thức gửi tháng (HT002) không tồn tại.");
            }
            ParkingMode hinhThuc = parkingModeOpt.get();

            // Calculate price
            Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc, vehicle.getMaLoaiXe());
            if (price == null) {
                throw new IllegalArgumentException("Không tìm thấy giá cho loại xe này với hình thức gửi tháng.");
            }
            registration.setBangGia(price);
            registration.setGia(price.getGia() * soThang);

            // Validate date range
            if (!registerMonthService.isValidNewRegistrationDateRange(
                    bienSoXe.trim(), startDate, startDate.plusMonths(soThang))) {
                throw new IllegalArgumentException("Khoảng thời gian đăng ký bị trùng lặp hoặc không hợp lệ.");
            }

            // Save registration
            registerMonthService.createRegistration(registration);
            redirectAttributes.addFlashAttribute("successMessage", "Đăng ký tháng mới đã được tạo thành công!");
            return "redirect:/admin/request";

        } catch (IllegalArgumentException e) {
            logger.error("Lỗi khi tạo đăng ký tháng: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/request/create";
        } catch (Exception e) {
            logger.error("Lỗi không xác định khi tạo đăng ký tháng: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi khi tạo đăng ký. Vui lòng thử lại.");
            return "redirect:/admin/request/create";
        }
    }
}