package vn.bacon.parking.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.RegisterMonth;
import vn.bacon.parking.domain.Vehicle;

@Repository
public interface RegisterMonthRepository extends JpaRepository<RegisterMonth, String> {
        List<RegisterMonth> findByBienSoXe_BienSoXe(String bienSoXe);

        @Query("SELECT r FROM RegisterMonth r WHERE r.bienSoXe.bienSoXe LIKE %:tuKhoa%")
        List<RegisterMonth> timKiemTheoBienSoXe(@Param("tuKhoa") String tuKhoa);

        @Query("SELECT r FROM RegisterMonth r WHERE r.ngayKetThuc >= :ngayHienTai")
        List<RegisterMonth> timDangKyConHieuLuc(@Param("ngayHienTai") LocalDate ngayHienTai);

        @Query("SELECT r FROM RegisterMonth r WHERE r.ngayKetThuc < :ngayHienTai")
        List<RegisterMonth> timDangKyDaHetHan(@Param("ngayHienTai") LocalDate ngayHienTai);

        @Query("SELECT COALESCE(MAX(CAST(maDangKy AS integer)), 0) FROM RegisterMonth")
        Long findMaxMaDangKy();

        boolean existsByBienSoXe_BienSoXeAndTrangThaiInAndNgayKetThucGreaterThanEqual(
                        String bienSoXe, List<String> trangThai, LocalDate ngayKetThuc);

        boolean existsByBienSoXe_BienSoXeAndMaDangKyNotAndTrangThaiInAndNgayKetThucGreaterThanEqual(
                        String bienSoXe, String maDangKy, List<String> trangThai, LocalDate ngayKetThuc);

        @Query("SELECT r FROM RegisterMonth r WHERE r.bienSoXe = :bienSoXe AND r.ngayKetThuc > :currentDate AND r.trangThai = 'Đã duyệt'")
        RegisterMonth findByBienSoXeAndNgayKetThucAfterAndTrangThaiDaDuyet(@Param("bienSoXe") Vehicle bienSoXe,
                        @Param("currentDate") LocalDate currentDate);

        boolean existsByBienSoXe_BienSoXeAndTrangThaiAndNgayBatDauLessThanEqualAndNgayKetThucGreaterThanEqual(
                        String bienSoXe, String trangThai, LocalDate ngayBatDau, LocalDate ngayKetThuc);

        // New method to check for overlapping date ranges
        @Query("SELECT COUNT(r) > 0 FROM RegisterMonth r WHERE r.bienSoXe.bienSoXe = :bienSoXe " +
                        "AND (:ngayBatDau <= r.ngayKetThuc AND :ngayKetThuc >= r.ngayBatDau)")
        boolean existsByBienSoXe_BienSoXeAndDateRangeOverlap(
                        @Param("bienSoXe") String bienSoXe,
                        @Param("ngayBatDau") LocalDate ngayBatDau,
                        @Param("ngayKetThuc") LocalDate ngayKetThuc);

        // New method to check for overlapping date ranges excluding a specific maDangKy
        @Query("SELECT COUNT(r) > 0 FROM RegisterMonth r WHERE r.bienSoXe.bienSoXe = :bienSoXe " +
                        "AND r.maDangKy != :maDangKy " +
                        "AND (:ngayBatDau <= r.ngayKetThuc AND :ngayKetThuc >= r.ngayBatDau)")
        boolean existsByBienSoXe_BienSoXeAndMaDangKyNotAndDateRangeOverlap(
                        @Param("bienSoXe") String bienSoXe,
                        @Param("maDangKy") String maDangKy,
                        @Param("ngayBatDau") LocalDate ngayBatDau,
                        @Param("ngayKetThuc") LocalDate ngayKetThuc);

        // New method to find the latest ngayKetThuc for a vehicle
        @Query("SELECT MAX(r.ngayKetThuc) FROM RegisterMonth r WHERE r.bienSoXe.bienSoXe = :bienSoXe")
        Optional<LocalDate> findLatestNgayKetThucByBienSoXe(@Param("bienSoXe") String bienSoXe);

        @Query("SELECT r FROM RegisterMonth r WHERE r.ngayKetThuc >= :ngayHienTai")
        Page<RegisterMonth> findByNgayKetThucGreaterThanEqual(@Param("ngayHienTai") LocalDate ngayHienTai,
                        Pageable pageable);

        @Query("SELECT r FROM RegisterMonth r WHERE r.ngayKetThuc < :ngayHienTai")
        Page<RegisterMonth> findByNgayKetThucLessThan(@Param("ngayHienTai") LocalDate ngayHienTai, Pageable pageable);
}