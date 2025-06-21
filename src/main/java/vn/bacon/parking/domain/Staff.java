package vn.bacon.parking.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name = "NhanVien")

public class Staff {
    @Id
    @Column(name = "MaNV", length = 10, columnDefinition = "nchar(10)")
    @NotBlank(message = "Mã NV không được để trống")
    @Size(max = 10, message = "Mã NV không được vượt quá 10 ký tự")
    // @Column(name = "MaNV")
    private String maNV;

    @Column(name = "HoTen", nullable = false, length = 50, columnDefinition = "nvarchar(50)")
    // @Column(name = "HoTen")
    @NotBlank(message = "Họ tên không được để trống")
    @Size(max = 50, message = "Họ tên không được vượt quá 50 ký tự")
    private String hoTen;

    @Column(name = "SDT", nullable = false, length = 15, columnDefinition = "nvarchar(15)", unique = true)
    // @Column(name = "SDT")
    @NotBlank(message = "SĐT không được để trống")
    @Pattern(regexp = "^\\d{10}$", message = "SĐT phải là số và có đúng 10 chữ số")
    private String sdt;

    @Column(name = "Email", nullable = false, length = 100, columnDefinition = "nvarchar(100)", unique = true)
    // @Column(name = "Email")
    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không hợp lệ")
    @Size(max = 100, message = "Email không được vượt quá 100 ký tự")
    private String email;

    @Column(name = "CCCD", nullable = false, length = 20, columnDefinition = "nvarchar(20)", unique = true)
    // @Column(name = "CCCD")
    @NotBlank(message = "CCCD không được để trống")
    @Size(max = 20, message = "CCCD không được vượt quá 20 ký tự")
    private String cccd;

    @Column(name = "ChucVu", nullable = false, columnDefinition = "nvarchar(50)", length = 50)
    // @Column(name = "ChucVu")
    @NotBlank(message = "Chức vụ không được để trống")
    @Size(max = 50, message = "Chức vụ không được vượt quá 50 ký tự")
    private String chucVu;

    @Column(name = "NgayVaoLam", nullable = false)
    @DateTimeFormat(pattern = "dd/MM/yyyy")
    // @NotNull(message = "Ngày vào làm không được để trống")
    private LocalDate ngayVaoLam;

    @Column(name = "Avatar", length = 255)
    private String avatar;

    @OneToOne(mappedBy = "maNV", fetch = FetchType.LAZY)
    private Account account;

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getMaNV() {
        return maNV;
    }

    public void setMaNV(String maNV) {
        this.maNV = maNV;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCccd() {
        return cccd;
    }

    public void setCccd(String cccd) {
        this.cccd = cccd;
    }

    public String getChucVu() {
        return chucVu;
    }

    public void setChucVu(String chucVu) {
        this.chucVu = chucVu;
    }

    public LocalDate getNgayVaoLam() {
        return ngayVaoLam;
    }

    public void setNgayVaoLam(LocalDate ngayVaoLam) {
        this.ngayVaoLam = ngayVaoLam;
    }

    @Override
    public String toString() {
        return "Staff [maNV=" + maNV + ", hoTen=" + hoTen + ", sdt=" + sdt + ", email=" + email + ", cccd=" + cccd
                + ", chucVu=" + chucVu + ", ngayVaoLam=" + ngayVaoLam + "]";
    }

}