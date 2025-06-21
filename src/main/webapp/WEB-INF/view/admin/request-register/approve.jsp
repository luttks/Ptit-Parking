<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quản Lý Yêu Cầu - Duyệt Yêu Cầu</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Quản Lý Yêu Cầu</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item active">Duyệt Yêu Cầu</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Duyệt yêu cầu cho mã đăng ký ${registration.maDangKy.trim()}</h3>
                                <hr />
                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger" role="alert">
                                        <c:out value="${errorMessage}"/>
                                    </div>
                                </c:if>
                                <form method="post" action="${pageContext.request.contextPath}/admin/request/approve" id="approveForm">
                                    <sec:csrfInput/>
                                    <input type="hidden" name="maDangKy" value="${registration.maDangKy.trim()}" />
                                    <div class="mb-3">
                                        <label class="form-label">Mã Đăng Ký:</label>
                                        <input type="text" class="form-control" value="${registration.maDangKy.trim()}" readonly />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Mã Sinh Viên:</label>
                                        <input type="text" class="form-control" value="${registration.bienSoXe.maSV != null ? registration.bienSoXe.maSV.maSV : 'N/A'}" readonly />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Biển Số Xe:</label>
                                        <input type="text" class="form-control" value="${registration.bienSoXe.bienSoXe}" readonly />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Giá Tiền (VNĐ):</label>
                                        <input type="text" class="form-control" value="<fmt:formatNumber value='${registration.bangGia.gia != null ? registration.bangGia.gia : 0}' pattern='#,###'/>" readonly />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ngày Đăng Ký:</label>
                                        <input type="text" class="form-control" value="<fmt:formatDate value='${registration.ngayDangKyAsDate}' pattern='dd/MM/yyyy'/>" readonly />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ngày Bắt Đầu:</label>
                                        <input type="text" class="form-control" value="<fmt:formatDate value='${registration.ngayBatDauAsDate}' pattern='dd/MM/yyyy'/>" readonly />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ngày Kết Thúc:</label>
                                        <input type="text" class="form-control" value="<fmt:formatDate value='${registration.ngayKetThucAsDate}' pattern='dd/MM/yyyy'/>" readonly />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ghi Chú (Tùy Chọn):</label>
                                        <textarea class="form-control" name="ghiChu" rows="3"></textarea>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary">Duyệt</button>
                                        <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">Từ Chối</button>
                                    </div>
                                </form>
                                <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="rejectModalLabel">Từ Chối Yêu Cầu</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form action="${pageContext.request.contextPath}/admin/request/reject" method="post">
                                                    <sec:csrfInput/>
                                                    <input type="hidden" name="maDangKy" value="${registration.maDangKy.trim()}"/>
                                                    <div class="mb-3">
                                                        <label for="ghiChu" class="form-label">Lý Do Từ Chối</label>
                                                        <textarea class="form-control" id="ghiChu" name="ghiChu" rows="3" required></textarea>
                                                        <div class="invalid-feedback">Vui lòng nhập lý do từ chối.</div>
                                                    </div>
                                                    <button type="submit" class="btn btn-danger">Xác Nhận Từ Chối</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        document.getElementById('approveForm').addEventListener('submit', function(event) {
            // No strict validation needed since note is optional
        });
    </script>
</body>
</html>