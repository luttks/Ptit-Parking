package vn.bacon.parking.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import vn.bacon.parking.repository.ParkingLotRepository;

@Controller
public class DashboardController {

    private final ParkingLotRepository parkingLotRepository;

    public DashboardController(ParkingLotRepository parkingLotRepository) {
        this.parkingLotRepository = parkingLotRepository;
    }

    @GetMapping("/admin")
    public String getDashboard(Model model) {
        model.addAttribute("parkingLotList", parkingLotRepository.findAll());
        return "admin/dashboard/show";
    }
}