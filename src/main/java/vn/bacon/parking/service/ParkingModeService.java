package vn.bacon.parking.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.repository.ParkingModeRepository;

@Service
public class ParkingModeService {
    private final ParkingModeRepository parkingModeRepository;

    public ParkingModeService(ParkingModeRepository parkingModeRepository) {
        this.parkingModeRepository = parkingModeRepository;
    }

    public List<ParkingMode> findAll() {
        return this.parkingModeRepository.findAll();
    }

    public Optional<ParkingMode> findById(String maHinhThuc) {
        return this.parkingModeRepository.findById(maHinhThuc);
    }

    public ParkingMode save(ParkingMode hinhThucGuiXe) {
        return this.parkingModeRepository.save(hinhThucGuiXe);
    }

    public void deleteById(String maHinhThuc) {
        this.parkingModeRepository.deleteById(maHinhThuc);
    }

}
