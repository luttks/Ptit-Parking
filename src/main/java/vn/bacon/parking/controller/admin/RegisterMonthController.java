// package vn.bacon.parking.controller.admin;

// import java.time.LocalDate;
// import java.util.HashMap;
// import java.util.List;
// import java.util.Map;
// import java.util.Optional;

// import org.slf4j.Logger;
// import org.slf4j.LoggerFactory;
// import org.springframework.data.domain.Page;
// import org.springframework.data.domain.PageRequest;
// import org.springframework.data.domain.Pageable;
// import org.springframework.security.core.Authentication;
// import org.springframework.security.core.context.SecurityContextHolder;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.Model;
// import org.springframework.validation.BindingResult;
// import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.ModelAttribute;
// import org.springframework.web.bind.annotation.PathVariable;
// import org.springframework.web.bind.annotation.PostMapping;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestParam;
// import org.springframework.web.bind.annotation.ResponseBody;
// import org.springframework.web.servlet.mvc.support.RedirectAttributes;

// import jakarta.validation.Valid;
// import vn.bacon.parking.domain.ParkingMode;
// import vn.bacon.parking.domain.Price;
// import vn.bacon.parking.domain.RegisterMonth;
// import vn.bacon.parking.domain.Vehicle;
// import vn.bacon.parking.domain.dto.RegisterMonthForm;
// import vn.bacon.parking.repository.ParkingModeRepository;
// import vn.bacon.parking.repository.PriceRepository;
// import vn.bacon.parking.repository.VehicleRepository;
// import vn.bacon.parking.service.RegisterMonthService;

// @Controller
// @RequestMapping("/admin/registermonth")
// public class RegisterMonthController {

// private static final Logger logger =
// LoggerFactory.getLogger(RegisterMonthController.class);

// private final RegisterMonthService registerMonthService;
// private final VehicleRepository vehicleRepository;
// private final ParkingModeRepository parkingModeRepository;
// private final PriceRepository priceRepository;

// public RegisterMonthController(
// RegisterMonthService registerMonthService,
// VehicleRepository vehicleRepository,
// ParkingModeRepository parkingModeRepository,
// PriceRepository priceRepository) {
// this.registerMonthService = registerMonthService;
// this.vehicleRepository = vehicleRepository;
// this.parkingModeRepository = parkingModeRepository;
// this.priceRepository = priceRepository;
// }

// // Show all register months with pagination
// @GetMapping
// public String listRegisterMonth(@RequestParam(defaultValue = "0") int page,
// @RequestParam(defaultValue = "10") int size,
// Model model) {
// logger.info("Fetching register months for page: {}, size: {}", page, size);
// Pageable pageable = PageRequest.of(page, size);
// Page<RegisterMonth> registerMonthPage =
// registerMonthService.getRegisterMonthPage(pageable);
// model.addAttribute("registerMonthPage", registerMonthPage);
// model.addAttribute("registerMonthList", registerMonthPage.getContent());
// return "admin/registermonth/show";
// }

// // Show form to create a new monthly registration
// @GetMapping("/create")
// public String showCreateForm(Model model) {
// model.addAttribute("registerMonthForm", new RegisterMonthForm());
// return "admin/registermonth/create";
// }

// // Handle creation of a new monthly registration
// @PostMapping("/create")
// public String createRegisterMonth(
// @Valid @ModelAttribute("registerMonthForm") RegisterMonthForm form,
// BindingResult result,
// RedirectAttributes redirectAttributes) {
// logger.info("Processing creation of new monthly registration for bienSoXe:
// {}", form.getBienSoXe());
// if (result.hasErrors()) {
// logger.error("Form validation errors: {}", result.getAllErrors());
// redirectAttributes.addFlashAttribute("errorMessage", "Dữ liệu không hợp lệ.
// Vui lòng kiểm tra lại.");
// return "redirect:/admin/registermonth/create";
// }

// try {
// // Validate soThang
// int soThang = form.getSoThang();
// if (soThang != 1 && soThang != 3 && soThang != 6) {
// throw new IllegalArgumentException("Số tháng phải là 1, 3 hoặc 6.");
// }

// // Generate maDangKy
// String maDangKy = registerMonthService.getNextMaDangKy();
// LocalDate ngayDangKy = LocalDate.now();
// LocalDate ngayBatDau = LocalDate.parse(form.getNgayBatDau());
// LocalDate ngayKetThuc = ngayBatDau.plusMonths(soThang);

// // Validate date range
// if (!registerMonthService.isValidNewRegistrationDateRange(form.getBienSoXe(),
// ngayBatDau, ngayKetThuc)) {
// throw new IllegalArgumentException(
// "Thời gian đăng ký không hợp lệ. Vui lòng chọn ngày bắt đầu sau ngày kết thúc
// của đăng ký trước đó.");
// }

// // Get vehicle
// Vehicle vehicle = vehicleRepository.findById(form.getBienSoXe())
// .orElseThrow(
// () -> new IllegalArgumentException("Không tìm thấy xe với biển số: " +
// form.getBienSoXe()));

// // Create registration
// RegisterMonth registration = new RegisterMonth();
// registration.setMaDangKy(maDangKy);
// registration.setBienSoXe(vehicle);
// registration.setNgayDangKy(ngayDangKy);
// registration.setNgayBatDau(ngayBatDau);
// registration.setNgayKetThuc(ngayKetThuc);
// registration.setTrangThai("Đã duyệt"); // Admin-created registrations are
// auto-approved
// registration.setGhiChu(form.getGhiChu());

// // Set price
// ParkingMode hinhThuc = parkingModeRepository.findById("HT002")
// .orElseThrow(() -> new IllegalArgumentException("Hình thức gửi tháng (HT002)
// không tồn tại."));
// Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc,
// vehicle.getMaLoaiXe());
// if (price == null) {
// throw new IllegalArgumentException(
// "Không tìm thấy giá cho xe " + form.getBienSoXe() + " với hình thức gửi
// tháng.");
// }
// registration.setBangGia(price);
// registration.setGia(price.getGia() * soThang);

// // Optional: Set admin info
// Authentication auth = SecurityContextHolder.getContext().getAuthentication();
// if (auth != null && auth.isAuthenticated()) {
// // Assuming maNV is stored in auth.getName() or you have a way to fetch
// Employee
// // entity
// // registration.setMaNV(employeeService.getEmployeeById(auth.getName()));
// }

// registerMonthService.createRegistration(registration);
// redirectAttributes.addFlashAttribute("successMessage", "Thêm đăng ký tháng
// thành công!");
// } catch (IllegalArgumentException e) {
// logger.error("Validation error: {}", e.getMessage());
// redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
// } catch (Exception e) {
// logger.error("Unexpected error: {}", e.getMessage(), e);
// redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi: " +
// e.getMessage());
// }
// return "redirect:/admin/registermonth";
// }

// // Search vehicle by license plate
// @PostMapping("/search-vehicle")
// @ResponseBody
// public Map<String, Object> searchVehicle(@RequestParam("bienSoXe") String
// bienSoXe) {
// logger.info("Searching for vehicle with bienSoXe: {}", bienSoXe);
// Map<String, Object> response = new HashMap<>();
// Optional<Vehicle> vehicleOpt = vehicleRepository.findById(bienSoXe.trim());
// if (vehicleOpt.isPresent()) {
// Vehicle vehicle = vehicleOpt.get();
// Map<String, String> vehicleData = new HashMap<>();
// vehicleData.put("bienSoXe", vehicle.getBienSoXe());
// vehicleData.put("tenXe", vehicle.getTenXe() != null ? vehicle.getTenXe() :
// "N/A");
// response.put("found", true);
// response.put("vehicle", vehicleData);
// } else {
// response.put("found", false);
// }
// return response;
// }

// // Show form to update an existing monthly registration
// @GetMapping("/update/{maDangKy}")
// public String showUpdateForm(@PathVariable String maDangKy, Model model,
// RedirectAttributes redirectAttributes) {
// logger.info("Fetching registration for update with maDangKy: {}", maDangKy);
// Optional<RegisterMonth> registrationOpt =
// registerMonthService.getRegistrationById(maDangKy);
// if (!registrationOpt.isPresent()) {
// logger.warn("Registration not found with maDangKy: {}", maDangKy);
// redirectAttributes.addFlashAttribute("errorMessage", "Đăng ký không tồn
// tại!");
// return "redirect:/admin/registermonth";
// }
// RegisterMonth registration = registrationOpt.get();
// RegisterMonthForm form = new RegisterMonthForm();
// form.setBienSoXe(registration.getBienSoXe().getBienSoXe());
// form.setNgayBatDau(registration.getNgayBatDau().toString());
// form.setSoThang((int)
// registration.getNgayBatDau().until(registration.getNgayKetThuc(),
// java.time.temporal.ChronoUnit.MONTHS));
// form.setGhiChu(registration.getGhiChu());
// model.addAttribute("registerMonthForm", form);
// model.addAttribute("maDangKy", maDangKy);
// model.addAttribute("trangThai", registration.getTrangThai());
// return "admin/registermonth/update";
// }

// // Handle update of an existing monthly registration
// @PostMapping("/update/{maDangKy}")
// public String updateRegisterMonth(
// @PathVariable String maDangKy,
// @Valid @ModelAttribute("registerMonthForm") RegisterMonthForm form,
// BindingResult result,
// @RequestParam String trangThai,
// RedirectAttributes redirectAttributes) {
// logger.info("Updating registration with maDangKy: {}", maDangKy);
// if (result.hasErrors()) {
// logger.error("Form validation errors: {}", result.getAllErrors());
// redirectAttributes.addFlashAttribute("errorMessage", "Dữ liệu không hợp lệ.
// Vui lòng kiểm tra lại.");
// return "redirect:/admin/registermonth/update/" + maDangKy;
// }

// try {
// // Validate soThang
// int soThang = form.getSoThang();
// if (soThang != 1 && soThang != 3 && soThang != 6) {
// throw new IllegalArgumentException("Số tháng phải là 1, 3 hoặc 6.");
// }

// // Validate trangThai
// if (!List.of("Chờ duyệt", "Đã duyệt", "Từ chối").contains(trangThai)) {
// throw new IllegalArgumentException("Trạng thái không hợp lệ.");
// }

// Optional<RegisterMonth> registrationOpt =
// registerMonthService.getRegistrationById(maDangKy);
// if (!registrationOpt.isPresent()) {
// throw new IllegalArgumentException("Đăng ký không tồn tại.");
// }

// RegisterMonth registration = registrationOpt.get();
// LocalDate ngayBatDau = LocalDate.parse(form.getNgayBatDau());
// LocalDate ngayKetThuc = ngayBatDau.plusMonths(soThang);

// // Validate date range
// if
// (registerMonthService.hasOverlappingRegistrationExcludingId(form.getBienSoXe(),
// maDangKy, ngayBatDau,
// ngayKetThuc)) {
// throw new IllegalArgumentException(
// "Thời gian đăng ký không hợp lệ. Thời gian mới không được trùng với các đăng
// ký khác.");
// }

// // Update registration
// Vehicle vehicle = vehicleRepository.findById(form.getBienSoXe())
// .orElseThrow(
// () -> new IllegalArgumentException("Không tìm thấy xe với biển số: " +
// form.getBienSoXe()));
// registration.setBienSoXe(vehicle);
// registration.setNgayBatDau(ngayBatDau);
// registration.setNgayKetThuc(ngayKetThuc);
// registration.setNgayDangKy(LocalDate.now());
// registration.setTrangThai(trangThai);
// registration.setGhiChu(form.getGhiChu());

// // Update price
// ParkingMode hinhThuc = parkingModeRepository.findById("HT002")
// .orElseThrow(() -> new IllegalArgumentException("Hình thức gửi tháng (HT002)
// không tồn tại."));
// Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc,
// vehicle.getMaLoaiXe());
// if (price == null) {
// throw new IllegalArgumentException(
// "Không tìm thấy giá cho xe " + form.getBienSoXe() + " với hình thức gửi
// tháng.");
// }
// registration.setBangGia(price);
// registration.setGia(price.getGia() * soThang);

// registerMonthService.updateRegistration(registration);
// redirectAttributes.addFlashAttribute("successMessage", "Cập nhật đăng ký
// tháng thành công!");
// } catch (IllegalArgumentException e) {
// logger.error("Validation error: {}", e.getMessage());
// redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
// } catch (Exception e) {
// logger.error("Unexpected error: {}", e.getMessage(), e);
// redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi: " +
// e.getMessage());
// }
// return "redirect:/admin/registermonth";
// }

// // Show form to extend a monthly registration
// @GetMapping("/extend/{maDangKy}")
// public String showExtendForm(@PathVariable String maDangKy, Model model,
// RedirectAttributes redirectAttributes) {
// logger.info("Fetching registration for extension with maDangKy: {}",
// maDangKy);
// Optional<RegisterMonth> registrationOpt =
// registerMonthService.getRegistrationById(maDangKy);
// if (!registrationOpt.isPresent()) {
// logger.warn("Registration not found with maDangKy: {}", maDangKy);
// redirectAttributes.addFlashAttribute("errorMessage", "Đăng ký không tồn
// tại!");
// return "redirect:/admin/registermonth";
// }
// model.addAttribute("registerMonth", registrationOpt.get());
// model.addAttribute("extendForm", new RegisterMonthForm());
// return "admin/registermonth/extend";
// }

// // Handle extension of a monthly registration
// @PostMapping("/extend/{maDangKy}")
// public String extendRegisterMonth(
// @PathVariable String maDangKy,
// @Valid @ModelAttribute("extendForm") RegisterMonthForm form,
// BindingResult result,
// RedirectAttributes redirectAttributes) {
// logger.info("Extending registration with maDangKy: {} for {} months",
// maDangKy, form.getSoThang());
// if (result.hasErrors()) {
// logger.error("Form validation errors: {}", result.getAllErrors());
// redirectAttributes.addFlashAttribute("errorMessage", "Dữ liệu không hợp lệ.
// Vui lòng kiểm tra lại.");
// return "redirect:/admin/registermonth/extend/" + maDangKy;
// }

// try {
// // Validate soThang
// int soThang = form.getSoThang();
// if (soThang != 1 && soThang != 6 && soThang != 12) {
// throw new IllegalArgumentException("Thời gian gia hạn phải là 1, 6 hoặc 12
// tháng.");
// }

// RegisterMonth registration = registerMonthService.giaHanDangKy(maDangKy,
// soThang);
// // Update price
// ParkingMode hinhThuc = parkingModeRepository.findById("HT002")
// .orElseThrow(() -> new IllegalArgumentException("Hình thức gửi tháng (HT002)
// không tồn tại."));
// Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(hinhThuc,
// registration.getBienSoXe().getMaLoaiXe());
// if (price == null) {
// throw new IllegalArgumentException(
// "Không tìm thấy giá cho xe " + registration.getBienSoXe().getBienSoXe()
// + " với hình thức gửi tháng.");
// }
// registration.setBangGia(price);
// registration.setGia(price.getGia() * soThang);
// registerMonthService.updateRegistration(registration);

// redirectAttributes.addFlashAttribute("successMessage", "Gia hạn đăng ký tháng
// thành công!");
// } catch (IllegalArgumentException e) {
// logger.error("Validation error: {}", e.getMessage());
// redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
// } catch (Exception e) {
// logger.error("Unexpected error: {}", e.getMessage(), e);
// redirectAttributes.addFlashAttribute("errorMessage", "Đã xảy ra lỗi: " +
// e.getMessage());
// }
// return "redirect:/admin/registermonth";
// }

// // Search registrations by license plate
// @GetMapping("/search")
// public String searchRegisterMonth(@RequestParam("tuKhoa") String tuKhoa,
// @RequestParam(defaultValue = "0") int page,
// @RequestParam(defaultValue = "10") int size,
// Model model) {
// logger.info("Searching registrations with keyword: {}", tuKhoa);
// List<RegisterMonth> registerMonthList =
// registerMonthService.timKiemTheoBienSoXe(tuKhoa);
// model.addAttribute("registerMonthList", registerMonthList);
// model.addAttribute("tuKhoa", tuKhoa);
// return "admin/registermonth/show";
// }

// // Filter active registrations
// @GetMapping("/active")
// public String listActiveRegisterMonth(@RequestParam(defaultValue = "0") int
// page,
// @RequestParam(defaultValue = "10") int size,
// Model model) {
// logger.info("Fetching active register months for page: {}, size: {}", page,
// size);
// List<RegisterMonth> registerMonthList =
// registerMonthService.timDangKyConHieuLuc();
// model.addAttribute("registerMonthList", registerMonthList);
// model.addAttribute("filter", "active");
// return "admin/registermonth/show";
// }

// // Filter expired registrations
// @GetMapping("/expired")
// public String listExpiredRegisterMonth(@RequestParam(defaultValue = "0") int
// page,
// @RequestParam(defaultValue = "10") int size,
// Model model) {
// logger.info("Fetching expired register months for page: {}, size: {}", page,
// size);
// List<RegisterMonth> registerMonthList =
// registerMonthService.timDangKyDaHetHan();
// model.addAttribute("registerMonthList", registerMonthList);
// model.addAttribute("filter", "expired");
// return "admin/registermonth/show";
// }

// // Filter expiring-soon registrations
// @GetMapping("/expiring-soon")
// public String listExpiringSoonRegisterMonth(@RequestParam(defaultValue = "0")
// int page,
// @RequestParam(defaultValue = "10") int size,
// Model model) {
// logger.info("Fetching expiring-soon register months for page: {}, size: {}",
// page, size);
// List<RegisterMonth> registerMonthList =
// registerMonthService.getRegisterMonthsExpiringSoon();
// model.addAttribute("registerMonthList", registerMonthList);
// model.addAttribute("filter", "expiring-soon");
// return "admin/registermonth/show";
// }
// }