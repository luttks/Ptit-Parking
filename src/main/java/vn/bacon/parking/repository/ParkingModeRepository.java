package vn.bacon.parking.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.bacon.parking.domain.ParkingMode;

public interface ParkingModeRepository extends JpaRepository<ParkingMode, String> {

}
