package vn.bacon.parking.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

import java.time.LocalDate;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name = "SinhVien")
public class Student {
    @Id
    @Column(name = "MaSV", length = 20, columnDefinition = "nchar(20)")
    @NotBlank(message = "Mã SV không được để trống")
    @Size(max = 20, message = "Mã SV không được vượt quá 20 ký tự")
    private String maSV;

    @Column(name = "HoTen", nullable = false, length = 80, columnDefinition = "nvarchar(80)")
    @NotBlank(message = "Họ tên không được để trống")
    @Size(max = 80, message = "Họ tên không được vượt quá 80 ký tự")
    private String hoTen;

    @Column(name = "DiaChi", nullable = false, length = 200, columnDefinition = "nvarchar(200)")
    @NotBlank(message = "Địa chỉ không được để trống")
    @Size(max = 200, message = "Địa chỉ không được vượt quá 200 ký tự")
    private String diaChi;

    @DateTimeFormat(pattern = "dd/MM/yyyy")
    @Column(name = "NgaySinh")
    private LocalDate ngaySinh;

    @Column(name = "QueQuan", columnDefinition = "text")
    @Size(max = 65535, message = "Quê quán quá dài")
    private String queQuan;

    @Column(name = "SDT", nullable = false, length = 30, unique = true, columnDefinition = "nvarchar(30)")
    @NotBlank(message = "SĐT không được để trống")
    @Pattern(regexp = "^\\d{10}$", message = "SĐT phải là số và có đúng 10 chữ số")
    private String sdt;

    @Column(name = "Email", length = 200, unique = true, columnDefinition = "nvarchar(200)")
    @Email(message = "Email không hợp lệ")
    @Size(max = 200, message = "Email không được vượt quá 200 ký tự")
    private String email;

    @OneToOne(mappedBy = "maSV", fetch = FetchType.LAZY)
    private Account account;

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    @ManyToOne
    @JoinColumn(name = "MaLop", nullable = true)
    private Class lop;

    public Class getLop() {
        return lop;
    }

    public void setLop(Class lop) {
        this.lop = lop;
    }

    @Column(name = "Avatar", length = 255)
    private String avatar;

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getMaSV() {
        return maSV;
    }

    public void setMaSV(String maSV) {
        this.maSV = maSV;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getDiaChi() {
        return diaChi;
    }

    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }

    public LocalDate getNgaySinh() {
        return ngaySinh;
    }

    public void setNgaySinh(LocalDate ngaySinh) {
        this.ngaySinh = ngaySinh;
    }

    public String getQueQuan() {
        return queQuan;
    }

    public void setQueQuan(String queQuan) {
        this.queQuan = queQuan;
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

    @Override
    public String toString() {
        return "Student [maSV=" + maSV + ", hoTen=" + hoTen + ", diaChi=" + diaChi + ", ngaySinh=" + ngaySinh
                + ", queQuan=" + queQuan + ", sdt=" + sdt + ", email=" + email + "]";
    }
}