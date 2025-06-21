package vn.bacon.parking.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.EntryExitDetail;
import vn.bacon.parking.domain.Vehicle;

public interface EntryExitDetailRepository extends JpaRepository<EntryExitDetail, Integer> {

    Page<EntryExitDetail> findByTgRaIsNullAndNvRaIsNull(Pageable pageable);

    Page<EntryExitDetail> findByBienSoXeIn(List<Vehicle> vehicleList, Pageable pageable);

    boolean existsByBienSoXeAndTgRaIsNull(Vehicle bienSoXe);
}