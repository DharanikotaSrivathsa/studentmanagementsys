package servlets;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.User;
import dao.LoginDao;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private LoginDao loginDao;
    
    public void init() {
        loginDao = new LoginDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectBasedOnRole(request, response, user);
        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String error = null;
        
        if (username == null || username.trim().isEmpty()) {
            error = "Username is required";
        } else if (password == null || password.trim().isEmpty()) {
            error = "Password is required";
        }
        
        if (error != null) {
            request.setAttribute("error", error);
            RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            User user = loginDao.authenticate(username, password);
            
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                
                redirectBasedOnRole(request, response, user);
            } else {
                request.setAttribute("error", "Invalid username or password");
                RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login. Please try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("Login.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void redirectBasedOnRole(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        String contextPath = request.getContextPath();
        
        switch (user.getRole()) {
            case "admin":
                response.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case "teacher":
                response.sendRedirect(contextPath + "/teacher/dashboard");
                break;
            case "student":
                response.sendRedirect(contextPath + "/student/dashboard");
                break;
            default:
                // If role is unknown, logout and redirect to login page
                request.getSession().invalidate();
                response.sendRedirect(contextPath + "/Login.jsp");
                break;
        }
    }
    
    @Override
    public void destroy() {
        if (loginDao != null) {
            loginDao.close();
        }
    }
}