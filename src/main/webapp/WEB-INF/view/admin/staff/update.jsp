<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Update Staff - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        #avatarPreview {
            display: none;
            max-width: 150px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .avatar-current {
            max-width: 100px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .text-danger {
            font-size: 0.875em;
            color: #dc3545;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(document).ready(() => {
            const avatarFile = $("#avatarFile");
            const avatarPreview = $("#avatarPreview");

            avatarFile.change(function (e) {
                const file = e.target.files[0];
                if (file && file.type.startsWith('image/')) {
                    const imgURL = URL.createObjectURL(file);
                    avatarPreview.attr("src", imgURL).css({"display": "block"});
                    avatarPreview.on('load', () => {
                        URL.revokeObjectURL(imgURL);
                    });
                } else {
                    avatarPreview.css({"display": "none"}).attr("src", "");
                    alert("Vui lòng chọn một file hình ảnh hợp lệ!");
                }
            });
        });
    </script>
</head>
<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Quản lý nhân viên</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/staff">Staff</a></li>
                        <li class="breadcrumb-item active">Update</li>
                    </ol>
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-md-6 col-12 mx-auto">
                                <h3>Cập nhật nhân viên</h3>
                                <hr />
                                <form:form method="post" action="/admin/staff/update" modelAttribute="newStaff" enctype="multipart/form-data">
                                    <div class="mb-3">
                                        <label class="form-label">Avatar hiện tại:</label>
                                        <c:if test="${not empty newStaff.avatar}">
                                            <img src="/images/avatars/${newStaff.avatar}" alt="Avatar" class="avatar-current" />
                                        </c:if>
                                        <c:if test="${empty newStaff.avatar}">
                                            <p>Chưa có avatar</p>
                                        </c:if>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Mã NV:</label>
                                        <form:input type="text" class="form-control" path="maNV" readonly="true" />
                                        <form:errors path="maNV" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Họ tên:</label>
                                        <form:input type="text" class="form-control" path="hoTen" />
                                        <form:errors path="hoTen" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">SĐT:</label>
                                        <form:input type="text" class="form-control" path="sdt" />
                                        <form:errors path="sdt" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Email:</label>
                                        <form:input type="email" class="form-control" path="email" />
                                        <form:errors path="email" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">CCCD:</label>
                                        <form:input type="text" class="form-control" path="cccd" />
                                        <form:errors path="cccd" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Chức vụ:</label>
                                        <form:select path="chucVu" class="form-control">
                                            <form:option value="" label="-- Chọn chức vụ --" />
                                            <form:option value="Bảo vệ" label="Bảo vệ" />
                                            <form:option value="Quản lý" label="Quản lý" />
                                            <form:option value="Giảng viên" label="Giảng viên" />
                                        </form:select>
                                        <form:errors path="chucVu" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ngày vào làm hiện tại:</label>
                                        <p>
                                            <c:if test="${not empty newStaff.ngayVaoLam}">
                                                ${newStaff.ngayVaoLam}
                                            </c:if>
                                            <c:if test="${empty newStaff.ngayVaoLam}">
                                                Chưa có ngày vào làm
                                            </c:if>
                                        </p>
                                        <label class="form-label">Ngày vào làm mới:</label>
                                        <form:input type="date" class="form-control" path="ngayVaoLam" />
                                        <form:errors path="ngayVaoLam" cssClass="text-danger" />
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Upload Avatar mới:</label>
                                        <input type="file" class="form-control" id="avatarFile" name="avatarFile" accept="image/*" />
                                        <img id="avatarPreview" alt="Avatar Preview" />
                                        <form:errors path="avatar" cssClass="text-danger" />
                                    </div>
                                    <button type="submit" class="btn btn-warning">Cập nhật</button>
                                    <a href="/admin/staff" class="btn btn-secondary">Hủy</a>
                                </form:form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
</body>
</html>