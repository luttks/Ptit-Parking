package vn.bacon.parking.domain;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "ChiTietVaoRa")
public class EntryExitDetail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "MaCTVaoRa")
    private Integer maCTVaoRa;

    @ManyToOne
    @JoinColumn(name = "BienSoXe")
    private Vehicle bienSoXe;

    @Column(name = "TGVao", nullable = false)
    private LocalDateTime tgVao;

    @Column(name = "TGRa")
    private LocalDateTime tgRa;

    @ManyToOne
    @JoinColumn(name = "NVVao", nullable = false)
    private Staff nvVao;

    @ManyToOne
    @JoinColumn(name = "NVRa")
    private Staff nvRa;

    @ManyToOne
    @JoinColumn(name = "HinhThuc", nullable = false)
    private ParkingMode hinhThuc;

    @Column(name = "Gia")
    private Integer gia;

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    // Getters and Setters
    public Integer getMaCTVaoRa() {
        return maCTVaoRa;
    }

    public void setMaCTVaoRa(Integer maCTVaoRa) {
        this.maCTVaoRa = maCTVaoRa;
    }

    public Vehicle getBienSoXe() {
        return bienSoXe;
    }

    public void setBienSoXe(Vehicle bienSoXe) {
        this.bienSoXe = bienSoXe;
    }

    public LocalDateTime getTgVao() {
        return tgVao;
    }

    public void setTgVao(LocalDateTime tgVao) {
        this.tgVao = tgVao;
    }

    public LocalDateTime getTgRa() {
        return tgRa;
    }

    public void setTgRa(LocalDateTime tgRa) {
        this.tgRa = tgRa;
    }

    public Staff getNvVao() {
        return nvVao;
    }

    public void setNvVao(Staff nvVao) {
        this.nvVao = nvVao;
    }

    public Staff getNvRa() {
        return nvRa;
    }

    public void setNvRa(Staff nvRa) {
        this.nvRa = nvRa;
    }

    public ParkingMode getHinhThuc() {
        return hinhThuc;
    }

    public void setHinhThuc(ParkingMode hinhThuc) {
        this.hinhThuc = hinhThuc;
    }

    public Integer getGia() {
        return gia;
    }

    public void setGia(Integer gia) {
        this.gia = gia;
    }

    // Custom getters for formatted dates
    public String getTgVaoFormatted() {
        return tgVao != null ? tgVao.format(FORMATTER) : "";
    }

    public String getTgRaFormatted() {
        return tgRa != null ? tgRa.format(FORMATTER) : "";
    }

    @Override
    public String toString() {
        return "EntryExitDetail [maCTVaoRa=" + maCTVaoRa + ", bienSoXe=" + bienSoXe + ", tgVao=" + tgVao + ", tgRa="
                + tgRa
                + ", nvVao=" + nvVao + ", nvRa=" + nvRa + ", hinhThuc=" + hinhThuc + ", gia=" + gia + "]";
    }
}