package vn.bacon.parking.repository;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.Class;

@Repository
public interface ClassRepository extends JpaRepository<Class, String> {
    boolean existsByTenLop(String tenLop);

    boolean existsByTenLopAndMaLopNot(String tenLop, String maLop);

    List<Class> findAll(Sort sort);

}
