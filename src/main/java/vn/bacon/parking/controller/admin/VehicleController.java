
package vn.bacon.parking.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.domain.VehicleType;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.domain.Student;
import vn.bacon.parking.service.VehicleService;
import vn.bacon.parking.service.VehicleTypeService;
import vn.bacon.parking.service.StaffService;
import vn.bacon.parking.service.StudentService;

import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;

@Controller
public class VehicleController {
    private final VehicleService vehicleService;
    private final VehicleTypeService vehicleTypeService;
    private final StaffService staffService;
    private final StudentService studentService;

    public VehicleController(VehicleService vehicleService, VehicleTypeService vehicleTypeService,
            StaffService staffService, StudentService studentService) {
        this.vehicleService = vehicleService;
        this.vehicleTypeService = vehicleTypeService;
        this.staffService = staffService;
        this.studentService = studentService;
    }

    // @GetMapping("/admin/vehicle")
    // public String getVehiclePage(Model model) {
    // List<Vehicle> vehicles = this.vehicleService.getAllVehicles();
    // model.addAttribute("vehicleshow", vehicles);
    // return "admin/vehicle/show";
    // }

    @GetMapping("admin/vehicle/create")
    public String getCreateVehiclePage(Model model) {
        model.addAttribute("newVehicle", new Vehicle());
        List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
        model.addAttribute("vehicleTypes", vehicleTypes);
        List<Staff> staffs = staffService.getAllStaffs();
        model.addAttribute("staffs", staffs);
        List<Student> students = studentService.getAllStudents();
        model.addAttribute("students", students);
        return "admin/vehicle/create";
    }

    @PostMapping("admin/vehicle/create")
    public String createVehicle(@ModelAttribute("newVehicle") @Valid Vehicle vehicle1, BindingResult bindingResult,
            Model model, RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            // Nếu có lỗi validation mặc định (ví dụ: @NotBlank trên BienSoXe nếu thêm sau
            // này)
            List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
            model.addAttribute("vehicleTypes", vehicleTypes);
            List<Staff> staffs = staffService.getAllStaffs();
            model.addAttribute("staffs", staffs);
            List<Student> students = studentService.getAllStudents();
            model.addAttribute("students", students);
            return "admin/vehicle/create";
        }

        // Kiểm tra trùng biển số xe
        if (vehicleService.checkBienSoXeExists(vehicle1.getBienSoXe())) {
            model.addAttribute("errorMessage",
                    "Biển số xe \"" + vehicle1.getBienSoXe() + "\" đã tồn tại. Vui lòng nhập lại.");
            List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
            model.addAttribute("vehicleTypes", vehicleTypes);
            List<Staff> staffs = staffService.getAllStaffs();
            model.addAttribute("staffs", staffs);
            List<Student> students = studentService.getAllStudents();
            model.addAttribute("students", students);
            return "admin/vehicle/create";
        }

        // Kiểm tra logic MaNV và MaSV: không được nhập cả hai cùng lúc
        if (vehicle1.getMaNV() != null && !vehicle1.getMaNV().getMaNV().isEmpty() &&
                vehicle1.getMaSV() != null && !vehicle1.getMaSV().getMaSV().isEmpty()) {
            model.addAttribute("errorMessage", "Không thể nhập cả Mã NV và Mã SV. Vui lòng chỉ nhập một trong hai.");
            List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
            model.addAttribute("vehicleTypes", vehicleTypes);
            List<Staff> staffs = staffService.getAllStaffs();
            model.addAttribute("staffs", staffs);
            List<Student> students = studentService.getAllStudents();
            model.addAttribute("students", students);
            return "admin/vehicle/create";
        }

        // Nếu không nhập cả MaNV và MaSV
        if ((vehicle1.getMaNV() == null || vehicle1.getMaNV().getMaNV().isEmpty()) &&
                (vehicle1.getMaSV() == null || vehicle1.getMaSV().getMaSV().isEmpty())) {
            model.addAttribute("errorMessage", "Phải nhập Mã NV hoặc Mã SV.");
            List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
            model.addAttribute("vehicleTypes", vehicleTypes);
            List<Staff> staffs = staffService.getAllStaffs();
            model.addAttribute("staffs", staffs);
            List<Student> students = studentService.getAllStudents();
            model.addAttribute("students", students);
            return "admin/vehicle/create";
        }

        // Set MaNV or MaSV to null if not provided
        if (vehicle1.getMaNV() != null && vehicle1.getMaNV().getMaNV().isEmpty()) {
            vehicle1.setMaNV(null);
        }
        if (vehicle1.getMaSV() != null && vehicle1.getMaSV().getMaSV().isEmpty()) {
            vehicle1.setMaSV(null);
        }

        // Kiểm tra sự tồn tại của MaNV/MaSV nếu được nhập
        if (vehicle1.getMaNV() != null && !vehicle1.getMaNV().getMaNV().isEmpty()) {
            Optional<Staff> existingStaff = staffService.getStaffById(vehicle1.getMaNV().getMaNV());
            if (existingStaff.isEmpty()) {
                model.addAttribute("errorMessage", "Mã NV không tồn tại. Vui lòng nhập lại.");
                List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
                model.addAttribute("vehicleTypes", vehicleTypes);
                List<Staff> staffs = staffService.getAllStaffs();
                model.addAttribute("staffs", staffs);
                List<Student> students = studentService.getAllStudents();
                model.addAttribute("students", students);
                return "admin/vehicle/create";
            } else {
                vehicle1.setMaNV(existingStaff.get()); // Gán lại đối tượng Staff đầy đủ
            }
        }

        if (vehicle1.getMaSV() != null && !vehicle1.getMaSV().getMaSV().isEmpty()) {
            Optional<Student> existingStudent = studentService.getStudentById(vehicle1.getMaSV().getMaSV());
            if (existingStudent.isEmpty()) {
                model.addAttribute("errorMessage", "Mã SV không tồn tại. Vui lòng nhập lại.");
                List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
                model.addAttribute("vehicleTypes", vehicleTypes);
                List<Staff> staffs = staffService.getAllStaffs();
                model.addAttribute("staffs", staffs);
                List<Student> students = studentService.getAllStudents();
                model.addAttribute("students", students);
                return "admin/vehicle/create";
            } else {
                vehicle1.setMaSV(existingStudent.get()); // Gán lại đối tượng Student đầy đủ
            }
        }

        this.vehicleService.saveVehicle(vehicle1);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm xe mới thành công!");
        return "redirect:/admin/vehicle";
    }

    // Update vehicle
    @GetMapping("admin/vehicle/update/{bienSoXe}")
    public String getUpdateVehiclePage(Model model, @PathVariable String bienSoXe) {
        Vehicle currentVehicle = this.vehicleService.getVehicleById(bienSoXe).get();
        model.addAttribute("newVehicle", currentVehicle);
        List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
        model.addAttribute("vehicleTypes", vehicleTypes);
        List<Staff> staffs = staffService.getAllStaffs();
        model.addAttribute("staffs", staffs);
        List<Student> students = studentService.getAllStudents();
        model.addAttribute("students", students);
        return "admin/vehicle/update";
    }

    @PostMapping("admin/vehicle/update")
    public String updateVehicle(Model model, @ModelAttribute("newVehicle") Vehicle vehicle1,
            RedirectAttributes redirectAttributes) {
        Optional<Vehicle> currentVehicleOpt = this.vehicleService.getVehicleById(vehicle1.getBienSoXe());
        if (!currentVehicleOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Không tìm thấy xe với biển số " + vehicle1.getBienSoXe());
            return "redirect:/admin/vehicle";
        }

        Vehicle currentVehicle = currentVehicleOpt.get();
        currentVehicle.setBienSoXe(vehicle1.getBienSoXe());
        currentVehicle.setMaLoaiXe(vehicle1.getMaLoaiXe());
        currentVehicle.setTenXe(vehicle1.getTenXe());
        currentVehicle.setMaNV(vehicle1.getMaNV());
        currentVehicle.setMaSV(vehicle1.getMaSV());
        this.vehicleService.saveVehicle(currentVehicle);

        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật xe thành công!");
        return "redirect:/admin/vehicle";
    }

    @GetMapping("admin/vehicle/delete/{bienSoXe}")
    public String deleteVehicle(Model model, @PathVariable String bienSoXe) {
        model.addAttribute("newVehicle", new Vehicle());
        return "admin/vehicle/delete";
    }

    @PostMapping("admin/vehicle/delete")
    public String deleteVehiclePost(@ModelAttribute("newVehicle") Vehicle vehicle1,
            RedirectAttributes redirectAttributes) {
        String bienSoXe = vehicle1.getBienSoXe();
        Optional<Vehicle> vehicleOpt = vehicleService.getVehicleById(bienSoXe);
        if (!vehicleOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy xe với biển số " + bienSoXe);
            return "redirect:/admin/vehicle";
        }

        // Check for dependencies
        String dependencyError = vehicleService.checkDependencies(bienSoXe);
        if (dependencyError != null) {
            redirectAttributes.addFlashAttribute("errorMessage", dependencyError);
            return "redirect:/admin/vehicle";
        }

        // Proceed with deletion if no dependencies
        vehicleService.deleteVehicleById(bienSoXe);
        redirectAttributes.addFlashAttribute("successMessage", "Xóa xe thành công!");
        return "redirect:/admin/vehicle";
    }

    @GetMapping("/admin/vehicle")
    public String listVehicle(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String filterType,
            @RequestParam(required = false) String filterTenLoaiXe,
            @RequestParam(required = false) String searchBienSoXe,
            Model model) {

        Pageable pageable = PageRequest.of(page, size); // Tạo đối tượng Pageable
        Page<Vehicle> vehiclePage; // Khởi tạo Page<Vehicle>
        String searchMessage = null;

        if (searchBienSoXe != null && !searchBienSoXe.trim().isEmpty()) {
            vehiclePage = vehicleService.searchVehiclesByBienSoXe(searchBienSoXe, pageable);
            if (vehiclePage.isEmpty()) {
                searchMessage = "Biển số xe " + searchBienSoXe + " không tồn tại.";
            }
        } else if (filterType != null && !filterType.trim().isEmpty()) {
            if ("NV".equals(filterType)) {
                vehiclePage = vehicleService.getVehiclesWithStaff(pageable);
            } else if ("SV".equals(filterType)) {
                vehiclePage = vehicleService.getVehiclesWithStudent(pageable);
            } else {
                // Mặc định nếu filterType không hợp lệ
                vehiclePage = vehicleService.getAllVehicles(pageable);
            }
        } else if (filterTenLoaiXe != null && !filterTenLoaiXe.trim().isEmpty()) {
            vehiclePage = vehicleService.getVehiclesByTenLoaiXe(filterTenLoaiXe, pageable);
        } else {
            vehiclePage = vehicleService.getAllVehicles(pageable);
        }

        model.addAttribute("vehiclePage", vehiclePage);
        model.addAttribute("searchMessage", searchMessage);
        model.addAttribute("filterType", filterType);
        model.addAttribute("filterTenLoaiXe", filterTenLoaiXe);
        model.addAttribute("searchBienSoXe", searchBienSoXe);

        // Pass vehicle types, staffs, students to the view for filter dropdowns
        model.addAttribute("vehicleTypes", vehicleTypeService.getAllVehicleTypes());
        model.addAttribute("staffs", staffService.getAllStaffs());
        model.addAttribute("students", studentService.getAllStudents());

        return "admin/vehicle/show";
    }
}
