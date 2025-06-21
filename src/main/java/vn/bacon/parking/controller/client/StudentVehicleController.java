package vn.bacon.parking.controller.client;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import vn.bacon.parking.domain.EntryExitDetail;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.domain.Student;
import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.repository.EntryExitDetailRepository;
import vn.bacon.parking.service.StaffService;
import vn.bacon.parking.service.StudentService;
import vn.bacon.parking.service.VehicleService;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/student/vehicle")
public class StudentVehicleController {
    private final VehicleService vehicleService;
    private final StudentService studentService;
    private final StaffService staffService;
    private final EntryExitDetailRepository entryExitDetailRepository;

    public StudentVehicleController(VehicleService vehicleService, StudentService studentService,
            StaffService staffService, EntryExitDetailRepository entryExitDetailRepository) {
        this.vehicleService = vehicleService;
        this.studentService = studentService;
        this.staffService = staffService;
        this.entryExitDetailRepository = entryExitDetailRepository;
    }

    @GetMapping("/list")
    public String listVehicles(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Optional<Student> studentOpt = studentService.getStudentById(username);
        if (studentOpt.isPresent()) {
            Student student = studentOpt.get();
            Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStudentId(student.getMaSV(),
                    PageRequest.of(0, Integer.MAX_VALUE));
            List<Vehicle> vehicleList = vehiclePage.getContent();
            model.addAttribute("vehicleList", vehicleList);
            return "client/student/vehicle/list";
        }
        return "redirect:/";
    }

    @GetMapping("/history")
    public String vehicleHistory(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String sortByTime,
            Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Optional<Student> studentOpt = studentService.getStudentById(username);
        if (studentOpt.isPresent()) {
            Student student = studentOpt.get();
            Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStudentId(student.getMaSV(),
                    PageRequest.of(0, Integer.MAX_VALUE));
            List<Vehicle> vehicleList = vehiclePage.getContent();

            // Create Pageable with sorting
            Sort sort = Sort.by("tgVao").descending();
            if ("asc".equalsIgnoreCase(sortByTime)) {
                sort = Sort.by("tgVao").ascending();
            }
            Pageable pageable = PageRequest.of(page, size, sort);

            // Fetch paginated EntryExitDetail records
            Page<EntryExitDetail> entryExitPage = vehicleList.isEmpty() ? Page.empty(pageable)
                    : entryExitDetailRepository.findByBienSoXeIn(vehicleList, pageable);

            model.addAttribute("entryExitPage", entryExitPage);
            model.addAttribute("currentSort", sortByTime);
            model.addAttribute("currentPage", page);
            model.addAttribute("pageSize", size);
            return "client/student/vehicle/history";
        }
        return "redirect:/";
    }
}