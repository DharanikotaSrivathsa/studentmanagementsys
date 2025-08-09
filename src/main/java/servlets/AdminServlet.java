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

import beans.Admins;
import beans.Student;
import beans.Teachers;
import beans.User;
import dao.AdminDao;

@WebServlet(urlPatterns = {
    "/admin/dashboard",
    "/admin/students",
    "/admin/teachers",
    "/admin/departments",
    "/admin/profile"
})
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private AdminDao adminDao;
    
    public void init() {
        adminDao = new AdminDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String servletPath = request.getServletPath();
        
        try {
            Admins admin = adminDao.getAdminByUserId(user.getUserId());
            request.setAttribute("admin", admin);
            
            switch (servletPath) {
                case "/admin/dashboard":
                    loadDashboard(request);
                    RequestDispatcher dashboardDispatcher = request.getRequestDispatcher("/AdminDashboard.jsp");
                    dashboardDispatcher.forward(request, response);
                    break;
                    
                case "/admin/students":
                    loadStudents(request);
                    RequestDispatcher studentsDispatcher = request.getRequestDispatcher("/AdminStudents.jsp");
                    studentsDispatcher.forward(request, response);
                    break;
                    
                case "/admin/teachers":
                    loadTeachers(request);
                    RequestDispatcher teachersDispatcher = request.getRequestDispatcher("/AdminTeachers.jsp");
                    teachersDispatcher.forward(request, response);
                    break;
                    
                case "/admin/departments":
                    loadDepartments(request);
                    RequestDispatcher departmentsDispatcher = request.getRequestDispatcher("/AdminDepartments.jsp");
                    departmentsDispatcher.forward(request, response);
                    break;
                    
                case "/admin/profile":
                    RequestDispatcher profileDispatcher = request.getRequestDispatcher("/AdminProfile.jsp");
                    profileDispatcher.forward(request, response);
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    private void loadDashboard(HttpServletRequest request) throws Exception {
        // Get student and teacher counts by department
        Map<String, Integer> departmentStudentCounts = adminDao.getDepartmentStudentCounts();
        Map<String, Integer> departmentTeacherCounts = adminDao.getDepartmentTeacherCounts();
        
        // Get student counts by semester
        Map<Integer, Integer> semesterStudentCounts = adminDao.getSemesterStudentCounts();
        
        // Get total numbers for dashboard widgets
        int totalStudents = departmentStudentCounts.values().stream().mapToInt(Integer::intValue).sum();
        int totalTeachers = departmentTeacherCounts.values().stream().mapToInt(Integer::intValue).sum();
        int totalDepartments = departmentStudentCounts.size();
        
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalTeachers", totalTeachers);
        request.setAttribute("totalDepartments", totalDepartments);
        request.setAttribute("departmentStudentCounts", departmentStudentCounts);
        request.setAttribute("departmentTeacherCounts", departmentTeacherCounts);
        request.setAttribute("semesterStudentCounts", semesterStudentCounts);
    }
    
    private void loadStudents(HttpServletRequest request) throws Exception {
        List<Student> students = adminDao.getAllStudents();
        request.setAttribute("students", students);
    }
    
    private void loadTeachers(HttpServletRequest request) throws Exception {
        List<Teachers> teachers = adminDao.getAllTeachers();
        request.setAttribute("teachers", teachers);
    }
    
    private void loadDepartments(HttpServletRequest request) throws Exception {
        Map<String, Integer> departmentStudentCounts = adminDao.getDepartmentStudentCounts();
        Map<String, Integer> departmentTeacherCounts = adminDao.getDepartmentTeacherCounts();
        
        request.setAttribute("departmentStudentCounts", departmentStudentCounts);
        request.setAttribute("departmentTeacherCounts", departmentTeacherCounts);
    }
    
    @Override
    public void destroy() {
        if (adminDao != null) {
            adminDao.close();
        }
    }
}