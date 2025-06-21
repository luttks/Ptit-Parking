<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Xem Đăng Ký Tháng</title>
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
           max-width: 1000px;
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
           font-weight: 600;
           color: #495057;
           margin-bottom: 0.5rem;
       }
       .form-control {
           border: 1px solid #ced4da;
           border-radius: 8px;
           padding: 0.75rem 1rem;
       }
       .btn-primary {
           background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
           border: none;
           border-radius: 8px;
           padding: 0.75rem 1.5rem;
           font-weight: 600;
           letter-spacing: 0.5px;
           transition: all 0.3s ease;
       }
       .btn-primary:hover {
           transform: translateY(-2px);
           box-shadow: 0 5px 15px rgba(67, 97, 238, 0.3);
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
               <h1 class="mb-0"><i class="fas fa-eye me-2"></i>Xem Đăng Ký Tháng</h1>
           </div>
           <div class="card-body">
               <div class="mb-4">
                   <label class="form-label"><i class="fas fa-id-card me-2"></i>Mã Đăng Ký</label>
                   <input type="text" class="form-control" value="${registration.maDangKy}" readonly>
               </div>
               <div class="mb-4">
                   <label class="form-label"><i class="fas fa-motorcycle me-2"></i>Biển Số Xe</label>
                   <input type="text" class="form-control" value="${registration.bienSoXe.bienSoXe}" readonly>
               </div>
               <div class="mb-4">
                   <label class="form-label"><i class="fas fa-calendar-check me-2"></i>Số Tháng</label>
                   <input type="text" class="form-control" value="${registration.ngayKetThuc.getMonthValue() - registration.ngayBatDau.getMonthValue()}" readonly>
               </div>
               <div class="mb-4">
                   <label class="form-label"><i class="fas fa-money-bill me-2"></i>Giá Tiền (VNĐ)</label>
                   <input type="text" class="form-control" value="<fmt:formatNumber value='${registration.gia}' pattern='#,###'/>" readonly>
               </div>
               <div class="mb-4">
                   <label class="form-label"><i class="far fa-calendar-alt me-2"></i>Ngày Bắt Đầu</label>
                   <input type="text" class="form-control" value="<fmt:formatDate value='${registration.ngayBatDauAsDate}' pattern='dd/MM/yyyy'/>" readonly>
               </div>
               <div class="mb-4">
                   <label class="form-label"><i class="far fa-calendar-alt me-2"></i>Ngày Hết Hạn</label>
                   <input type="text" class="form-control" value="<fmt:formatDate value='${registration.ngayKetThucAsDate}' pattern='dd/MM/yyyy'/>" readonly>
               </div>
               <div class="mb-4">
                   <label class="form-label"><i class="fas fa-info-circle me-2"></i>Trạng Thái</label>
                   <input type="text" class="form-control" value="${registration.trangThai}" readonly>
               </div>
               <div class="mb-4">
                   <label class="form-label"><i class="fas fa-sticky-note me-2"></i>Ghi Chú</label>
                   <input type="text" class="form-control" value="${registration.ghiChu != null ? registration.ghiChu : 'N/A'}" readonly>
               </div>
               <div class="d-grid mt-4">
                   <a href="${pageContext.request.contextPath}/student/request-history" class="btn btn-primary btn-lg">
                       <i class="fas fa-arrow-left me-2"></i>Quay Lại
                   </a>
               </div>
           </div>
       </div>
   </div>
   <jsp:include page="../../layout/footer.jsp"/>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>