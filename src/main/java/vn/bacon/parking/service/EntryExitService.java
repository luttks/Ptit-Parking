package vn.bacon.parking.service;

import java.time.LocalDateTime;
import java.time.LocalDate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.bacon.parking.domain.ParkingLot;
import vn.bacon.parking.domain.EntryExitDetail;
import vn.bacon.parking.domain.ParkingMode;
import vn.bacon.parking.domain.Price;
import vn.bacon.parking.domain.RegisterMonth;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.domain.Vehicle;
import vn.bacon.parking.repository.ParkingLotRepository;
import vn.bacon.parking.repository.EntryExitDetailRepository;
import vn.bacon.parking.repository.ParkingModeRepository;
import vn.bacon.parking.repository.PriceRepository;
import vn.bacon.parking.repository.RegisterMonthRepository;
import vn.bacon.parking.repository.StaffRepository;
import vn.bacon.parking.repository.VehicleRepository;

@Service
public class EntryExitService {

    private static final Logger logger = LoggerFactory.getLogger(EntryExitService.class);

    private final VehicleRepository vehicleRepository;
    private final StaffRepository staffRepository;
    private final RegisterMonthRepository registerMonthRepository;
    private final PriceRepository priceRepository;
    private final ParkingModeRepository parkingModeRepository;
    private final EntryExitDetailRepository entryExitDetailRepository;
    private final ParkingLotRepository parkingLotRepository;
    private final RegisterMonthService registerMonthService;

    public EntryExitService(
            VehicleRepository vehicleRepository,
            StaffRepository staffRepository,
            RegisterMonthRepository registerMonthRepository,
            PriceRepository priceRepository,
            ParkingModeRepository parkingModeRepository,
            EntryExitDetailRepository entryExitDetailRepository,
            ParkingLotRepository parkingLotRepository,
            RegisterMonthService registerMonthService) {
        this.vehicleRepository = vehicleRepository;
        this.staffRepository = staffRepository;
        this.registerMonthRepository = registerMonthRepository;
        this.priceRepository = priceRepository;
        this.parkingModeRepository = parkingModeRepository;
        this.entryExitDetailRepository = entryExitDetailRepository;
        this.parkingLotRepository = parkingLotRepository;
        this.registerMonthService = registerMonthService;
    }

    @Transactional
    public EntryExitDetail processVehicleEntry(String bienSoXe, String maNVVao) throws Exception {
        logger.debug("Processing vehicle entry: bienSoXe={}, maNVVao={}", bienSoXe, maNVVao);

        Vehicle vehicle = vehicleRepository.findById(bienSoXe)
                .orElseThrow(
                        () -> new Exception("Xe với biển số " + bienSoXe + " chưa được đăng ký. Vui lòng đăng ký."));

        // Check if vehicle is already in the parking lot
        if (entryExitDetailRepository.existsByBienSoXeAndTgRaIsNull(vehicle)) {
            throw new Exception("Xe với biển số " + bienSoXe + " đã ở trong bãi, không thể vào lại.");
        }

        Staff nvVao = staffRepository.findById(maNVVao)
                .orElseThrow(() -> new Exception("Nhân viên " + maNVVao + " không tồn tại."));

        // Find parking lot based on vehicle type
        String maLoaiXe = vehicle.getMaLoaiXe().getMaLoaiXe();
        ParkingLot parkingLot = parkingLotRepository.findByVehicleType_MaLoaiXe(maLoaiXe);
        if (parkingLot == null) {
            throw new Exception("Không tìm thấy bãi đỗ cho loại xe " + vehicle.getMaLoaiXe().getTenLoaiXe());
        }

        // Check if parking lot has available spaces
        if (parkingLot.getAvailableSpaces() <= 0) {
            throw new Exception("Bãi đỗ " + parkingLot.getParkingLotName() + " đã hết chỗ.");
        }

        // Decrement available spaces in the parking lot
        parkingLot.setAvailableSpaces(parkingLot.getAvailableSpaces() - 1);
        parkingLotRepository.save(parkingLot);

        boolean isLecturer = false;
        if (vehicle.getMaNV() != null) {
            Staff owner = staffRepository.findById(vehicle.getMaNV().getMaNV()).orElse(null);
            if (owner != null && "Giảng viên".equals(owner.getChucVu())) {
                isLecturer = true;
            }
        }

        EntryExitDetail entry = new EntryExitDetail();
        entry.setBienSoXe(vehicle);
        LocalDateTime tgVao = LocalDateTime.now();
        entry.setTgVao(tgVao);
        entry.setNvVao(nvVao);
        logger.debug("Set tgVao to: {}", tgVao);

        ParkingMode parkingMode;
        Integer gia;

        if (isLecturer) {
            parkingMode = parkingModeRepository.findById("HT001")
                    .orElseThrow(() -> new Exception("Hình thức gửi HT001 không tồn tại."));
            gia = 0;
        } else if (registerMonthService.hasValidApprovedMonthlyRegistration(bienSoXe)) {
            parkingMode = parkingModeRepository.findById("HT002")
                    .orElseThrow(() -> new Exception("Hình thức gửi tháng HT002 không tồn tại."));
            gia = 0;
        } else {
            parkingMode = parkingModeRepository.findById("HT001")
                    .orElseThrow(() -> new Exception("Hình thức gửi HT001 không tồn tại."));
            Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(parkingMode, vehicle.getMaLoaiXe());
            if (price == null) {
                throw new Exception("Không tìm thấy giá cho hình thức " + parkingMode.getTenHinhThuc()
                        + " và loại xe " + vehicle.getMaLoaiXe().getTenLoaiXe());
            }
            gia = price.getGia();
        }

        entry.setHinhThuc(parkingMode);
        entry.setGia(gia);

        if (entry.getTgVao() == null) {
            logger.error("tgVao is null before saving entry: {}", entry);
            throw new IllegalStateException("tgVao cannot be null");
        }
        EntryExitDetail savedEntry = entryExitDetailRepository.save(entry);
        logger.debug("Saved entry: {}", savedEntry);
        return savedEntry;
    }

    @Transactional
    public EntryExitDetail processVehicleExit(Integer maCTVaoRa, String maNVRa) throws Exception {
        logger.debug("Processing vehicle exit: maCTVaoRa={}, maNVRa={}", maCTVaoRa, maNVRa);

        EntryExitDetail entry = entryExitDetailRepository.findById(maCTVaoRa)
                .orElseThrow(() -> new Exception("Không tìm thấy bản ghi với mã " + maCTVaoRa));

        if (entry.getTgRa() != null) {
            throw new Exception("Xe đã được ghi nhận ra vào " + entry.getTgRaFormatted());
        }

        Staff nvRa = staffRepository.findById(maNVRa)
                .orElseThrow(() -> new Exception("Nhân viên " + maNVRa + " không tồn tại."));

        // Find parking lot based on vehicle type
        Vehicle vehicle = entry.getBienSoXe();
        if (vehicle == null) {
            throw new Exception("Biển số xe không hợp lệ cho bản ghi " + maCTVaoRa);
        }
        String maLoaiXe = vehicle.getMaLoaiXe().getMaLoaiXe();
        ParkingLot parkingLot = parkingLotRepository.findByVehicleType_MaLoaiXe(maLoaiXe);
        if (parkingLot == null) {
            throw new Exception("Không tìm thấy bãi đỗ cho loại xe " + vehicle.getMaLoaiXe().getTenLoaiXe());
        }

        // Increment available spaces in the parking lot
        parkingLot.setAvailableSpaces(parkingLot.getAvailableSpaces() + 1);
        parkingLotRepository.save(parkingLot);

        entry.setTgRa(LocalDateTime.now());
        entry.setNvRa(nvRa);
        logger.debug("Set tgRa to: {}", entry.getTgRa());

        boolean isLecturer = false;
        if (vehicle.getMaNV() != null) {
            Staff owner = staffRepository.findById(vehicle.getMaNV().getMaNV()).orElse(null);
            if (owner != null && "Giảng viên".equals(owner.getChucVu())) {
                isLecturer = true;
            }
        }

        Integer gia;
        if (isLecturer) {
            gia = 0;
        } else if (registerMonthService.hasValidApprovedMonthlyRegistration(vehicle.getBienSoXe())) {
            gia = 0;
        } else {
            ParkingMode parkingMode = entry.getHinhThuc();
            if (!"HT001".equals(parkingMode.getMaHinhThuc())) {
                parkingMode = parkingModeRepository.findById("HT001")
                        .orElseThrow(() -> new Exception("Hình thức gửi HT001 không tồn tại."));
                entry.setHinhThuc(parkingMode);
            }
            Price price = priceRepository.findByMaHinhThucAndMaLoaiXe(parkingMode, vehicle.getMaLoaiXe());
            if (price == null) {
                throw new Exception("Không tìm thấy giá cho hình thức " + parkingMode.getTenHinhThuc()
                        + " và loại xe " + vehicle.getMaLoaiXe().getTenLoaiXe());
            }
            gia = price.getGia();
        }

        entry.setGia(gia);

        EntryExitDetail savedEntry = entryExitDetailRepository.save(entry);
        logger.debug("Saved exit entry: {}", savedEntry);
        return savedEntry;
    }

    public Page<EntryExitDetail> getAllEntries(Pageable pageable) {
        Page<EntryExitDetail> page = entryExitDetailRepository.findAll(pageable);
        logger.debug("Fetched {} entries for page: {}", page.getContent().size(), pageable);
        return page;
    }

    public Page<EntryExitDetail> getEntriesNotExited(Pageable pageable) {
        Page<EntryExitDetail> page = entryExitDetailRepository.findByTgRaIsNullAndNvRaIsNull(pageable);
        logger.debug("Fetched {} entries not exited for page: {}", page.getContent().size(), pageable);
        return page;
    }
}