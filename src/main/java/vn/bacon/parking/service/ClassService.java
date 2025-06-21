package vn.bacon.parking.service;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import vn.bacon.parking.domain.Class;
import vn.bacon.parking.repository.ClassRepository;

@Service
public class ClassService {
    private final ClassRepository classRepository;

    public ClassService(ClassRepository classRepository) {
        this.classRepository = classRepository;
    }

    public List<Class> getAllClasses() {
        return classRepository.findAll(Sort.by("maLop").descending());
    }

    public Optional<Class> getClassById(String maLop) {
        return classRepository.findById(maLop);
    }

    public void deleteClassById(String maLop) {
        classRepository.deleteById(maLop);
    }

    public Page<Class> getClassPage(Pageable pageable) {
        Pageable sortedByMaLopDesc = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(),
                Sort.by("maLop").descending());
        return classRepository.findAll(sortedByMaLopDesc);
    }

    public Class saveClass(Class classObj) {
        return classRepository.save(classObj);
    }

    public boolean existsByTenLop(String tenLop) {
        return classRepository.existsByTenLop(tenLop);
    }

    public boolean existsByTenLopAndNotMaLop(String tenLop, String maLop) {
        return classRepository.existsByTenLopAndMaLopNot(tenLop, maLop);
    }
}