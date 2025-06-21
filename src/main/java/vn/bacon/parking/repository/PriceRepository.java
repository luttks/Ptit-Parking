package vn.bacon.parking.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.domain.VehicleType;

public interface PriceRepository extends JpaRepository<Price, String> {
    Price findByMaHinhThucAndMaLoaiXe(ParkingMode maHinhThuc, VehicleType maLoaiXe);

    boolean existsByMaLoaiXeAndMaHinhThuc(VehicleType maLoaiXe, ParkingMode maHinhThuc);

    List<Price> findByMaHinhThuc(ParkingMode maHinhThuc);

}
