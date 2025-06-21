package vn.bacon.parking.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "LoaiXe")
public class VehicleType {
    @Id
    @Column(name = "MaLoaiXe", length = 10, columnDefinition = "nchar(10)")
    private String maLoaiXe;

    @Column(name = "TenLoaiXe", nullable = false, length = 50, columnDefinition = "nchar(50)")
    private String tenLoaiXe;

    public String getMaLoaiXe() {
        return maLoaiXe;
    }

    public void setMaLoaiXe(String maLoaiXe) {
        this.maLoaiXe = maLoaiXe;
    }

    public String getTenLoaiXe() {
        return tenLoaiXe;
    }

    public void setTenLoaiXe(String tenLoaiXe) {
        this.tenLoaiXe = tenLoaiXe;
    }

    @Override
    public String toString() {
        return "VehicleType [maLoaiXe=" + maLoaiXe + ", tenLoaiXe=" + tenLoaiXe + "]";
    }

}
