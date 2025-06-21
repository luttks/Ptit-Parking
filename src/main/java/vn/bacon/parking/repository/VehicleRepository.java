package vn.bacon.parking.repository;

import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.Vehicle;

@Repository
public interface VehicleRepository extends JpaRepository<Vehicle, String> {
    Page<Vehicle> findByMaSV_MaSV(String maSV, Pageable pageable);

    boolean existsById(String bienSoXe);

    Page<Vehicle> findByMaNV_MaNV(String maNV, Pageable pageable);

    Optional<Vehicle> findByBienSoXe(String bienSoXe);

    Page<Vehicle> findByMaLoaiXe_MaLoaiXe(String maLoaiXe, Pageable pageable);

    Page<Vehicle> findByMaLoaiXe_TenLoaiXeContainingIgnoreCase(String tenLoaiXe, Pageable pageable);

    boolean existsByMaSV_MaSV(String maSV);

    boolean existsByMaNV_MaNV(String maNV);

    Page<Vehicle> findByMaNVIsNotNull(Pageable pageable);

    Page<Vehicle> findByMaSVIsNotNull(Pageable pageable);
}