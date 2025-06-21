package vn.bacon.parking.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.service.ParkingModeService;

@Controller
@RequestMapping("/admin/parkingmode")
public class ParkingModeController {
    private final ParkingModeService parkingModeService;

    public ParkingModeController(ParkingModeService parkingModeService) {
        this.parkingModeService = parkingModeService;
    }

    @GetMapping
    public String listHinhThucGuiXe(Model model) {
        List<ParkingMode> hinhThucList = parkingModeService.findAll();
        model.addAttribute("hinhThucList", hinhThucList);
        return "admin/parkingmode/show";
    }

    @GetMapping("/create")
    public String getCreatePage(Model model) {
        model.addAttribute("newHinhThuc", new ParkingMode());
        return "admin/parkingmode/create";
    }

    @PostMapping("/create")
    public String createHinhThucGuiXe(@ModelAttribute("newHinhThuc") ParkingMode hinhThucGuiXe) {
        parkingModeService.save(hinhThucGuiXe);
        return "redirect:/admin/parkingmode";
    }

    @GetMapping("/update/{maHinhThuc}")
    public String getUpdatePage(Model model, @PathVariable String maHinhThuc) {
        Optional<ParkingMode> currentHinhThuc = parkingModeService.findById(maHinhThuc);

        if (currentHinhThuc.isPresent()) {
            model.addAttribute("newHinhThuc", currentHinhThuc.get());
        } else {
            model.addAttribute("errorMessage", "Không tìm thấy Hình Thức Gửi Xe với mã " + maHinhThuc);
            return "admin/parkingmode/error";
        }

        return "admin/parkingmode/update";
    }

    @PostMapping("/update")
    public String updateHinhThucGuiXe(@ModelAttribute("newHinhThuc") ParkingMode hinhThucGuiXe) {
        parkingModeService.save(hinhThucGuiXe);
        return "redirect:/admin/parkingmode";
    }

    @GetMapping("/delete/{maHinhThuc}")
    public String getDeletePage(Model model, @PathVariable String maHinhThuc) {
        model.addAttribute("newParkingMode", new ParkingMode());
        model.addAttribute("maHinhThuc", maHinhThuc);
        return "admin/parkingmode/delete";
    }

    @PostMapping("/delete")
    public String deleteHinhThucGuiXe(@ModelAttribute("newParkingMode") ParkingMode hinhThucGuiXe) {
        parkingModeService.deleteById(hinhThucGuiXe.getMaHinhThuc());
        return "redirect:/admin/parkingmode";
    }
}
