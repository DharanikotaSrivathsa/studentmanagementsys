<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Management System - Register</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .registration-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-header {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #ddd;
        }
        .btn-register {
            background-color: #4CAF50;
            color: white;
            width: 100%;
            padding: 10px;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="registration-container">
            <div class="form-header text-center">
                <h2><i class="fas fa-user-plus"></i> Registration Form</h2>
                <p>Create an account to access Student Management System</p>
            </div>
            
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    ${sessionScope.error}
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                </div>
                <% session.removeAttribute("error"); %>
            </c:if>
            
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="student-tab" data-toggle="tab" href="#student" role="tab" aria-controls="student" aria-selected="true">Student Registration</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="teacher-tab" data-toggle="tab" href="#teacher" role="tab" aria-controls="teacher" aria-selected="false">Teacher Registration</a>
                </li>
            </ul>
            
            <div class="tab-content" id="myTabContent">
                <!-- Student Registration Form -->
                <div class="tab-pane fade show active" id="student" role="tabpanel" aria-labelledby="student-tab">
                    <form id="studentForm" action="${pageContext.request.contextPath}/register" method="post" class="mt-4">
                        <input type="hidden" name="userType" value="student">
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="studentUsername">Username <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="studentUsername" name="username" required>
                                <small id="studentUsernameHelp" class="form-text"></small>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="studentPassword">Password <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="studentPassword" name="password" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="studentName">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="studentName" name="name" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="rollNumber">Roll Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="rollNumber" name="rollNumber" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="studentEmail">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="studentEmail" name="email" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="studentPhone">Phone Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="studentPhone" name="phone" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="dateOfBirth">Date of Birth <span class="text-danger">*</span></label>
                                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="studentDepartment">Department <span class="text-danger">*</span></label>
                                <select class="form-control" id="studentDepartment" name="department" required>
                                    <option value="">Select Department</option>
                                    <option value="Computer Science">Computer Science</option>
                                    <option value="Electrical Engineering">Electrical Engineering</option>
                                    <option value="Mechanical Engineering">Mechanical Engineering</option>
                                    <option value="Civil Engineering">Civil Engineering</option>
                                    <option value="Electronics">Electronics</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="semester">Semester <span class="text-danger">*</span></label>
                                <select class="form-control" id="semester" name="semester" required>
                                    <option value="">Select Semester</option>
                                    <option value="1">1st Semester</option>
                                    <option value="2">2nd Semester</option>
                                    <option value="3">3rd Semester</option>
                                    <option value="4">4th Semester</option>
                                    <option value="5">5th Semester</option>
                                    <option value="6">6th Semester</option>
                                    <option value="7">7th Semester</option>
                                    <option value="8">8th Semester</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Address <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                        </div>
                        
                        <div class="form-group text-center mt-4">
                            <button type="submit" class="btn btn-register">Register as Student</button>
                        </div>
                    </form>
                </div>
                
                <!-- Teacher Registration Form -->
                <div class="tab-pane fade" id="teacher" role="tabpanel" aria-labelledby="teacher-tab">
                    <form id="teacherForm" action="${pageContext.request.contextPath}/register" method="post" class="mt-4">
                        <input type="hidden" name="userType" value="teacher">
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="teacherUsername">Username <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="teacherUsername" name="username" required>
                                <small id="teacherUsernameHelp" class="form-text"></small>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="teacherPassword">Password <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="teacherPassword" name="password" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="teacherName">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="teacherName" name="name" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="teacherEmail">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="teacherEmail" name="email" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="teacherPhone">Phone Number <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="teacherPhone" name="phone" required>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="teacherDepartment">Department <span class="text-danger">*</span></label>
                                <select class="form-control" id="teacherDepartment" name="department" required>
                                    <option value="">Select Department</option>
                                    <option value="Computer Science">Computer Science</option>
                                    <option value="Electrical Engineering">Electrical Engineering</option>
                                    <option value="Mechanical Engineering">Mechanical Engineering</option>
                                    <option value="Civil Engineering">Civil Engineering</option>
                                    <option value="Electronics">Electronics</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="qualification">Qualification <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="qualification" name="qualification" required>
                        </div>
                        
                        <div class="form-group text-center mt-4">
                            <button type="submit" class="btn btn-register">Register as Teacher</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="text-center mt-3">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/Login.jsp">Login here</a></p>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        function checkUsernameAvailability(inputField, helpField) {
            const username = $(inputField).val();
            if (username.length >= 4) {
                $.ajax({
                    type: "POST",
                    url: "${pageContext.request.contextPath}/register",
                    data: {
                        action: "checkUsername",
                        username: username
                    },
                    success: function(response) {
                        if (response.trim() === "available") {
                            $(helpField).text("Username is available").removeClass("text-danger").addClass("text-success");
                            $(inputField).data("available", true);
                        } else {
                            $(helpField).text("Username is already taken").removeClass("text-success").addClass("text-danger");
                            $(inputField).data("available", false);
                        }
                    }
                });
            } else {
                $(helpField).text("Username must be at least 4 characters").removeClass("text-success").addClass("text-danger");
                $(inputField).data("available", false);
            }
        }
        
        $(document).ready(function() {
            let timer;
            $('#studentUsername, #teacherUsername').on('keyup', function() {
                clearTimeout(timer);
                let field = this;
                timer = setTimeout(() => {
                    checkUsernameAvailability(field, '#' + field.id + 'Help');
                }, 500);
            });
            
            // Add form submission validation
            $('#studentForm, #teacherForm').on('submit', function(e) {
                const usernameField = $(this).find('input[name="username"]');
                if (!usernameField.data("available")) {
                    e.preventDefault();
                    alert("Please choose a different username");
                    return false;
                }
                return true;
            });
        });
    </script>
</body>
</html>