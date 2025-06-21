package vn.bacon.parking.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.Staff;

@Repository
public interface StaffRepository extends JpaRepository<Staff, String> {
    boolean existsBySdt(String sdt);

    boolean existsByEmail(String email);

    boolean existsByCccd(String cccd);

    boolean existsBySdtAndMaNVNot(String sdt, String maNV);

    boolean existsByEmailAndMaNVNot(String email, String maNV);

    boolean existsByCccdAndMaNVNot(String cccd, String maNV);

}
