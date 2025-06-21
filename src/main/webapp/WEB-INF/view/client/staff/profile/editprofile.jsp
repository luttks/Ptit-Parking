<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thông tin cá nhân - PTIT Parking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <style>
        .profile-image {
            width: 160px;
            height: 160px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #e0e7ff;
            transition: transform 0.3s ease;
        }
        .profile-image:hover {
            transform: scale(1.05);
        }
        .form-label {
            font-weight: 600;
            color: #1a2d4e;
            margin-bottom: 0.5rem;
        }
        .error-message {
            color: #dc3545;
            font-size: 0.85rem;
            margin-top: 0.3rem;
        }
        .form-control {
            border-radius: 8px;
            padding: 0.75rem;
            transition: border-color 0.3s ease;
        }
        .form-control:focus {
            border-color: #3b5998;
            box-shadow: 0 0 0 0.2rem rgba(59, 89, 152, 0.25);
        }
        .card {
            border-radius: 12px;
            overflow: hidden;
        }
        #avatarPreview {
            display: none;
            max-width: 150px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
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
<body>
    <jsp:include page="../../layout/header.jsp"/>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-5">
                        <h3 class="card-title text-center mb-4 text-primary fw-bold">Chỉnh sửa thông tin cá nhân</h3>
                        <form:form action="/staff/profile/edit" method="post" modelAttribute="staff" enctype="multipart/form-data">
                            <form:hidden path="maNV"/>
                            <form:hidden path="hoTen"/>
                            <form:hidden path="ngayVaoLam"/>
                            <form:hidden path="chucVu"/>
                            <div class="text-center mb-4">
                                <c:if test="${not empty staff.avatar}">
                                    <img src="/images/avatars/${staff.avatar}" alt="Staff Avatar" class="profile-image mb-3 rounded-circle">
                                </c:if>
                                <c:if test="${empty staff.avatar}">
                                    <img src="/images/default-avatar.png" alt="Staff Avatar" class="profile-image mb-3 rounded-circle">
                                </c:if>
                                <div class="mb-3">
                                    <label for="avatarFile" class="form-label">Thay đổi ảnh đại diện</label>
                                    <input type="file" class="form-control" id="avatarFile" name="avatarFile" accept="image/*">
                                    <img id="avatarPreview" alt="Avatar Preview"/>
                                    <form:errors path="avatar" cssClass="error-message"/>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mã nhân viên</label>
                                <input type="text" class="form-control" value="${staff.maNV}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" value="${staff.hoTen}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Ngày vào làm</label>
                                <input type="text" class="form-control" value="${formattedNgayVaoLam}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Chức vụ</label>
                                <input type="text" class="form-control" value="${staff.chucVu}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <form:input path="sdt" class="form-control" required="required"/>
                                <form:errors path="sdt" cssClass="error-message"/>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <form:input path="email" class="form-control" type="email" required="required"/>
                                <form:errors path="email" cssClass="error-message"/>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">CCCD</label>
                                <form:input path="cccd" class="form-control" required="required"/>
                                <form:errors path="cccd" cssClass="error-message"/>
                            </div>
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                                <a href="/staff/profile" class="btn btn-secondary me-2">
                                    <i class="fas fa-times me-2"></i>Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Lưu thay đổi
                                </button>
                            </div>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="../../layout/footer.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>