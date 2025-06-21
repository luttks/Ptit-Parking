package vn.bacon.parking.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import vn.bacon.parking.domain.VehicleType;
import vn.bacon.parking.service.VehicleTypeService;

@Controller
public class VehicleTypeController {

    private final VehicleTypeService vehicleTypeService;

    public VehicleTypeController(VehicleTypeService vehicleTypeService) {
        this.vehicleTypeService = vehicleTypeService;
    }

    @GetMapping("/admin/vehicleType")
    public String getVehicleTypePage(Model model) {
        List<VehicleType> vehicleTypes = this.vehicleTypeService.getAllVehicleTypes();
        model.addAttribute("vehicleTypeshow", vehicleTypes);
        return "admin/vehicleType/show";
    }

    @GetMapping("admin/vehicleType/create")
    public String getCreateVehicleTypePage(Model model) {
        model.addAttribute("newVehicleType", new VehicleType());
        return "admin/vehicleType/create";
    }

    @PostMapping("admin/vehicleType/create")
    public String createVehicleType(@ModelAttribute("newVehicleType") VehicleType vehicleType1) {
        this.vehicleTypeService.saveVehicleType(vehicleType1);
        return "redirect:/admin/vehicleType";
    }

    // Update vehicle type
    @GetMapping("admin/vehicleType/update/{maLoaiXe}")
    public String getUpdateVehicleTypePage(Model model, @PathVariable String maLoaiXe) {
        Optional<VehicleType> currentVehicleType = this.vehicleTypeService.getVehicleTypeById(maLoaiXe);
        model.addAttribute("newVehicleType", currentVehicleType);
        return "admin/vehicleType/update";
    }

    @PostMapping("admin/vehicleType/update")
    public String updateVehicleType(Model model, @ModelAttribute("newVehicleType") VehicleType vehicleType1) {
        VehicleType currentVehicleType = this.vehicleTypeService.getVehicleTypeById(vehicleType1.getMaLoaiXe()).get();
        if (currentVehicleType != null) {
            currentVehicleType.setMaLoaiXe(vehicleType1.getMaLoaiXe());
            currentVehicleType.setTenLoaiXe(vehicleType1.getTenLoaiXe());
            this.vehicleTypeService.saveVehicleType(currentVehicleType);
        }
        return "redirect:/admin/vehicleType";
    }

    @GetMapping("admin/vehicleType/delete/{maLoaiXe}")
    public String deleteVehicleType(Model model, @PathVariable String maLoaiXe) {
        model.addAttribute("newVehicleType", new VehicleType());
        return "admin/vehicleType/delete";
    }

    @PostMapping("admin/vehicleType/delete")
    public String deleteVehicleTypePost(@ModelAttribute("newVehicleType") VehicleType vehicleType1) {
        this.vehicleTypeService.deleteVehicleTypeById(vehicleType1.getMaLoaiXe());
        return "redirect:/admin/vehicleType";
    }
}