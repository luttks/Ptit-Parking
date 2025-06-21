package vn.bacon.parking.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import vn.bacon.parking.domain.Account;

@Repository
public interface AccountRepository extends JpaRepository<Account, String> {

    // List<Account> findByLoaiTK(String loaiTK);

    // @Query("SELECT t FROM Account t WHERE t.maTK LIKE %:tuKhoa% OR t.loaiTK LIKE
    // %:tuKhoa%")
    // List<Account> timKiemTheoTuKhoa(@Param("tuKhoa") String tuKhoa);

    boolean existsByUsername(String username);

    Optional<Account> findByUsername(String username);

    Page<Account> findByUsernameContainingIgnoreCase(String username, Pageable pageable);

    Page<Account> findByRole_RoleID(Integer roleId, Pageable pageable);
}
