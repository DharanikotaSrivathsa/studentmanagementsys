<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Students Management</h1>
    </div>

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