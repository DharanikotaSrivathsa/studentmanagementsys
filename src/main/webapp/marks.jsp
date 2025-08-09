<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.User, beans.Student, beans.Mark, java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Marks & Grades</title>
    <style>
        :root {
            --primary: #4a6fa5;
            --secondary: #166088;
            --accent: #4fc3f7;
            --light: #f8f9fa;
            --dark: #343a40;
            --success: #28a745;
            --warning: #ffc107;
            --danger: #dc3545;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f7fa;
            color: #333;
        }
        
        .dashboard {
            display: grid;
            grid-template-columns: 250px 1fr;
            min-height: 100vh;
        }
        
        .sidebar {
            background: linear-gradient(180deg, var(--primary), var(--secondary));
            color: white;
            padding: 20px;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar-header {
            text-align: center;
            padding: 20px 0;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 20px;
        }
        
        .sidebar-menu {
            list-style: none;
            padding: 0;
        }
        
        .sidebar-menu li {
            margin-bottom: 10px;
        }
        
        .sidebar-menu a {
            color: white;
            text-decoration: none;
            display: block;
            padding: 10px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .sidebar-menu a:hover {
            background-color: rgba(255,255,255,0.1);
        }
        
        .sidebar-menu a.active {
            background-color: rgba(255,255,255,0.2);
        }
        
        .main-content {
            padding: 30px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .user-profile {
            display: flex;
            align-items: center;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--accent);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            font-weight: bold;
        }
        
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: var(--primary);
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .content-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .filter-section {
            margin-bottom: 20px;
        }
        
        .filter-select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin-right: 10px;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        
        .data-table th, .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .data-table th {
            background-color: var(--light);
            font-weight: 600;
        }
        
        .data-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-success {
            background-color: #d4edda;
            color: var(--success);
        }
        
        .badge-warning {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .badge-danger {
            background-color: #f8d7da;
            color: var(--danger);
        }
        
        .progress-bar {
            height: 20px;
            background-color: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .progress {
            height: 100%;
            line-height: 20px;
            text-align: center;
            color: white;
            font-size: 12px;
            font-weight: bold;
        }
        
        .logout-btn {
            background-color: var(--danger);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .logout-btn:hover {
            background-color: #c82333;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary);
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h2>Student Portal</h2>
            </div>
            <ul class="sidebar-menu">
			    <li><a href="${pageContext.request.contextPath}/student/dashboard" class="active">Dashboard</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/attendance">Attendance</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/marks">Marks & Grades</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/subjects">Subjects</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/leaderboard">Ranking</a></li>
			    <li><a href="${pageContext.request.contextPath}/student/profile">Resumebuilder</a></li>
			</ul>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Marks & Grades</h1>
                <div class="user-profile">
                    <div class="user-avatar">
                        ${student.name.charAt(0)}
                    </div>
                    <span>${student.name}</span>
                    <form action="${pageContext.request.contextPath}/" method="post" style="margin-left: 20px;">
                        <input type="submit" class="logout-btn" value="Logout">
                    </form>
                </div>
            </div>
            
            <!-- Stats Cards -->
            <div class="stats-cards">
                <div class="stat-card">
                    <div class="stat-value"><fmt:formatNumber value="${gpa}" pattern="#0.00" /></div>
                    <div class="stat-label">Current GPA</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${marksList.size()}</div>
                    <div class="stat-label">Total Exams</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${grades.size()}</div>
                    <div class="stat-label">Subjects</div>
                </div>
            </div>
            
            <!-- Subject Grades Overview -->
            <div class="content-section">
                <div class="section-header">
                    <h3>Subject Grades Overview</h3>
                </div>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Subject</th>
                            <th>Grade</th>
                            <th>Performance</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="grade" items="${grades}">
                            <tr>
                                <td>${grade.key}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${grade.value == 'A+' || grade.value == 'A' || grade.value == 'A-'}">
                                            <span class="badge badge-success">${grade.value}</span>
                                        </c:when>
                                        <c:when test="${grade.value == 'B+' || grade.value == 'B' || grade.value == 'B-'}">
                                            <span class="badge badge-success">${grade.value}</span>
                                        </c:when>
                                        <c:when test="${grade.value == 'C+' || grade.value == 'C' || grade.value == 'C-'}">
                                            <span class="badge badge-warning">${grade.value}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">${grade.value}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${grade.value == 'A+' || grade.value == 'A'}">
                                            <div class="progress-bar">
                                                <div class="progress" style="width: 100%; background-color: var(--success);">Excellent</div>
                                            </div>
                                        </c:when>
                                        <c:when test="${grade.value == 'A-' || grade.value == 'B+'}">
                                            <div class="progress-bar">
                                                <div class="progress" style="width: 85%; background-color: var(--success);">Very Good</div>
                                            </div>
                                        </c:when>
                                        <c:when test="${grade.value == 'B' || grade.value == 'B-'}">
                                            <div class="progress-bar">
                                                <div class="progress" style="width: 75%; background-color: var(--warning);">Good</div>
                                            </div>
                                        </c:when>
                                        <c:when test="${grade.value == 'C+' || grade.value == 'C'}">
                                            <div class="progress-bar">
                                                <div class="progress" style="width: 60%; background-color: var(--warning);">Average</div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="progress-bar">
                                                <div class="progress" style="width: 40%; background-color: var(--danger);">Needs Improvement</div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <!-- Detailed Marks -->
            <div class="content-section">
                <div class="section-header">
                    <h3>Detailed Marks</h3>
                    <div class="filter-section">
                        <select class="filter-select" onchange="filterByExamType(this.value)">
                            <option value="">All Exam Types</option>
                            <c:forEach var="examType" items="${examTypes}">
                                <option value="${examType}" ${selectedExamType == examType ? 'selected' : ''}>${examType}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Subject</th>
                            <th>Exam Type</th>
                            <th>Marks Obtained</th>
                            <th>Total Marks</th>
                            <th>Percentage</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty filteredMarks}">
                                <c:forEach var="mark" items="${filteredMarks}">
                                    <tr>
                                        <td>${mark.subjectName}</td>
                                        <td>${mark.examType}</td>
                                        <td>${mark.marksObtained}</td>
                                        <td>${mark.totalMarks}</td>
                                        <td><fmt:formatNumber value="${mark.percentage}" pattern="#0.0" />%</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${mark.percentage >= 90}">
                                                    <span class="badge badge-success">Excellent</span>
                                                </c:when>
                                                <c:when test="${mark.percentage >= 75}">
                                                    <span class="badge badge-success">Good</span>
                                                </c:when>
                                                <c:when test="${mark.percentage >= 60}">
                                                    <span class="badge badge-warning">Average</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Below Average</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="mark" items="${marksList}">
                                    <tr>
                                        <td>${mark.subjectName}</td>
                                        <td>${mark.examType}</td>
                                        <td>${mark.marksObtained}</td>
                                        <td>${mark.totalMarks}</td>
                                        <td><fmt:formatNumber value="${mark.percentage}" pattern="#0.0" />%</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${mark.percentage >= 90}">
                                                    <span class="badge badge-success">Excellent</span>
                                                </c:when>
                                                <c:when test="${mark.percentage >= 75}">
                                                    <span class="badge badge-success">Good</span>
                                                </c:when>
                                                <c:when test="${mark.percentage >= 60}">
                                                    <span class="badge badge-warning">Average</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-danger">Below Average</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        function filterByExamType(examType) {
            const currentUrl = new URL(window.location);
            if (examType) {
                currentUrl.searchParams.set('examType', examType);
            } else {
                currentUrl.searchParams.delete('examType');
            }
            window.location.href = currentUrl.toString();
        }
    </script>
</body>
</html>