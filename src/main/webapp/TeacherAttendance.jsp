<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
                

<!-- Attendance Management Content -->
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-calendar-check"></i> Attendance Management
                    </h6>
                </div>
                <div class="card-body">
                    <!-- Attendance Form -->
                    <form id="attendanceForm">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="attendanceDate" class="form-label">Date</label>
                                <input type="date" class="form-control" id="attendanceDate" name="date" 
                                       value="${selectedDate}" required>
                            </div>
		                        <div class="col-md-4">
								    <label for="semesterSelect" class="form-label">Semester</label>
								    <select class="form-control" id="semesterSelect" name="semester" required>
								        <option value="">Select Semester</option>
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
                                <label class="form-label">&nbsp;</label>
                                <button type="button" class="btn btn-primary d-block" id="loadStudentsBtn">
                                    <i class="fas fa-search"></i> Load Students
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Students List -->
                    <div id="studentsContainer" style="display: none;">
                        <hr>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5>Mark Attendance</h5>
                            <div>
                                <button type="button" class="btn btn-success btn-sm" id="markAllPresent">
                                    <i class="fas fa-check-circle"></i> All Present
                                </button>
                                <button type="button" class="btn btn-danger btn-sm" id="markAllAbsent">
                                    <i class="fas fa-times-circle"></i> All Absent
                                </button>
                            </div>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover" id="attendanceTable">
							    <thead class="table-light">
							        <tr>
							            <th>Roll Number</th>
							            <th>Student Name</th>
							            <th>Subject</th>
							            <th>Present</th>
							            <th>Absent</th>
							            <th>Leave</th>
							        </tr>
							    </thead>
							    <tbody id="studentsTableBody">
							        <!-- Students will be loaded here -->
							    </tbody>
							</table>
                        </div>
                        
                        <div class="mt-3">
                            <button type="button" class="btn btn-primary" id="saveAttendanceBtn">
                                <i class="fas fa-save"></i> Save Attendance
                            </button>
                            <button type="button" class="btn btn-secondary" id="resetFormBtn">
                                <i class="fas fa-undo"></i> Reset
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Loading Modal -->
<div class="modal fade" id="loadingModal" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="sr-only">Loading...</span>
                </div>
                <p class="mt-2 mb-0">Processing attendance...</p>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Load students when subject is selected
    $('#loadStudentsBtn').click(function() {
		    const semester = $('#semesterSelect').val();
		    const date = $('#attendanceDate').val();
		    
		    if (!semester || !date) {
		        alert('Please select both semester and date');
		        return;
		    }
		    
		    $('#loadingModal').modal('show');
		    
		    $.ajax({
		        url: '${pageContext.request.contextPath}/teacher/getStudentsBySemester',
		        method: 'GET',
		        data: { semester: semester },
		        success: function(data) {
		            $('#loadingModal').modal('hide');
		            loadStudentsTable(data.students, data.subjects);
		            $('#studentsContainer').show();
		        },
		        error: function(xhr, status, error) {
		            $('#loadingModal').modal('hide');
		            alert('Error loading students: ' + error);
		        }
		    });
		});

    
    // Function to load students table
    function loadStudentsTable(students, subjects) {
		    const tbody = $('#studentsTableBody');
		    tbody.empty();
		    
		    students.forEach(function(student) {
		        subjects.forEach(function(subject) {
		            const row = `
		                <tr>
		                    <td>${student.rollNumber}</td>
		                    <td>${student.name}</td>
		                    <td>${subject.subjectName} (${subject.subjectCode})</td>
		                    <td class="text-center">
		                        <input type="radio" name="attendance_${student.studentId}_${subject.subjectId}" 
		                               value="present" class="attendance-radio" 
		                               data-student-id="${student.studentId}" 
		                               data-subject-id="${subject.subjectId}">
		                    </td>
		                    <td class="text-center">
		                        <input type="radio" name="attendance_${student.studentId}_${subject.subjectId}" 
		                               value="absent" class="attendance-radio" 
		                               data-student-id="${student.studentId}" 
		                               data-subject-id="${subject.subjectId}">
		                    </td>
		                    <td class="text-center">
		                        <input type="radio" name="attendance_${student.studentId}_${subject.subjectId}" 
		                               value="leave" class="attendance-radio" 
		                               data-student-id="${student.studentId}" 
		                               data-subject-id="${subject.subjectId}">
		                    </td>
		                </tr>
		            `;
		            tbody.append(row);
		        });
		    });
		}
    // Mark all present
    $('#markAllPresent').click(function() {
        $('input[value="present"]').prop('checked', true);
    });
    
    // Mark all absent
    $('#markAllAbsent').click(function() {
        $('input[value="absent"]').prop('checked', true);
    });
    
    // Save attendance
    $('#saveAttendanceBtn').click(function() {
        const subjectId = $('#subjectSelect').val();
        const date = $('#attendanceDate').val();
        
        if (!subjectId || !date) {
            alert('Please select subject and date');
            return;
        }
        
        const attendanceData = [];
        const studentIds = [];
        const statuses = [];
        
        $('.attendance-radio:checked').each(function() {
            const studentId = $(this).data('student-id');
            const status = $(this).val();
            
            studentIds.push(studentId);
            statuses.push(status);
        });
        
        if (studentIds.length === 0) {
            alert('Please mark attendance for at least one student');
            return;
        }
        
        $('#loadingModal').modal('show');
        
        $.ajax({
            url: '${pageContext.request.contextPath}/teacher/attendance',
            method: 'POST',
            data: {
                subjectId: subjectId,
                date: date,
                'studentIds[]': studentIds,
                'statuses[]': statuses
            },
            success: function(response) {
                $('#loadingModal').modal('hide');
                if (response.success) {
                    alert(response.message + ' (' + response.updated + ' records updated)');
                    $('#resetFormBtn').click();
                } else {
                    alert('Error: ' + response.message);
                }
            },
            error: function(xhr, status, error) {
                $('#loadingModal').modal('hide');
                alert('Error saving attendance: ' + error);
            }
        });
    });
    
    // Reset form
    $('#resetFormBtn').click(function() {
        $('#attendanceForm')[0].reset();
        $('#studentsContainer').hide();
        $('#studentsTableBody').empty();
    });
});
</script>



    <% if(request.getAttribute("studentList") != null) { %>
    <form action="TeacherServlet" method="post">
        <input type="hidden" name="action" value="updateAttendance">
        <input type="hidden" name="attendanceDate" value="${param.attendanceDate}">
        <input type="hidden" name="semester" value="${param.semester}">
        <table class="table">
            <thead>
                <tr>
                    <th>Roll No</th>
                    <th>Student Name</th>
                    <th>Subject</th>
                    <th>Attendance</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${studentList}" var="student">
                    <tr>
                        <td>${student.studentId}</td>
                        <td>${student.name}</td>
                        <td>
                            <select name="subject_${student.studentId}" required>
                                <c:forEach items="${subjectList}" var="subject">
                                    <option value="${subject.subjectId}">${subject.subjectName}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>
                            <select name="status_${student.studentId}" required>
                                <option value="present">Present</option>
                                <option value="absent">Absent</option>
                            </select>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <button type="submit" class="btn btn-success">Submit Attendance</button>
    </form>
    <% } %>
</div>