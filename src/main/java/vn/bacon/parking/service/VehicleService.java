package vn.bacon.parking.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.repository.VehicleRepository;
import vn.bacon.parking.domain.VehicleType;

@Service
public class VehicleService {
    private final VehicleRepository vehicleRepository;

    public VehicleService(VehicleRepository vehicleRepository) {
        this.vehicleRepository = vehicleRepository;
    }

    public Optional<Vehicle> findByBienSoXe(String bienSoXe) {
        return vehicleRepository.findById(bienSoXe);
    }

    public Vehicle saveVehicle(Vehicle vehicle) {
        return this.vehicleRepository.save(vehicle);
    }

    public Page<Vehicle> getAllVehicles(Pageable pageable) {
        Sort sort = Sort.by("createdDate").descending();
        Pageable sortedPageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), sort);
        return this.vehicleRepository.findAll(sortedPageable);
    }

    public Optional<Vehicle> getVehicleById(String bienSoXe) {
        return this.vehicleRepository.findById(bienSoXe);
    }

    public void deleteVehicleById(String bienSoXe) {
        this.vehicleRepository.deleteById(bienSoXe);
    }

    public Page<Vehicle> getVehiclePage(Pageable pageable) {
        return vehicleRepository.findAll(pageable);
    }

    public Page<Vehicle> getVehiclesByStudentId(String maSV, Pageable pageable) {
        return vehicleRepository.findByMaSV_MaSV(maSV, pageable);
    }

    public boolean existsByBienSoXe(String bienSoXe) {
        return vehicleRepository.existsById(bienSoXe);
    }

    public Page<Vehicle> getVehiclesByStaffId(String maNV, Pageable pageable) {
        return vehicleRepository.findByMaNV_MaNV(maNV, pageable);
    }

    public boolean checkBienSoXeExists(String bienSoXe) {
        return vehicleRepository.findByBienSoXe(bienSoXe).isPresent();
    }

    public Page<Vehicle> getVehiclesByMaLoaiXe(String maLoaiXe, Pageable pageable) {
        return vehicleRepository.findByMaLoaiXe_MaLoaiXe(maLoaiXe, pageable);
    }

    public Page<Vehicle> getVehiclesByTenLoaiXe(String tenLoaiXe, Pageable pageable) {
        return vehicleRepository.findByMaLoaiXe_TenLoaiXeContainingIgnoreCase(tenLoaiXe, pageable);
    }

    public Page<Vehicle> searchVehiclesByBienSoXe(String bienSoXe, Pageable pageable) {
        Optional<Vehicle> foundVehicle = vehicleRepository.findByBienSoXe(bienSoXe);
        if (foundVehicle.isPresent()) {
            return new org.springframework.data.domain.PageImpl<>(List.of(foundVehicle.get()), pageable, 1);
        } else {
            return Page.empty(pageable);
        }
    }

    public Page<Vehicle> getVehiclesWithStaff(Pageable pageable) {
        return vehicleRepository.findByMaNVIsNotNull(pageable);
    }

    public Page<Vehicle> getVehiclesWithStudent(Pageable pageable) {
        return vehicleRepository.findByMaSVIsNotNull(pageable);
    }

    // to check dependencies
    public String checkDependencies(String bienSoXe) {
        if (vehicleRepository.hasEntryExitDetails(bienSoXe)) {
            return "Xe này không thể xóa vì đã có lịch sử vào/ra trong hệ thống.";
        }
        if (vehicleRepository.hasRegisterMonth(bienSoXe)) {
            return "Xe này không thể xóa vì đã có đăng ký tháng trong hệ thống.";
        }
        return null; // No dependencies found
    }
}