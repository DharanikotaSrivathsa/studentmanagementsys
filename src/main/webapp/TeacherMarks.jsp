<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

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
  				
  				<!-- Add this content inside the main content div in your TeacherMarks.jsp, after the navbar -->

<!-- Marks Management Section -->
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">
                    <i class="fas fa-chart-bar mr-2"></i>Marks Management
                </h5>
            </div>
            <div class="card-body">
                <!-- Filter Section -->
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="semesterFilter" class="form-label">Select Semester:</label>
                        <select class="form-select form-control" id="semesterFilter">
                            <option value="">Choose Semester</option>
                            <option value="1">Semester 1</option>
                            <option value="2">Semester 2</option>
                            <option value="3">Semester 3</option>
                            <option value="4">Semester 4</option>
                            <option value="5">Semester 5</option>
                            <option value="6">Semester 6</option>
                            <option value="7">Semester 7</option>
                            <option value="8">Semester 8</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="subjectFilter" class="form-label">Filter by Subject:</label>
                        <select class="form-select form-control" id="subjectFilter">
                            <option value="">All Subjects</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">&nbsp;</label>
                        <div>
                            <button class="btn btn-primary" onclick="loadMarks()">
                                <i class="fas fa-search"></i> Load Marks
                            </button>
                            <button class="btn btn-success" onclick="showAddMarkModal()">
                                <i class="fas fa-plus"></i> Add Marks
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Marks Table -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover" id="marksTable">
                        <thead class="table-dark">
                            <tr>
                                <th>Roll Number</th>
                                <th>Student Name</th>
                                <th>Subject</th>
                                <th>Subject Code</th>
                                <th>Exam Type</th>
                                <th>Marks Obtained</th>
                                <th>Total Marks</th>
                                <th>Percentage</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="marksTableBody">
                            <tr>
                                <td colspan="9" class="text-center text-muted">
                                    <i class="fas fa-info-circle"></i> Please select a semester to view marks
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add/Edit Mark Modal -->
<div class="modal fade" id="markModal" tabindex="-1" aria-labelledby="markModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="markModalLabel">Add Marks</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="markForm">
                    <input type="hidden" id="markId" name="markId">
                    <div class="mb-3">
                        <label for="studentSelect" class="form-label">Student:</label>
                        <select class="form-select form-control" id="studentSelect" name="studentId" required>
                            <option value="">Select Student</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="subjectSelect" class="form-label">Subject:</label>
                        <select class="form-select form-control" id="subjectSelect" name="subjectId" required>
                            <option value="">Select Subject</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="examType" class="form-label">Exam Type:</label>
                        <select class="form-select form-control" id="examType" name="examType" required>
                            <option value="">Select Exam Type</option>
                            <option value="Mid Term">Mid Term</option>
                            <option value="Final Term">Final Term</option>
                            <option value="Quiz">Quiz</option>
                            <option value="Assignment">Assignment</option>
                            <option value="Practical">Practical</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="marksObtained" class="form-label">Marks Obtained:</label>
                        <input type="number" class="form-control" id="marksObtained" name="marksObtained" 
                               min="0" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label for="totalMarks" class="form-label">Total Marks:</label>
                        <input type="number" class="form-control" id="totalMarks" name="totalMarks" 
                               min="1" step="0.01" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Percentage:</label>
                        <input type="text" class="form-control" id="percentage" readonly>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="saveMarks()">Save Marks</button>
            </div>
        </div>
    </div>
</div>



<!-- Profile Modal -->
<div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="profileModalLabel">Teacher Profile</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="text-center mb-3">
                    <div class="profile-img mx-auto" style="width: 100px; height: 100px; font-size: 48px;">
                        <i class="fas fa-user"></i>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Name:</strong> ${teacher.name}</p>
                        <p><strong>Employee ID:</strong> ${teacher.employeeId}</p>
                        <p><strong>Email:</strong> ${teacher.email}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Department:</strong> ${teacher.department}</p>
                        <p><strong>Phone:</strong> ${teacher.phone}</p>
                        <p><strong>Designation:</strong> ${teacher.designation}</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
  			