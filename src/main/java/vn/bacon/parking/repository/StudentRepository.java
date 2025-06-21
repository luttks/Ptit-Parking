package vn.bacon.parking.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.Student;

@Repository
public interface StudentRepository extends JpaRepository<Student, String> {
    boolean existsBySdt(String sdt);

    boolean existsByEmail(String email);

    boolean existsBySdtAndMaSVNot(String sdt, String maSV);

    boolean existsByEmailAndMaSVNot(String email, String maSV);

    Page<Student> findByLopMaLop(String maLop, Pageable pageable);

}
