<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="beans.User, beans.Student, beans.Leaderboard, java.util.*, beans.Subject" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
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
        
        .widgets {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .widget {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        
        .widget:hover {
            transform: translateY(-5px);
        }
        
        .widget-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .widget-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
        }
        
        .widget-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
        }
        
        .progress-container {
            margin-top: 15px;
        }
        
        .progress-bar {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            overflow: hidden;
        }
        
        .progress {
            height: 100%;
            background-color: var(--success);
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
        
        .badge {
            display: inline-block;
            padding: 3px 8px;
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
                <h1>Dashboard</h1>
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
            
            <!-- Widgets -->
            <div class="widgets">
                <!-- Attendance Widget -->
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Attendance</h3>
                        <div class="widget-icon">📊</div>
                    </div>
                    <div class="widget-content">
                        <h4><fmt:formatNumber value="${attendanceStats['Overall']}" pattern="#0.0" />% Present</h4>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress" style="width: ${attendanceStats['Overall']}%;"></div>
                            </div>
                        </div>
                        <p>Last updated: Today</p>
                    </div>
                </div>
                
                <!-- Marks Widget -->
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Current Marks</h3>
                        <div class="widget-icon">📝</div>
                    </div>
                    <div class="widget-content">
                        <h4>GPA: <fmt:formatNumber value="${gpa}" pattern="#0.0" />/4.0</h4>
                        <table class="data-table">
<c:forEach var="grade" items="${grades}" varStatus="loop">
                                <c:if test="${loop.index < 3}">
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
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </table>
                    </div>
                </div>
                
                <!-- Rank Widget -->
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Class Rank</h3>
                        <div class="widget-icon">🏆</div>
                    </div>
                    <div class="widget-content">
                        <h2 style="font-size: 36px; margin: 10px 0; color: var(--primary);">#${rank.rank}</h2>
                        <p>Out of ${rank.totalStudents} students</p>
                        <c:set var="percentage" value="${(rank.rank / rank.totalStudents) * 100}" />
                        <p>Top <fmt:formatNumber value="${percentage}" pattern="#0" />% of your class</p>
                    </div>
                </div>
            </div>
            
            <!-- Second Row Widgets -->
            <div class="widgets">
                <!-- Certificates Widget -->
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Certificates</h3>
                        <div class="widget-icon">🏅</div>
                    </div>
                    <div class="widget-content">
                        <table class="data-table">
                            <tr>
                                <td>Math Olympiad</td>
                                <td>2023</td>
                                <td><a href="#">Download</a></td>
                            </tr>
                            <tr>
                                <td>Science Fair</td>
                                <td>2023</td>
                                <td><a href="#">Download</a></td>
                            </tr>
                            <tr>
                                <td>Perfect Attendance</td>
                                <td>2022</td>
                                <td><a href="#">Download</a></td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <!-- Subjects Widget -->
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Current Subjects</h3>
                        <div class="widget-icon">📚</div>
                    </div>
                    <div class="widget-content">
                        <table class="data-table">
                            <c:forEach var="subject" items="${subjects}" varStatus="loop">
                                <c:if test="${loop.index < 4}">
                                    <tr>
                                        <td>${subject.subjectName}</td>
                                        <td>Prof. ${subject.subjectCode}</td>
                                    </tr>
                                </c:if>
                            </c:forEach>
                        </table>
                    </div>
                </div>
                
                <!-- Upcoming Events Widget -->
                <div class="widget">
                    <div class="widget-header">
                        <h3 class="widget-title">Upcoming Events</h3>
                        <div class="widget-icon">📅</div>
                    </div>
                    <div class="widget-content">
                        <table class="data-table">
                            <tr>
                                <td>Midterm Exams</td>
                                <td>Oct 15-20</td>
                            </tr>
                            <tr>
                                <td>Science Fair</td>
                                <td>Nov 5</td>
                            </tr>
                            <tr>
                                <td>Parent-Teacher Meeting</td>
                                <td>Nov 15</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>