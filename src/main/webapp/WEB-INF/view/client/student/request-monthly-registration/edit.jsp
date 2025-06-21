<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Chỉnh Sửa Đăng Ký Tháng</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
   <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   <style>
       :root {
           --primary-color: #4361ee;
           --secondary-color: #3f37c9;
           --accent-color: #4895ef;
           --light-color: #f8f9fa;
           --dark-color: #212529;
           --success-color: #4cc9f0;
           --danger-color: #f72585;
           --warning-color: #f8961e;
       }
       body {
           font-family: 'Inter', sans-serif;
           background-color: #f5f7ff;
           color: #2b2d42;
           line-height: 1.6;
           padding-top: 80px;
           margin: 0;
       }
       .main-content {
           width: 1500px;
           margin: 0 auto;
           padding: 2rem 0;
           display: flex;
           align-items: flex-start;
           justify-content: center;
       }
       .card {
           border: none;
           border-radius: 12px;
           box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
           overflow: hidden;
           width: 100%;
           max-width: 1400px;
       }
       .card-header {
           background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
           color: white;
           padding: 1.5rem;
           border-bottom: none;
       }
       .card-body {
           padding: 2.5rem;
       }
       h1 {
           font-weight: 700;
           color: var(--primary-color);
           margin-bottom: 1.5rem;
           font-size: 1.8rem;
       }
       .form-label {
           font-weight: 500;
       }
       .btn-primary {
           background-color: var(--accent-color);
           border: none;
           border-radius: 8px;
           padding: 0.75rem 1.5rem;
           transition: all 0.3s ease;
       }
       .btn-primary:hover {
           transform: translateY(-2px);
           box-shadow: 0 5px 15px rgba(72, 149, 239, 0.3);
       }
       @media (max-width: 1500px) {
           .main-content {
               width: 100%;
               padding: 1rem;
           }
       }
       @media (max-width: 768px) {
           .card-body {
               padding: 1.5rem;
           }
           h1 {
               font-size: 1.5rem;
           }
       }
   </style>
</head>
<body>
   <jsp:include page="../../layout/header.jsp"/>
   <div class="main-content">
       <div class="card shadow-sm">
           <div class="card-header text-center">
               <h1 class="mb-0"><i class="fas fa-edit me-2"></i>Chỉnh Sửa Đăng Ký Tháng</h1>
           </div>
           <div class="card-body">
               <c:if test="${not empty error}">
                   <div class="alert alert-danger alert-dismissible fade show" role="alert">
                       <i class="fas fa-exclamation-circle me-2"></i>
                       <c:out value="${error}"/>
                       <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                   </div>
               </c:if>
               <form method="post" action="${pageContext.request.contextPath}/student/request-monthly-registration/edit" id="editForm" class="needs-validation" novalidate>
                   <sec:csrfInput/>
                   <input type="hidden" name="maDangKy" value="${registration.maDangKy}"/>
                   <div class="mb-3">
                       <label for="bienSoXe" class="form-label">Biển Số Xe</label>
                       <select name="bienSoXe" class="form-control" id="bienSoXe" required onchange="updatePrice()">
                           <option value="" disabled>Chọn xe</option>
                           <c:forEach var="vehicle" items="${vehicles}">
                               <option value="${vehicle.bienSoXe}" data-maLoaiXe="${vehicle.maLoaiXe.maLoaiXe}" ${vehicle.bienSoXe == registration.bienSoXe.bienSoXe ? 'selected' : ''}>
                                   <c:out value="${vehicle.bienSoXe}"/>
                               </option>
                           </c:forEach>
                       </select>
                       <div class="invalid-feedback">Vui lòng chọn xe.</div>
                   </div>
                   <div class="mb-3">
                       <label for="soThang" class="form-label">Số Tháng</label>
                       <select name="soThang" class="form-control" id="soThang" required onchange="updatePrice()">
                           <option value="" disabled>Chọn số tháng</option>
                           <option value="1" ${soThang == 1 ? 'selected' : ''}>1 Tháng</option>
                           <option value="3" ${soThang == 3 ? 'selected' : ''}>3 Tháng</option>
                           <option value="6" ${soThang == 6 ? 'selected' : ''}>6 Tháng</option>
                       </select>
                       <div class="invalid-feedback">Vui lòng chọn số tháng.</div>
                   </div>
                   <div class="mb-3">
                       <label for="gia" class="form-label">Giá Tiền (VNĐ)</label>
                       <input type="text" id="gia" class="form-control" readonly value="${registration.gia}">
                   </div>
                   <div class="mb-3">
                       <label for="ngayBatDau" class="form-label">Ngày Bắt Đầu</label>
                       <input type="date" name="ngayBatDau" class="form-control" id="ngayBatDau" value="${registration.ngayBatDau}" required min="<%= java.time.LocalDate.now().plusDays(1) %>"/>
                       <div class="invalid-feedback">Vui lòng chọn ngày trong tương lai.</div>
                   </div>
                   <button type="submit" class="btn btn-primary">Cập Nhật</button>
                   <a href="${pageContext.request.contextPath}/student/request-history" class="btn btn-secondary ms-2">Hủy</a>
               </form>
           </div>
       </div>
   </div>
   <jsp:include page="../../layout/footer.jsp"/>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
   <script>
       const priceMap = {
           'LX001': 120000, // Xe Máy, HT002
           'LX002': 400000  // Ô tô, HT002
       };

       function updatePrice() {
           const vehicleSelect = document.getElementById('bienSoXe');
           const soThangSelect = document.getElementById('soThang');
           const giaInput = document.getElementById('gia');
           const selectedVehicle = vehicleSelect.options[vehicleSelect.selectedIndex];
           const soThang = soThangSelect.value;

           if (!selectedVehicle || !selectedVehicle.getAttribute('data-maLoaiXe') || !soThang) {
               console.log('Vehicle or months not selected');
               giaInput.value = 'Đang tính...';
               return;
           }

           const maLoaiXe = selectedVehicle.getAttribute('data-maLoaiXe').trim();
           const pricePerMonth = priceMap[maLoaiXe] || 0;
           const totalPrice = pricePerMonth * parseInt(soThang);

           if (pricePerMonth === 0) {
               console.log('No price found for maLoaiXe:', maLoaiXe);
               giaInput.value = 'Đang tính...';
           } else {
               giaInput.value = totalPrice.toLocaleString('vi-VN');
           }
       }

       document.addEventListener('DOMContentLoaded', updatePrice);

       (function () {
           'use strict';
           const forms = document.querySelectorAll('.needs-validation');
           Array.from(forms).forEach(form => {
               form.addEventListener('submit', event => {
                   if (!form.checkValidity()) {
                       event.preventDefault();
                       event.stopPropagation();
                   }
                   form.classList.add('was-validated');
               }, false);
           });
       })();

       document.getElementById('ngayBatDau').addEventListener('change', function () {
           const selectedDate = new Date(this.value);
           const today = new Date();
           today.setHours(0, 0, 0, 0);
           if (selectedDate <= today) {
               this.setCustomValidity('Vui lòng chọn ngày trong tương lai.');
               this.reportValidity();
               this.value = '';
           } else {
               this.setCustomValidity('');
           }
       });

       document.getElementById('editForm').addEventListener('submit', function(event) {
           const formData = new FormData(this);
           console.log('Form data being submitted:');
           for (const [key, value] of formData.entries()) {
               console.log(`${key}: ${value}`);
           }
           const maDangKy = formData.get('maDangKy');
           if (!maDangKy) {
               event.preventDefault();
               alert('Mã đăng ký không được để trống!');
           }
       });
   </script>
</body>
</html>