package vn.bacon.parking.controller.client;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import vn.bacon.parking.domain.EntryExitDetail;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.repository.EntryExitDetailRepository;
import vn.bacon.parking.service.StaffService;
import vn.bacon.parking.service.VehicleService;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/staff/vehicle")
public class StaffVehicleController {
    private final VehicleService vehicleService;
    private final StaffService staffService;
    private final EntryExitDetailRepository entryExitDetailRepository;

    public StaffVehicleController(VehicleService vehicleService, StaffService staffService,
            EntryExitDetailRepository entryExitDetailRepository) {
        this.entryExitDetailRepository = entryExitDetailRepository;
        this.vehicleService = vehicleService;
        this.staffService = staffService;
    }

    @GetMapping("/list")
    public String listVehicles(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Optional<Staff> staffOpt = staffService.getStaffById(username);
        if (staffOpt.isPresent()) {
            Staff staff = staffOpt.get();
            Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStaffId(staff.getMaNV(),
                    PageRequest.of(0, Integer.MAX_VALUE));
            List<Vehicle> vehicleList = vehiclePage.getContent();
            model.addAttribute("vehicleList", vehicleList);
            return "client/staff/vehicle/list";
        }
        return "redirect:/";
    }

    @GetMapping("/history")
    public String vehicleHistory(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        Optional<Staff> staffOpt = staffService.getStaffById(username);
        if (staffOpt.isPresent()) {
            Staff staff = staffOpt.get();
            Page<Vehicle> vehiclePage = vehicleService.getVehiclesByStaffId(staff.getMaNV(),
                    PageRequest.of(0, Integer.MAX_VALUE));
            List<Vehicle> vehicleList = vehiclePage.getContent();
            List<EntryExitDetail> entryExitList = new java.util.ArrayList<>();
            for (Vehicle v : vehicleList) {
                entryExitList.addAll(entryExitDetailRepository.findAll().stream()
                        .filter(e -> e.getBienSoXe() != null && e.getBienSoXe().getBienSoXe().equals(v.getBienSoXe()))
                        .toList());
            }
            model.addAttribute("entryExitList", entryExitList);
            return "client/staff/vehicle/history";
        }
        return "redirect:/";
    }
}