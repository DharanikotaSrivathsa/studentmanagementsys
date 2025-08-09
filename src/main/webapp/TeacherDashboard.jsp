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
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
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
            
            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <!-- Top navbar -->
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
                
                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.message}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <c:remove var="message" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.error}
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>
                
                <!-- Add this after the navbar and before the Content Row -->
                <div id="mainContent">
                    <!-- Original dashboard content -->
                    <div id="dashboardContent">
                        <!-- Content Row -->
                        <div class="row">
                            <!-- Teacher Info Card -->
                            <div class="col-md-6 mb-4">
                                <div class="card">
                                    <div class="card-header">
                                        <i class="fas fa-user-circle mr-1"></i> Teacher Information
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <h4>${teacher.name}</h4>
                                                <p class="text-muted">Department: ${teacher.department}</p>
                                                <hr>
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <p><strong>Email:</strong> ${teacher.email}</p>
                                                        <p><strong>Phone:</strong> ${teacher.phone}</p>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <p><strong>Qualification:</strong> ${teacher.qualification}</p>
                                                        <p><a href="#" data-toggle="modal" data-target="#profileModal" class="btn btn-sm btn-primary">
                                                            <i class="fas fa-edit"></i> Edit Profile
                                                        </a></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Quick Access Card -->
                            <div class="col-md-6 mb-4">
                                <div class="card">
                                    <div class="card-header">
                                        <i class="fas fa-bolt mr-1"></i> Quick Access
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <a href="${pageContext.request.contextPath}/teacher/attendance" class="btn btn-block btn-primary mb-3">
                                                    <i class="fas fa-calendar-check"></i> Mark Attendance
                                                </a>
                                                <a href="${pageContext.request.contextPath}/teacher/marks" class="btn btn-block btn-success mb-3">
                                                    <i class="fas fa-chart-bar"></i> Enter Marks
                                                </a>
                                            </div>
                                            <div class="col-md-6">
                                                <a href="${pageContext.request.contextPath}/teacher/students" class="btn btn-block btn-info mb-3">
                                                    <i class="fas fa-users"></i> View Students
                                                </a>
                                                <a href="${pageContext.request.contextPath}/teacher/leaderboard" class="btn btn-block btn-warning mb-3">
                                                    <i class="fas fa-trophy"></i> Leaderboard
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Stats Cards Row -->
                        <div class="row">
                            <!-- Attendance Stats Card -->
                            <div class="col-xl-4 col-md-6 mb-4">
                                <div class="card stats-card primary h-100">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col">
                                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                    Attendance (Last 30 Days)</div>
                                                <div id="attendanceStatsContainer" class="mt-3">
                                                    <!-- JS will load chart here -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Subject Performance Card -->
                            <div class="col-xl-4 col-md-6 mb-4">
                                <div class="card stats-card success h-100">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col">
                                                <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                    Subject Performance</div>
                                                <div id="subjectPerformanceContainer" class="mt-3">
                                                    <!-- JS will load chart here -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Student Success Card -->
                            <div class="col-xl-4 col-md-6 mb-4">
                                <div class="card stats-card info h-100">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col">
                                                <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                                    Student Success</div>
                                                <div id="studentSuccessContainer" class="mt-3">
                                                    <!-- JS will load chart here -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Content Row -->
                        <div class="row">
                            <!-- Upcoming Exams Card -->
                            <div class="col-md-6 mb-4">
                                <div class="card shadow h-100">
                                    <div class="card-header">
                                        <i class="fas fa-calendar mr-1"></i> Upcoming Exams
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-hover" id="upcomingExamsTable" width="100%" cellspacing="0">
                                                <thead>
                                                    <tr>
                                                        <th>Exam Name</th>
                                                        <th>Subject</th>
                                                        <th>Date</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${upcomingExams}" var="exam">
                                                        <tr>
                                                            <td>${exam.examName}</td>
                                                            <td>${exam.subjectName}</td>
                                                            <td>${exam.examDate}</td>
                                                        </tr>
                                                    </c:forEach>
                                                    <c:if test="${empty upcomingExams}">
                                                        <tr>
                                                            <td colspan="3" class="text-center">No upcoming exams scheduled</td>
                                                        </tr>
                                                    </c:if>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Recent Activity Card -->
                            <div class="col-md-6 mb-4">
                                <div class="card shadow h-100">
                                    <div class="card-header">
                                        <i class="fas fa-list mr-1"></i> Recent Activity
                                    </div>
                                    <div class="card-body">
                                        <ul class="list-group list-group-flush">
                                            <c:forEach items="${recentActivities}" var="activity">
                                                <li class="list-group-item">
                                                    <i class="${activity.icon} mr-2 text-${activity.color}"></i>
                                                    ${activity.description}
                                                    <small class="float-right text-muted">${activity.timestamp}</small>
                                                </li>
                                            </c:forEach>
                                            <c:if test="${empty recentActivities}">
                                                <li class="list-group-item text-center">No recent activities</li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Container for AJAX loaded content -->
                    <div id="dynamicContent" style="display: none;"></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Profile Modal -->
    <div class="modal fade" id="profileModal" tabindex="-1" role="dialog" aria-labelledby="profileModalLabel" aria-hidden="true">
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
    
    <!-- Bootstrap core JavaScript-->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <!-- Dashboard Charts -->
    <script>
        // Attendance chart
        document.addEventListener('DOMContentLoaded', function() {
            // Attendance data
            var attendanceData = {
                present: ${attendanceStats.present},
                absent: ${attendanceStats.absent},
                leave: ${attendanceStats.leave}
            };
            
            // Render attendance pie chart
            var attendanceCtx = document.createElement('canvas');
            attendanceCtx.height = 200;
            document.getElementById('attendanceStatsContainer').appendChild(attendanceCtx);
            
            new Chart(attendanceCtx, {
                type: 'pie',
                data: {
                    labels: ['Present', 'Absent', 'Leave'],
                    datasets: [{
                        data: [attendanceData.present, attendanceData.absent, attendanceData.leave],
                        backgroundColor: ['#1cc88a', '#e74a3b', '#f6c23e'],
                        hoverBackgroundColor: ['#17a673', '#c23b21', '#dda20a'],
                        hoverBorderColor: "rgba(234, 236, 244, 1)",
                    }],
                },
                options: {
                    maintainAspectRatio: false,
                    tooltips: {
                        backgroundColor: "rgb(255,255,255)",
                        bodyFontColor: "#858796",
                        borderColor: '#dddfeb',
                        borderWidth: 1,
                        xPadding: 15,
                        yPadding: 15,
                        displayColors: false,
                        caretPadding: 10,
                    },
                    legend: {
                        display: true,
                        position: 'bottom'
                    },
                    cutoutPercentage: 0,
                },
            });
            
            // Subject performance data
            var subjectNames = [];
            var subjectAverages = [];
            
            <c:forEach items="${subjectAverages}" var="entry">
                subjectNames.push("${entry.key}");
                subjectAverages.push(${entry.value});
            </c:forEach>
            
            // Render subject performance bar chart
            var subjectCtx = document.createElement('canvas');
            subjectCtx.height = 200;
            document.getElementById('subjectPerformanceContainer').appendChild(subjectCtx);
            
            new Chart(subjectCtx, {
                type: 'bar',
                data: {
                    labels: subjectNames,
                    datasets: [{
                        label: 'Average Score %',
                        data: subjectAverages,
                        backgroundColor: '#36b9cc',
                        borderColor: '#2c9faf',
                        borderWidth: 1
                    }]
                },
                options: {
                    maintainAspectRatio: false,
                    scales: {
                        xAxes: [{
                            ticks: {
                                maxRotation: 90,
                                minRotation: 80
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                max: 100
                            }
                        }]
                    }
                }
            });
            
            // Student success data - assuming we have data for passed and failed students
            var passFailData = {
                pass: 85, // Default value, replace with actual data
                fail: 15  // Default value, replace with actual data
            };
            
            // Render student success doughnut chart
            var successCtx = document.createElement('canvas');
            successCtx.height = 200;
            document.getElementById('studentSuccessContainer').appendChild(successCtx);
            
            new Chart(successCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Pass', 'Fail'],
                    datasets: [{
                        data: [passFailData.pass, passFailData.fail],
                        backgroundColor: ['#4e73df', '#e74a3b'],
                        hoverBackgroundColor: ['#2e59d9', '#c23b21'],
                        hoverBorderColor: "rgba(234, 236, 244, 1)",
                    }],
                },
                options: {
                    maintainAspectRatio: false,
                    tooltips: {
                        backgroundColor: "rgb(255,255,255)",
                        bodyFontColor: "#858796",
                        borderColor: '#dddfeb',
                        borderWidth: 1,
                        xPadding: 15,
                        yPadding: 15,
                        displayColors: false,
                        caretPadding: 10,
                    },
                    legend: {
                        display: true,
                        position: 'bottom'
                    },
                    cutoutPercentage: 70,
                },
            });
        });
    </script>
    
    <!-- Custom JavaScript for Dynamic Content -->
    <script>
    $(document).ready(function() {
        $('#studentsLink').click(function(e) {
            e.preventDefault();
            
            // Update active state
            $('.nav-link').removeClass('active');
            $(this).addClass('active');
            
            // Show loading spinner
            $('#dynamicContent').html(`
                <div class="d-flex justify-content-center">
                    <div class="spinner-border text-primary" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </div>
            `).show();
            $('#dashboardContent').hide();
            
            // Load students data
           
    </script>
</body>
</html>