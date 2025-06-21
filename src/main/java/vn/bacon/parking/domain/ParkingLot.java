
package vn.bacon.parking.domain;

import jakarta.persistence.*;

@Entity
@Table(name = "BaiDo")
public class ParkingLot {

    @Id
    @Column(name = "MaBaiDo")
    private String maParkingLot;

    @Column(name = "TenBai")
    private String parkingLotName;

    @Column(name = "SoLuongCho")
    private Integer availableSpaces;

    @ManyToOne
    @JoinColumn(name = "MaLoaiXe")
    private VehicleType vehicleType;

    // Getters and Setters
    public String getMaParkingLot() {
        return maParkingLot;
    }

    public void setMaParkingLot(String maParkingLot) {
        this.maParkingLot = maParkingLot;
    }

    public String getParkingLotName() {
        return parkingLotName;
    }

    public void setParkingLotName(String parkingLotName) {
        this.parkingLotName = parkingLotName;
    }

    public Integer getAvailableSpaces() {
        return availableSpaces;
    }

    public void setAvailableSpaces(Integer availableSpaces) {
        this.availableSpaces = availableSpaces;
    }

    public VehicleType getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(VehicleType vehicleType) {
        this.vehicleType = vehicleType;
    }

    @Override
    public String toString() {
        return "ParkingLot [maParkingLot=" + maParkingLot + ", parkingLotName=" + parkingLotName
                + ", availableSpaces=" + availableSpaces + ", vehicleType=" + vehicleType + "]";
    }
}
