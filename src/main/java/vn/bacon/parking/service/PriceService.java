package vn.bacon.parking.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.domain.VehicleType;
import vn.bacon.parking.repository.PriceRepository;

@Service
public class PriceService {

    private final PriceRepository priceRepository;

    public PriceService(PriceRepository priceRepository) {
        this.priceRepository = priceRepository;
    }

    // Lấy danh sách tất cả Bảng Giá
    public List<Price> findAll() {
        return this.priceRepository.findAll();
    }

    // Tìm Bảng Giá theo mã
    public Optional<Price> findById(String maBangGia) {
        return this.priceRepository.findById(maBangGia);
    }

    // Thêm hoặc cập nhật Bảng Giá
    public Price save(Price bangGia) {
        return this.priceRepository.save(bangGia);
    }

    // Xóa Bảng Giá theo mã
    public void deleteById(String maBangGia) {
        this.priceRepository.deleteById(maBangGia);
    }

    // Lấy danh sách Bảng Giá có phân trang
    public Page<Price> getBangGiaPage(Pageable pageable) {
        return this.priceRepository.findAll(pageable);
    }

    // Thêm hoặc cập nhật Bảng Giá
    public Price savePrice(Price price) {
        // Bỏ qua kiểm tra trùng lặp mã bảng giá ở đây vì JpaRepository.save() sẽ xử lý
        // đúng cho cả thêm mới và cập nhật.

        // Kiểm tra trùng lặp cặp loại xe và hình thức
        // Khi cập nhật, cần đảm bảo rằng không có bảng giá khác có cùng cặp loại xe và
        // hình thức.
        // Price existingPriceByCombination =
        // priceRepository.findByMaHinhThucAndMaLoaiXe(price.getMaHinhThuc(),
        // price.getMaLoaiXe());

        // if (existingPriceByCombination != null) {
        // // Nếu tìm thấy một bảng giá với cùng cặp loại xe và hình thức,
        // // và đó không phải là bảng giá đang được cập nhật (khác mã bảng giá),
        // // thì đó là một trùng lặp.

        // if (!existingPriceByCombination.getMaBangGia().equals(price.getMaBangGia()))
        // {
        // throw new IllegalArgumentException("Đã tồn tại bảng giá cho loại xe và hình
        // thức này");
        // }
        // }

        return priceRepository.save(price);
    }

    // Xóa Bảng Giá theo mã
    public void deletePrice(String maBangGia) {
        priceRepository.deleteById(maBangGia);
    }

    public boolean existsById(String maBangGia) {
        return priceRepository.existsById(maBangGia);
    }

    public boolean existsByMaLoaiXeAndMaHinhThuc(VehicleType maLoaiXe, ParkingMode maHinhThuc) {
        return priceRepository.existsByMaLoaiXeAndMaHinhThuc(maLoaiXe, maHinhThuc);
    }
}
