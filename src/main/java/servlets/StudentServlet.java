package servlets;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.Attendance;
import beans.Leaderboard;
import beans.Mark;
import beans.Student;
import beans.Subject;
import beans.SubjectCredit;
import beans.User;
import dao.StudentDao;

@WebServlet({"/student/dashboard", "/student/attendance", "/student/marks", "/student/subjects", "/student/leaderboard", "/student/profile"})
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private StudentDao studentDao;
    
    public void init() {
        studentDao = new StudentDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("student")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            Student student = studentDao.getStudentByUserId(user.getUserId());
            request.setAttribute("student", student);
            
            if (path.equals("/student/dashboard")) {
                loadDashboard(request, student.getStudentId());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/StudentDashboard.jsp");
                dispatcher.forward(request, response);
            } else if (path.equals("/student/attendance")) {
                loadAttendance(request, student.getStudentId());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/attendance.jsp");
                dispatcher.forward(request, response);
            } else if (path.equals("/student/marks")) {
                loadMarks(request, student.getStudentId());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/marks.jsp");
                dispatcher.forward(request, response);
            } else if (path.equals("/student/subjects")) {
                loadSubjects(request, student.getStudentId());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/subjects.jsp");
                dispatcher.forward(request, response);
            } else if (path.equals("/student/leaderboard")) {
                loadLeaderboard(request, student.getStudentId());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/leaderboard.jsp");
                dispatcher.forward(request, response);
            } else if (path.equals("/student/profile")) {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/Resumebuilder.html");
                dispatcher.forward(request, response);
            }
            else {}
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void loadDashboard(HttpServletRequest request, int studentId) {
        // Get attendance statistics
        Map<String, Double> attendanceStats = studentDao.getAttendancePercentage(studentId);
        request.setAttribute("attendanceStats", attendanceStats);
        
        // Get subject grades
        Map<String, String> grades = studentDao.getSubjectGrades(studentId);
        request.setAttribute("grades", grades);
        
        // Get GPA
        double gpa = studentDao.getGPA(studentId);
        request.setAttribute("gpa", gpa);
        
        // Get rank
        Leaderboard rank = studentDao.getStudentRank(studentId);
        request.setAttribute("rank", rank);
        
        // Get subjects
        List<Subject> subjects = studentDao.getStudentSubjects(studentId);
        request.setAttribute("subjects", subjects);
    }
    
    private void loadSubjects(HttpServletRequest request, int studentId) {
        List<Subject> subjects = studentDao.getStudentSubjects(studentId);
        request.setAttribute("subjects", subjects);
        
        List<SubjectCredit> credits = studentDao.getStudentSubjectCredits(studentId);
        request.setAttribute("credits", credits);
    }
    
 // Add these methods to your existing StudentServlet.java class

    private void loadAttendance(HttpServletRequest request, int studentId) {
        List<Attendance> attendanceList = studentDao.getStudentAttendance(studentId);
        request.setAttribute("attendanceList", attendanceList);
        
        Map<String, Double> attendanceStats = studentDao.getAttendancePercentage(studentId);
        request.setAttribute("attendanceStats", attendanceStats);
        
        // Get attendance statistics for charts
        Map<String, Integer> stats = studentDao.getAttendanceStatistics(studentId);
        request.setAttribute("attendanceStatistics", stats);
    }

    private void loadMarks(HttpServletRequest request, int studentId) {
        List<Mark> marksList = studentDao.getStudentMarks(studentId);
        request.setAttribute("marksList", marksList);
        
        Map<String, String> grades = studentDao.getSubjectGrades(studentId);
        request.setAttribute("grades", grades);
        
        double gpa = studentDao.getGPA(studentId);
        request.setAttribute("gpa", gpa);
        
        // Get distinct exam types for filtering
        List<String> examTypes = studentDao.getDistinctExamTypes(studentId);
        request.setAttribute("examTypes", examTypes);
        
        // Get exam type from request parameter for filtering
        String selectedExamType = request.getParameter("examType");
        if (selectedExamType != null && !selectedExamType.isEmpty()) {
            List<Mark> filteredMarks = studentDao.getMarksByExamType(studentId, selectedExamType);
            request.setAttribute("filteredMarks", filteredMarks);
            request.setAttribute("selectedExamType", selectedExamType);
        }
    }

    private void loadLeaderboard(HttpServletRequest request, int studentId) {
        Leaderboard studentRank = studentDao.getStudentRank(studentId);
        request.setAttribute("studentRank", studentRank);
        
        double gpa = studentDao.getGPA(studentId);
        request.setAttribute("gpa", gpa);
        
        // Get top 10 students for comparison
        List<Leaderboard> topStudents = studentDao.getTopRankedStudents(10);
        request.setAttribute("topStudents", topStudents);
        
        // Calculate percentile
        if (studentRank != null && studentRank.getTotalStudents() > 0) {
            double percentile = ((double)(studentRank.getTotalStudents() - studentRank.getRank() + 1) / studentRank.getTotalStudents()) * 100;
            request.setAttribute("percentile", percentile);
        }
    }
    @Override
    public void destroy() {
        if (studentDao != null) {
            studentDao.close();
        }
    }
}