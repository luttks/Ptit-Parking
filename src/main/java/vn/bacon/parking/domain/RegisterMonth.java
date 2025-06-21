package vn.bacon.parking.domain;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "DangKyThang")
public class RegisterMonth {
    @Id
    @Column(name = "MaDangKy", length = 10, columnDefinition = "nchar(10)")
    private String maDangKy;

    @ManyToOne
    @JoinColumn(name = "BienSoXe", nullable = false)
    private Vehicle bienSoXe;

    @ManyToOne
    @JoinColumn(name = "MaNV", nullable = true)
    private Staff maNV;

    @Column(name = "NgayDangKy", nullable = false)
    private LocalDate ngayDangKy;

    @Column(name = "NgayBatDau", nullable = false)
    private LocalDate ngayBatDau;

    @Column(name = "NgayKetThuc", nullable = false)
    private LocalDate ngayKetThuc;

    @Column(name = "TrangThai", nullable = false, length = 20)
    private String trangThai;

    @Column(name = "GhiChu", length = 255)
    private String ghiChu;

    @ManyToOne
    @JoinColumn(name = "MaBangGia", nullable = false)
    private Price bangGia;

    @Column(name = "Gia", nullable = false)
    private Integer gia; // Reverted to Integer

    // Getters and Setters
    public String getMaDangKy() {
        return maDangKy;
    }

    public void setMaDangKy(String maDangKy) {
        this.maDangKy = maDangKy;
    }

    public Vehicle getBienSoXe() {
        return bienSoXe;
    }

    public void setBienSoXe(Vehicle bienSoXe) {
        this.bienSoXe = bienSoXe;
    }

    public Staff getMaNV() {
        return maNV;
    }

    public void setMaNV(Staff maNV) {
        this.maNV = maNV;
    }

    public LocalDate getNgayDangKy() {
        return ngayDangKy;
    }

    public void setNgayDangKy(LocalDate ngayDangKy) {
        this.ngayDangKy = ngayDangKy;
    }

    public LocalDate getNgayBatDau() {
        return ngayBatDau;
    }

    public void setNgayBatDau(LocalDate ngayBatDau) {
        this.ngayBatDau = ngayBatDau;
    }

    public LocalDate getNgayKetThuc() {
        return ngayKetThuc;
    }

    public void setNgayKetThuc(LocalDate ngayKetThuc) {
        this.ngayKetThuc = ngayKetThuc;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getGhiChu() {
        return ghiChu;
    }

    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }

    public Price getBangGia() {
        return bangGia;
    }

    public void setBangGia(Price bangGia) {
        this.bangGia = bangGia;
    }

    public Integer getGia() {
        return gia;
    }

    public void setGia(Integer gia) {
        this.gia = gia;
    }

    public Date getNgayDangKyAsDate() {
        return ngayDangKy != null ? Date.from(ngayDangKy.atStartOfDay(ZoneId.systemDefault()).toInstant()) : null;
    }

    public Date getNgayBatDauAsDate() {
        return ngayBatDau != null ? Date.from(ngayBatDau.atStartOfDay(ZoneId.systemDefault()).toInstant()) : null;
    }

    public Date getNgayKetThucAsDate() {
        return ngayKetThuc != null ? Date.from(ngayKetThuc.atStartOfDay(ZoneId.systemDefault()).toInstant()) : null;
    }

    @Override
    public String toString() {
        return "RegisterMonth [maDangKy=" + maDangKy + ", bienSoXe=" + bienSoXe + ", maNV=" + maNV
                + ", ngayDangKy=" + ngayDangKy + ", ngayBatDau=" + ngayBatDau + ", ngayKetThuc=" + ngayKetThuc
                + ", trangThai=" + trangThai + ", ghiChu=" + ghiChu + ", bangGia=" + bangGia + ", gia=" + gia + "]";
    }
}