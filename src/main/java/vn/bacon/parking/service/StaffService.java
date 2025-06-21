package vn.bacon.parking.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.repository.StaffRepository;
import vn.bacon.parking.repository.VehicleRepository;

@Service
public class StaffService {
    private static final Logger logger = LoggerFactory.getLogger(StaffService.class);

    private final StaffRepository staffRepository;
    private final UploadService uploadService;
    private final AccountService accountService;
    private final VehicleRepository vehicleRepository;

    public StaffService(StaffRepository staffRepository, UploadService uploadService, AccountService accountService,
            VehicleRepository vehicleRepository) {
        this.uploadService = uploadService;
        this.staffRepository = staffRepository;
        this.accountService = accountService;
        this.vehicleRepository = vehicleRepository;
    }

    public List<Staff> getAllStaffs() {
        return this.staffRepository.findAll();
    }

    public Optional<Staff> getStaffById(String maNV) {
        return this.staffRepository.findById(maNV);
    }

    public void deleteStaffById(String maNV) {
        logger.info("Đang cố gắng xóa nhân viên với maNV: {}", maNV);
        Optional<Staff> staffOpt = staffRepository.findById(maNV);
        if (staffOpt.isPresent()) {
            if (accountService.existsByUsername(maNV)) {
                logger.warn("Nhân viên với maNV {} vẫn có tài khoản liên quan", maNV);
                throw new IllegalStateException("Vui lòng xóa tài khoản liên quan trước khi xóa nhân viên");
            }
            if (hasRegisteredVehicle(maNV)) {
                logger.warn("Nhân viên với maNV {} đã đăng ký xe", maNV);
                throw new IllegalStateException("Không thể xóa nhân viên vì nhân viên này đã đăng ký xe!");
            }
            staffRepository.deleteById(maNV);
            logger.info("Xóa nhân viên với maNV {} thành công", maNV);
        } else {
            logger.warn("Nhân viên với maNV {} không tồn tại", maNV);
            throw new IllegalStateException("Nhân viên với mã " + maNV + " không tồn tại!");
        }
    }

    public boolean hasRegisteredVehicle(String maNV) {
        boolean hasVehicles = vehicleRepository.existsByMaNV_MaNV(maNV);
        logger.debug("Checking vehicles for maNV: {}. Result: {}", maNV, hasVehicles);
        return hasVehicles;
    }

    public Page<Staff> getStaffPage(Pageable pageable) {
        // Sắp xếp theo maNV giảm dần
        Pageable sortedByMaNVDesc = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(),
                Sort.by("maNV").descending());
        return staffRepository.findAll(sortedByMaNVDesc);
    }

    public Staff saveStaff(Staff staff) {
        return this.staffRepository.save(staff);
    }

    public boolean existsBySdt(String sdt) {
        return staffRepository.existsBySdt(sdt);
    }

    public boolean existsByEmail(String email) {
        return email != null && !email.isEmpty() && staffRepository.existsByEmail(email);
    }

    public boolean existsByCccd(String cccd) {
        return cccd != null && !cccd.isEmpty() && staffRepository.existsByCccd(cccd);
    }

    public boolean existsBySdtAndNotMaNV(String sdt, String maNV) {
        return staffRepository.existsBySdtAndMaNVNot(sdt, maNV);
    }

    public boolean existsByEmailAndNotMaNV(String email, String maNV) {
        return email != null && !email.isEmpty() && staffRepository.existsByEmailAndMaNVNot(email, maNV);
    }

    public boolean existsByCccdAndNotMaNV(String cccd, String maNV) {
        return cccd != null && !cccd.isEmpty() && staffRepository.existsByCccdAndMaNVNot(cccd, maNV);
    }

    public String handleAvatarUpload(MultipartFile file, String targetFolder) {
        return uploadService.handleSaveUploadFile(file, targetFolder);
    }

    public Staff getCurrentStaff() {
        String staffId = SecurityContextHolder.getContext().getAuthentication().getName().trim();
        logger.debug("Fetching current staff with ID: '{}'", staffId);
        return staffRepository.findById(staffId)
                .orElseThrow(() -> new IllegalStateException("Không tìm thấy nhân viên với ID: " + staffId));
    }

    public boolean existsByMaNV(String maNV) {
        return staffRepository.existsById(maNV);
    }

}
