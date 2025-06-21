package vn.bacon.parking.controller.admin;

import java.util.Optional;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.domain.VehicleType;
import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.service.PriceService;
import vn.bacon.parking.service.VehicleTypeService;
import vn.bacon.parking.service.ParkingModeService;

@Controller
@RequestMapping("/admin/price")
public class PriceController {
    @Autowired
    private PriceService priceService;

    @Autowired
    private VehicleTypeService vehicleTypeService;

    @Autowired
    private ParkingModeService parkingModeService;

    // Hiển thị danh sách Bảng Giá
    @GetMapping
    public String listPrice(@RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Price> BangGiaPage = priceService.getBangGiaPage(pageable);
        model.addAttribute("bangGiaPage", BangGiaPage);
        model.addAttribute("bangGiaList", BangGiaPage.getContent());
        return "admin/price/show";
    }

    // Hiển thị form Thêm Bảng Giá
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        List<ParkingMode> parkingModes = parkingModeService.findAll();
        List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
        model.addAttribute("newBangGia", new Price());
        model.addAttribute("vehicleTypes", vehicleTypes);
        model.addAttribute("parkingModes", parkingModes);
        return "admin/price/create";
    }

    // Xử lý Thêm Bảng Giá
    @PostMapping("/create")
    public String createPrice(@Valid @ModelAttribute("newBangGia") Price price,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
            List<ParkingMode> parkingModes = parkingModeService.findAll();

            model.addAttribute("vehicleTypes", vehicleTypes);
            model.addAttribute("parkingModes", parkingModes);
            return "admin/price/create";
        }

        try {
            priceService.savePrice(price);
            redirectAttributes.addFlashAttribute("success", "Thêm bảng giá thành công!");
            return "redirect:/admin/price";
        } catch (IllegalArgumentException e) {
            List<VehicleType> vehicleTypes = vehicleTypeService.getAllVehicleTypes();
            List<ParkingMode> parkingModes = parkingModeService.findAll();

            model.addAttribute("vehicleTypes", vehicleTypes);
            model.addAttribute("parkingModes", parkingModes);
            model.addAttribute("error", e.getMessage());
            return "admin/price/create";
        }
    }

    // Hiển thị form Cập Nhật Bảng Giá
    @GetMapping("/update/{maBangGia}")
    public String getUpdatePricePage(Model model, @PathVariable String maBangGia) {
        Optional<Price> currentBangGia = this.priceService.findById(maBangGia);
        model.addAttribute("newBangGia", currentBangGia.get());
        return "admin/price/update";
    }

    // Xử lý Cập Nhật Bảng Giá
    @PostMapping("/update")
    public String updateBangGia(Model model, @ModelAttribute("newBangGia") Price BangGia) {
        Price currentBangGia = this.priceService.findById(BangGia.getMaBangGia()).get();
        if (currentBangGia != null) {
            currentBangGia.setMaBangGia(BangGia.getMaBangGia());
            currentBangGia.setMaLoaiXe(BangGia.getMaLoaiXe());
            currentBangGia.setMaHinhThuc(BangGia.getMaHinhThuc());
            currentBangGia.setGia(BangGia.getGia());

            priceService.savePrice(currentBangGia);
        }
        return "redirect:/admin/price";
    }

    // Hiển thị form Xóa Bảng Giá
    @GetMapping("/delete/{maBangGia}")
    public String getDeletePage(Model model, @PathVariable String maBangGia) {
        model.addAttribute("maBangGia", maBangGia);
        model.addAttribute("newPrice", new Price());
        return "admin/price/delete";
    }

    // Xử lý Xóa Bảng Giá
    @PostMapping("/delete")
    public String deleteBangGia(@ModelAttribute("newPrice") Price BangGia) {
        this.priceService.deletePrice(BangGia.getMaBangGia());
        return "redirect:/admin/price";
    }
}