package vn.bacon.parking.domain;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

@Entity
@Table(name = "Lop")
public class Class {
    @Id
    @Column(name = "MALOP", length = 10, columnDefinition = "nchar(10)")
    @NotBlank(message = "Mã lớp không được để trống")
    @Size(max = 10, message = "Mã lớp không được vượt quá 10 ký tự")
    private String maLop;

    @Column(name = "TENLOP", nullable = false, length = 50, columnDefinition = "nvarchar(50)")
    @NotBlank(message = "Tên lớp không được để trống")
    @Size(max = 50, message = "Tên lớp không được vượt quá 50 ký tự")
    private String tenLop;

    @Column(name = "KHOAHOC", length = 9, columnDefinition = "nchar(9)")
    @Size(max = 9, message = "Khóa học không được vượt quá 9 ký tự")
    private String khoaHoc;

    // Getters và Setters
    public String getMaLop() {
        return maLop;
    }

    public void setMaLop(String maLop) {
        this.maLop = maLop;
    }

    public String getTenLop() {
        return tenLop;
    }

    public void setTenLop(String tenLop) {
        this.tenLop = tenLop;
    }

    public String getKhoaHoc() {
        return khoaHoc;
    }

    public void setKhoaHoc(String khoaHoc) {
        this.khoaHoc = khoaHoc;
    }

    @Override
    public String toString() {
        return "Lop [maLop=" + maLop + ", tenLop=" + tenLop + ", khoaHoc=" + khoaHoc + "]";
    }
}
