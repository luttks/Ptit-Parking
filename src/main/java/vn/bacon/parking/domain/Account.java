package vn.bacon.parking.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "TaiKhoan")
public class Account {
    @Id
    @Column(name = "Username", length = 50)
    private String username;

    @Column(name = "Password", nullable = false, length = 100)
    private String password;

    @Column(name = "Enabled", nullable = false)
    private boolean enabled;

    @ManyToOne
    @JoinColumn(name = "RoleID", nullable = false)
    private Role role;

    @ManyToOne
    @JoinColumn(name = "MaNV")
    private Staff maNV;

    @ManyToOne
    @JoinColumn(name = "MaSV")
    private Student maSV;

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public Staff getMaNV() {
        return maNV;
    }

    public void setMaNV(Staff maNV) {
        this.maNV = maNV;
    }

    public Student getMaSV() {
        return maSV;
    }

    public void setMaSV(Student maSV) {
        this.maSV = maSV;
    }

    @Override
    public String toString() {
        return "Account [username=" + username + ", password=" + password + ", enabled=" + enabled + ", role=" + role
                + ", maNV=" + maNV + ", maSV=" + maSV + "]";
    }
}