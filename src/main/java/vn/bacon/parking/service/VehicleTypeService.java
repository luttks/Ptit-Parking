package vn.bacon.parking.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import vn.bacon.parking.domain.VehicleType;
import vn.bacon.parking.repository.VehicleTypeRepository;

@Service
public class VehicleTypeService {
    private final VehicleTypeRepository vehicleTypeRepository;

    public VehicleTypeService(VehicleTypeRepository vehicleTypeRepository) {
        this.vehicleTypeRepository = vehicleTypeRepository;
    }

    public VehicleType saveVehicleType(VehicleType vehicleType) {
        return this.vehicleTypeRepository.save(vehicleType);
    }

    public List<VehicleType> getAllVehicleTypes() {
        return this.vehicleTypeRepository.findAll();
    }

    public Optional<VehicleType> getVehicleTypeById(String maLoaiXe) {
        return this.vehicleTypeRepository.findById(maLoaiXe);
    }

    public void deleteVehicleTypeById(String maLoaiXe) {
        this.vehicleTypeRepository.deleteById(maLoaiXe);
    }

}
