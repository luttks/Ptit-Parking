package vn.bacon.parking.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.bacon.parking.domain.Role;

@Repository
public interface RoleRepository extends JpaRepository<Role, Integer> {
}