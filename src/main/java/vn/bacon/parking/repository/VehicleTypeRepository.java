package vn.bacon.parking.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.VehicleType;

@Repository
public interface VehicleTypeRepository extends JpaRepository<VehicleType, String> {

}
