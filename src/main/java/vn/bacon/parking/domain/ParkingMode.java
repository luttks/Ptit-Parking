package vn.bacon.parking.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "HinhThucGuiXe")
public class ParkingMode {
    @Id
    @Column(name = "MaHinhThuc", length = 10, columnDefinition = "nchar(10)")
    private String maHinhThuc;

    @Column(name = "TenHinhThuc", columnDefinition = "nvarchar(50)")
    private String tenHinhThuc;

    public String getMaHinhThuc() {
        return maHinhThuc;
    }

    public void setMaHinhThuc(String maHinhThuc) {
        this.maHinhThuc = maHinhThuc;
    }

    public String getTenHinhThuc() {
        return tenHinhThuc;
    }

    public void setTenHinhThuc(String tenHinhThuc) {
        this.tenHinhThuc = tenHinhThuc;
    }

    @Override
    public String toString() {
        return "ParkingMode [maHinhThuc=" + maHinhThuc + ", tenHinhThuc=" + tenHinhThuc + "]";
    }

}
