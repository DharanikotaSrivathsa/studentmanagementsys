package servlets;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Student;
import beans.Teachers;
import beans.User;
import dao.RegisterDao;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RegisterDao registerDao;
    
    public void init() {
        registerDao = new RegisterDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/Register.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Handle username availability check
        if ("checkUsername".equals(action)) {
            String username = request.getParameter("username");
            boolean isAvailable = registerDao.isUsernameAvailable(username);
            response.setContentType("text/plain");
            response.getWriter().write(isAvailable ? "available" : "taken");
            return;
        }
        
        // Handle actual registration
        String userType = request.getParameter("userType");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(password);
        user.setRole(userType);
        
        boolean success = false;
        
        try {
            if ("student".equals(userType)) {
                Student student = new Student();
                student.setName(request.getParameter("name"));
                student.setRollNumber(request.getParameter("rollNumber"));
                student.setEmail(request.getParameter("email"));
                student.setPhone(request.getParameter("phone"));
                student.setDateOfBirth(java.sql.Date.valueOf(request.getParameter("dateOfBirth")));
                student.setAddress(request.getParameter("address"));
                student.setDepartment(request.getParameter("department"));
                student.setSemester(Integer.parseInt(request.getParameter("semester")));
                
                success = registerDao.registerNewStudent(user, student);
            } else if ("teacher".equals(userType)) {
                Teachers teacher = new Teachers();
                teacher.setName(request.getParameter("name"));
                teacher.setEmail(request.getParameter("email"));
                teacher.setPhone(request.getParameter("phone"));
                teacher.setDepartment(request.getParameter("department"));
                teacher.setQualification(request.getParameter("qualification"));
                
                success = registerDao.registerNewTeacher(user, teacher);
            }
            
            if (success) {
                request.getSession().setAttribute("message", "Registration successful! Please login.");
                response.sendRedirect(request.getContextPath() + "/Login.jsp");
            } else {
                request.getSession().setAttribute("error", "Registration failed! Please try again.");
                response.sendRedirect(request.getContextPath() + "/Register.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "An error occurred during registration: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Register.jsp");
        }
    }
    
    @Override
    public void destroy() {
        if (registerDao != null) {
            registerDao.close();
        }
    }
}