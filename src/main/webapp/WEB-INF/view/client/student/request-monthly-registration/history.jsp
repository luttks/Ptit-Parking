<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Lịch Sử Đăng Ký Tháng</title>
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
           min-height: 100vh;
           display: flex;
           flex-direction: column;
       }
       .main-content {
           flex: 1;
           width: 100%;
           max-width: 1500px;
           margin: 0 auto;
           padding: 2rem;
           display: flex;
           align-items: flex-start;
           justify-content: center;
           position: relative;
       }
       .card {
           border: none;
           border-radius: 12px;
           box-shadow: 0 10px 30px rgba(67, 97, 238, 0.15);
           overflow: hidden;
           width: 100%;
           max-width: 1200px;
           background-color: #ffffff;
           margin-bottom: 2rem;
       }
       .card-header {
           background: linear-gradient(135deg, #4361ee, #3f37c9);
           color: white;
           padding: 2rem;
           text-align: center;
           border-bottom: none;
       }
       .card-header h1 {
           font-weight: 700;
           text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
           margin: 0;
           font-size: 2rem;
           color: white;
           display: flex;
           align-items: center;
           justify-content: center;
           gap: 0.75rem;
       }
       .card-header h1 i {
           font-size: 1.75rem;
       }
       .card-header h1 span {
           position: relative;
           display: inline-block;
       }
       .card-header h1 span::after {
           content: '';
           position: absolute;
           bottom: -4px;
           left: 0;
           width: 100%;
           height: 2px;
           background-color: rgba(255, 255, 255, 0.5);
           transform: scaleX(0);
           transition: transform 0.3s ease;
       }
       .card-header:hover h1 span::after {
           transform: scaleX(1);
       }
       .card-body {
           padding: 1.5rem;
           background-color: #ffffff;
           max-height: calc(100vh - 250px);
           overflow-y: auto;
       }
       .table-responsive {
           margin: -0.5rem -1.5rem;
           padding: 0.5rem 1.5rem;
           overflow-x: auto;
       }
       .table {
           margin-bottom: 0;
           background-color: #ffffff;
           border-collapse: separate;
           border-spacing: 0;
           width: 100%;
           min-width: 800px;
       }
       .table thead th {
           background-color: #f8f9fa;
           color: #2b2d42;
           font-weight: 600;
           padding: 1rem;
           border-bottom: 2px solid #e2e8f0;
           text-transform: uppercase;
           font-size: 0.75rem;
           letter-spacing: 0.5px;
           white-space: nowrap;
           position: sticky;
           top: 0;
           z-index: 1;
           background-clip: padding-box;
       }
       .table tbody td {
           padding: 1rem;
           vertical-align: middle;
           border-bottom: 1px solid #e2e8f0;
           color: #2b2d42;
           font-size: 0.875rem;
       }
       .table tbody tr:last-child td {
           border-bottom: none;
       }
       .table tbody tr:hover {
           background-color: rgba(67, 97, 238, 0.05);
       }
       .btn {
           border-radius: 6px;
           padding: 0.5rem 1rem;
           font-weight: 600;
           transition: all 0.2s ease;
           font-size: 0.875rem;
           letter-spacing: 0.3px;
           display: inline-flex;
           align-items: center;
           justify-content: center;
           gap: 0.5rem;
           min-width: 100px;
       }
       .btn i {
           font-size: 0.875rem;
       }
       .btn-primary {
           background: linear-gradient(135deg, #4361ee, #3f37c9);
           border: none;
           color: #ffffff;
       }
       .btn-primary:hover {
           transform: translateY(-1px);
           box-shadow: 0 4px 12px rgba(67, 97, 238, 0.3);
       }
       .btn-primary:active {
           transform: translateY(0);
       }
       .alert {
           border-radius: 8px;
           padding: 1rem 1.25rem;
           margin-bottom: 1.5rem;
           border: none;
           font-weight: 500;
       }
       .alert-success {
           background-color: rgba(76, 201, 240, 0.1);
           border-left: 4px solid #4cc9f0;
           color: #2b2d42;
       }
       .alert-danger {
           background-color: rgba(247, 37, 133, 0.1);
           border-left: 4px solid #f72585;
           color: #2b2d42;
       }
       .status-badge {
           padding: 0.35rem 0.75rem;
           border-radius: 20px;
           font-size: 0.75rem;
           font-weight: 600;
           display: inline-block;
       }
       .status-pending {
           background-color: rgba(247, 37, 133, 0.1);
           color: #f72585;
       }
       .status-approved {
           background-color: rgba(76, 201, 240, 0.1);
           color: #4cc9f0;
       }
       h1 {
           font-weight: 700;
           color: var(--primary-color);
           margin-bottom: 1.5rem;
           font-size: 1.8rem;
       }
       table {
           width: 100%;
           border-collapse: collapse;
       }
       th, td {
           padding: 1rem;
           text-align: left;
           border-bottom: 1px solid #dee2e6;
       }
       th {
           background-color: #f8f9fa;
           font-weight: 600;
       }
       tr:hover {
           background-color: #e9ecef;
       }
       .btn-edit, .btn-delete, .btn-view {
           border: none;
           border-radius: 8px;
           padding: 0.5rem 1rem;
           color: white;
           text-decoration: none;
           transition: all 0.3s ease;
           margin-right: 0.5rem;
       }
       .btn-edit {
           background-color: var(--accent-color);
       }
       .btn-delete {
           background-color: var(--danger-color);
       }
       .btn-view {
           background-color: var(--success-color);
       }
       .btn-edit:hover, .btn-delete:hover, .btn-view:hover {
           transform: translateY(-2px);
           box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
       }
       @media (max-width: 768px) {
           .main-content {
               padding: 1rem;
           }
           .card-header {
               padding: 1.25rem;
           }
           .card-header h1 {
               font-size: 1.5rem;
           }
           .card-body {
               padding: 1rem;
           }
           .btn {
               padding: 0.4rem 0.8rem;
               font-size: 0.8125rem;
               min-width: 90px;
           }
       }
   </style>
</head>
<body>
   <jsp:include page="../../layout/header.jsp"/>
   <div class="main-content">
       <div class="card shadow-sm">
           <div class="card-header">
               <h1><i class="fas fa-history"></i><span>Lịch Sử Đăng Ký Tháng</span></h1>
           </div>
           <div class="card-body">
               <c:if test="${not empty successMessage}">
                   <div class="alert alert-success alert-dismissible fade show" role="alert">
                       <i class="fas fa-check-circle me-2"></i>
                       <c:out value="${successMessage}"/>
                       <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                   </div>
               </c:if>
               <c:if test="${not empty errorMessage}">
                   <div class="alert alert-danger alert-dismissible fade show" role="alert">
                       <i class="fas fa-exclamation-circle me-2"></i>
                       <c:out value="${errorMessage}"/>
                       <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                   </div>
               </c:if>
               <table class="table">
                   <thead>
                       <tr>
                           <th>Mã Đăng Ký</th>
                           <th>Biển Số Xe</th>
                           <th>Ngày Bắt Đầu</th>
                           <th>Ngày Hết Hạn</th>
                           <th>Số Tháng</th>
                           <th>Giá (VNĐ)</th>
                           <th>Trạng Thái</th>
                           <th>Ghi Chú</th>
                           <th>Thao Tác</th>
                       </tr>
                   </thead>
                   <tbody>
                       <c:forEach var="registration" items="${registrations}">
                           <tr>
                               <td><c:out value="${registration.maDangKy.trim()}"/></td>
                               <td><c:out value="${registration.bienSoXe.bienSoXe}"/></td>
                               <td><fmt:formatDate value="${registration.ngayBatDauAsDate}" pattern="dd/MM/yyyy"/></td>
                               <td><fmt:formatDate value="${registration.ngayKetThucAsDate}" pattern="dd/MM/yyyy"/></td>
                               <td><c:out value="${registration.ngayKetThuc.getMonthValue() - registration.ngayBatDau.getMonthValue()}"/></td>
                               <td><fmt:formatNumber value="${registration.gia}" pattern="#,###"/></td>
                               <td><c:out value="${registration.trangThai}"/></td>
                               <td><c:out value="${registration.ghiChu != null ? registration.ghiChu : 'N/A'}"/></td>
                               <td>
                                   <c:choose>
                                       <c:when test="${registration.trangThai == 'Chờ duyệt'}">
                                           <a href="${pageContext.request.contextPath}/student/request-monthly-registration/edit?maDangKy=${registration.maDangKy.trim()}" class="btn-edit">Chỉnh Sửa</a>
                                           <a href="${pageContext.request.contextPath}/student/request-monthly-registration/delete?maDangKy=${registration.maDangKy.trim()}" class="btn-delete" onclick="return confirm('Bạn có chắc muốn xóa yêu cầu này?')">Xóa</a>
                                       </c:when>
                                       <c:otherwise>
                                           <a href="${pageContext.request.contextPath}/student/request-monthly-registration/view?maDangKy=${registration.maDangKy.trim()}" class="btn-view">Xem</a>
                                       </c:otherwise>
                                   </c:choose>
                               </td>
                           </tr>
                       </c:forEach>
                       <c:if test="${empty registrations}">
                           <tr>
                               <td colspan="9" class="text-center">Không tìm thấy đăng ký nào.</td>
                           </tr>
                       </c:if>
                   </tbody>
               </table>
           </div>
       </div>
   </div>
   <jsp:include page="../../layout/footer.jsp"/>
   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>