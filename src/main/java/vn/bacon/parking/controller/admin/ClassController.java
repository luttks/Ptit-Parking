package vn.bacon.parking.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import vn.bacon.parking.domain.Class;
import vn.bacon.parking.service.ClassService;
import java.util.Optional;

@Controller
@RequestMapping("/admin/class")
public class ClassController {
    private final ClassService classService;

    @Autowired
    public ClassController(ClassService classService) {
        this.classService = classService;
    }

    @GetMapping
    public String listClass(@RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Class> classPage = classService.getClassPage(pageable);
        model.addAttribute("classPage", classPage);
        model.addAttribute("classList", classPage.getContent());
        return "admin/class/show";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("newClass", new Class());
        return "admin/class/create";
    }

    @PostMapping("/create")
    public String createClass(@Valid @ModelAttribute("newClass") Class classObj,
            BindingResult result,
            Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "admin/class/create";
        }

        if (classService.existsByTenLop(classObj.getTenLop())) {
            result.rejectValue("tenLop", "error.class", "Tên lớp đã tồn tại!");
            return "admin/class/create";
        }

        try {
            classService.saveClass(classObj);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Thêm lớp " + classObj.getMaLop() + " thành công");
            return "redirect:/admin/class";
        } catch (DataIntegrityViolationException e) {
            String message = e.getMostSpecificCause().getMessage();
            if (message.contains("TENLOP")) {
                result.rejectValue("tenLop", "error.class", "Tên lớp đã tồn tại!");
            } else {
                result.rejectValue("maLop", "error.class", "Lỗi cơ sở dữ liệu: " + message);
            }
            return "admin/class/create";
        }
    }

    @GetMapping("/{maLop}")
    public String viewClass(@PathVariable String maLop, Model model) {
        Optional<Class> classObj = classService.getClassById(maLop);
        if (classObj.isPresent()) {
            model.addAttribute("classObj", classObj.get());
            return "admin/class/view";
        }
        return "redirect:/admin/class";
    }

    @GetMapping("/update/{maLop}")
    public String showUpdateForm(@PathVariable String maLop, Model model) {
        Optional<Class> classObj = classService.getClassById(maLop);
        if (classObj.isPresent()) {
            model.addAttribute("newClass", classObj.get());
            return "admin/class/update";
        }
        return "redirect:/admin/class";
    }

    @PostMapping("/update")
    public String updateClass(@Valid @ModelAttribute("newClass") Class updatedClass,
            BindingResult result,
            Model model, RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "admin/class/update";
        }

        Optional<Class> existingClassOpt = classService.getClassById(updatedClass.getMaLop());
        if (!existingClassOpt.isPresent()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Lớp không tồn tại!");
            return "redirect:/admin/class";
        }
        Class existingClass = existingClassOpt.get();

        if (updatedClass.getTenLop() != null && !updatedClass.getTenLop().equals(existingClass.getTenLop()) &&
                classService.existsByTenLopAndNotMaLop(updatedClass.getTenLop(), updatedClass.getMaLop())) {
            result.rejectValue("tenLop", "error.class", "Tên lớp đã tồn tại!");
            return "admin/class/update";
        }

        existingClass.setTenLop(updatedClass.getTenLop());
        existingClass.setKhoaHoc(updatedClass.getKhoaHoc());

        try {
            classService.saveClass(existingClass);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Cập nhật lớp " + existingClass.getMaLop() + " thành công");
            return "redirect:/admin/class";
        } catch (DataIntegrityViolationException e) {
            String message = e.getMostSpecificCause().getMessage();
            if (message.contains("TENLOP")) {
                result.rejectValue("tenLop", "error.class", "Tên lớp đã tồn tại!");
            } else {
                result.rejectValue("maLop", "error.class", "Lỗi cơ sở dữ liệu: " + message);
            }
            return "admin/class/update";
        }
    }

    @GetMapping("/delete/confirm/{maLop}")
    public String showDeleteConfirm(@PathVariable String maLop, Model model) {
        Optional<Class> classObj = classService.getClassById(maLop);
        if (classObj.isPresent()) {
            model.addAttribute("maLop", maLop);
            return "admin/class/delete";
        }
        return "redirect:/admin/class";
    }

    @GetMapping("/delete/{maLop}")
    public String deleteClass(@PathVariable String maLop, RedirectAttributes redirectAttributes) {
        if (classService.getClassById(maLop).isPresent()) {
            try {
                classService.deleteClassById(maLop);
                redirectAttributes.addFlashAttribute("successMessage", "Xóa lớp " + maLop + " thành công");
            } catch (DataIntegrityViolationException e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa lớp do có dữ liệu liên quan!");
            }
        }
        return "redirect:/admin/class";
    }
}