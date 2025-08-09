<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap4.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap4.min.js"></script>
    <style>
        .card {
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e3e6f0;
            font-weight: bold;
        }
        .sidebar {
            background-color: #4e73df;
            min-height: 100vh;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 1rem;
        }
        .sidebar .nav-link:hover {
            color: #fff;
            background-color: rgba(255, 255, 255, 0.1);
        }
        .sidebar .nav-link.active {
            color: #fff;
            font-weight: bold;
        }
        .sidebar .fas {
            margin-right: 10px;
        }
        .profile-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #6c757d;
        }
        .stats-card {
            border-left: 4px solid;
        }
        .stats-card.primary {
            border-left-color: #4e73df;
        }
        .stats-card.success {
            border-left-color: #1cc88a;
        }
        .stats-card.info {
            border-left-color: #36b9cc;
        }
        .stats-card.warning {
            border-left-color: #f6c23e;
        }
        .attendance-pill {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
            border-radius: 10px;
        }
        .present {
            background-color: #1cc88a;
            color: white;
        }
        .absent {
            background-color: #e74a3b;
            color: white;
        }
        .leave {
            background-color: #f6c23e;
            color: white;
        }
        
        
        .center-content {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    text-align: center;
		  }
    </style>
</head>
<body>

<div class="container-fluid">
<div class="row">
<div class="col-md-2 sidebar px-0">
                <div class="text-center py-4">
                    <h4 class="text-white">College ERP</h4>
                </div>
                <hr class="sidebar-divider my-0 bg-light">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/teacher/dashboard">
                            <i class="fas fa-fw fa-tachometer-alt"></i>
                            Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/students" id="studentsLink">
                            <i class="fas fa-fw fa-users"></i>
                            Students
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/attendance">
                            <i class="fas fa-fw fa-calendar-check"></i>
                            Attendance
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/marks">
                            <i class="fas fa-fw fa-chart-bar"></i>
                            Marks
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/github">
                            <i class="fas fa-fw fa-calendar-check"></i>
                            Github
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/teacher/profiletracker">
                            <i class="fas fa-fw fa-calendar-check"></i>
                            ProfileTracker
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">
                            <i class="fas fa-fw fa-sign-out-alt"></i>
                            Logout
                        </a>
                    </li>
                </ul>
            </div>


<div class="col-md-10 p-4">
<div class="modal fade " id="profileModal" tabindex="-1" role="dialog" aria-labelledby="profileModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
        
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="profileModalLabel">Edit Profile</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="${pageContext.request.contextPath}/teacher/updateProfile" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="teacherId" value="${teacher.teacherId}">
                        <div class="form-group">
                            <label for="name">Name</label>
                            <input type="text" class="form-control" id="name" name="name" value="${teacher.name}" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="${teacher.email}" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone</label>
                            <input type="text" class="form-control" id="phone" name="phone" value="${teacher.phone}" required>
                        </div>
                        <div class="form-group">
                            <label for="qualification">Qualification</label>
                            <input type="text" class="form-control" id="qualification" name="qualification" value="${teacher.qualification}" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <nav class="navbar navbar-expand navbar-light bg-white mb-4">
                    <div class="container-fluid">
                        <h1 class="h3 mb-0 text-gray-800">Teacher Dashboard</h1>
                        <ul class="navbar-nav ml-auto">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                    data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <span class="mr-2 d-none d-lg-inline text-gray-600 small">${teacher.name}</span>
                                    <div class="profile-img">
                                        <i class="fas fa-user"></i>
                                    </div>
                                </a>
                                <!-- Dropdown - User Information -->
                                <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                    aria-labelledby="userDropdown">
                                    <a class="dropdown-item" href="#" data-toggle="modal" data-target="#profileModal">
                                        <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                        Profile
                                    </a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                        Logout
                                    </a>
                                </div>
                            </li>
                        </ul>
                    </div>
                </nav>
              

    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Students List</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="studentsTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Roll Number</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Department</th>
                            <th>Semester</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${students}" var="student">
                            <tr>
                                <td>${student.rollNumber}</td>
                                <td>${student.name}</td>
                                <td>${student.email}</td>
                                <td>${student.phone}</td>
                                <td>${student.department}</td>
                                <td>${student.semester}</td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-primary btn-sm" 
                                                onclick="viewStudentDetails(${student.studentId})">
                                            <i class="fas fa-eye"></i> View
                                        </button>
                                        <button type="button" class="btn btn-info btn-sm" 
                                                onclick="manageMarks(${student.studentId})">
                                            <i class="fas fa-edit"></i> Marks
                                        </button>
                                        <button type="button" class="btn btn-warning btn-sm" 
                                                onclick="manageAttendance(${student.studentId})">
                                            <i class="fas fa-calendar-check"></i> Attendance
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</div>
</div>
</body>

<script>
$(document).ready(function() {
    $('#studentsTable').DataTable({
        responsive: true,
        pageLength: 10,
        order: [[1, 'asc']],
        language: {
            emptyTable: "No students found in your department"
        }
    });
});

function viewStudentDetails(studentId) {
    $.ajax({
        url: '${pageContext.request.contextPath}/teacher/studentDetails',
        method: 'GET',
        data: { studentId: studentId },
        success: function(response) {
            $('#mainContent').html(response);
        },
        error: function(xhr, status, error) {
            alert('Error loading student details: ' + error);
        }
    });
}

function manageMarks(studentId) {
    $.ajax({
        url: '${pageContext.request.contextPath}/teacher/marks',
        method: 'GET',
        data: { studentId: studentId },
        success: function(response) {
            $('#mainContent').html(response);
        },
        error: function(xhr, status, error) {
            alert('Error loading marks management: ' + error);
        }
    });
}

function manageAttendance(studentId) {
    $.ajax({
        url: '${pageContext.request.contextPath}/teacher/attendance',
        method: 'GET',
        data: { studentId: studentId },
        success: function(response) {
            $('#mainContent').html(response);
        },
        error: function(xhr, status, error) {
            alert('Error loading attendance management: ' + error);
        }
    });
}
</script>
</html>
