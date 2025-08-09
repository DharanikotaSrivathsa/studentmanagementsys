package servlets;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import beans.Mark;
import beans.Student;
import beans.Subject;
import beans.Teachers;
import beans.User;
import dao.TeacherDao;

@WebServlet({"/teacher/dashboard", "/teacher/students", "/teacher/attendance", 
    "/teacher/marks","/teacher/github","/teacher/profiletracker","/teacher/getStudentsBySemester",
    "/teacher/getAttendanceData"})
public class TeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeacherDao teacherDao;
    
    public void init() {
        teacherDao = new TeacherDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("teacher")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        Teachers teacher = teacherDao.getTeacherByUserId(user.getUserId());
        request.setAttribute("teacher", teacher);
        
        switch (path) {
            case "/teacher/dashboard":
                loadDashboard(request, teacher);
                request.getRequestDispatcher("/TeacherDashboard.jsp").forward(request, response);
                break;
            
                
            case "/teacher/students":
                List<Student> students = teacherDao.getStudentsByDepartment(teacher.getDepartment());
                request.setAttribute("students", students);
                request.getRequestDispatcher("/TeacherStudent1.jsp").forward(request, response);
                break;
                
            case "/teacher/github":
                request.getRequestDispatcher("/github.html").forward(request, response);
                break;
                
            case "/teacher/profiletracker":
                request.getRequestDispatcher("/ProfileTracker.html").forward(request, response);
                break;
                
            case "/teacher/attendance":
                loadAttendance(request, teacher);
                request.getRequestDispatcher("/TeacherAttendance.jsp").forward(request, response);
                break;
                
            case "/teacher/marks":
                loadMarks(request, teacher);
                request.getRequestDispatcher("/TeacherMarks.jsp").forward(request, response);
                break;
                
            case "/teacher/subjects":
                loadSubjects(request, teacher);
                request.getRequestDispatcher("/TeacherSubjects.jsp").forward(request, response);
                break;
                
            case "/teacher/profile":
                request.getRequestDispatcher("/TeacherProfile.jsp").forward(request, response);
                break;
                
            case "/teacher/studentDetails":
                handleStudentDetails(request, response);
                break;
            
            case "/teacher/getStudentsBySubject":
                handleGetStudentsBySubject(request, response, teacher);
                break;
                
            case "/teacher/getStudentsBySemester":
                handleGetStudentsBySemester(request, response, teacher);
                break;
                
            case "/teacher/getAttendanceData":
                handleGetAttendanceData(request, response);
                break;
            case "/teacher/getMarksBySemester":
                handleGetMarksBySemester(request, response);
                break;
        }
    }
    
    private void loadDashboard(HttpServletRequest request, Teachers teacher) {
        List<Student> students = teacherDao.getStudentsByDepartment(teacher.getDepartment());
        List<Subject> subjects = teacherDao.getAllSubjects(); // Changed from getTeacherSubjects
        
        request.setAttribute("totalStudents", students.size());
        request.setAttribute("totalSubjects", subjects.size());
        request.setAttribute("subjects", subjects);
        request.setAttribute("recentStudents", students.subList(0, Math.min(5, students.size())));
    }
    
   /* private void loadSubjects(HttpServletRequest request, Teachers teacher) {
        List<Subject> subjects = teacherDao.getAllSubjects(); // Changed from getTeacherSubjects
        request.setAttribute("subjects", subjects);
    }
    */
    
   private void handleGetStudentsBySubject(HttpServletRequest request, HttpServletResponse response, Teachers teacher) 
        throws ServletException, IOException {
    try {
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        List<Student> students = teacherDao.getAllStudentsForSubject(subjectId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < students.size(); i++) {
            Student student = students.get(i);
            json.append("{")
                .append("\"studentId\":").append(student.getStudentId()).append(",")
                .append("\"name\":\"").append(student.getName()).append("\",")
                .append("\"rollNumber\":\"").append(student.getRollNumber()).append("\"")
                .append("}");
            if (i < students.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        response.getWriter().write(json.toString());
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
    }
}


   private void handleGetStudentsBySemester(HttpServletRequest request, HttpServletResponse response, Teachers teacher) 
	        throws ServletException, IOException {
	    try {
	        int semester = Integer.parseInt(request.getParameter("semester"));
	        List<Student> students = teacherDao.getStudentsBySemester(semester);
	        List<Subject> subjects = teacherDao.getSubjectsBySemester(semester);
	        
	        response.setContentType("application/json");
	        response.setCharacterEncoding("UTF-8");
	        
	        StringBuilder json = new StringBuilder("{");
	        
	        // Add students array
	        json.append("\"students\":[");
	        for (int i = 0; i < students.size(); i++) {
	            Student student = students.get(i);
	            json.append("{")
	                .append("\"studentId\":").append(student.getStudentId()).append(",")
	                .append("\"name\":\"").append(student.getName()).append("\",")
	                .append("\"rollNumber\":\"").append(student.getRollNumber()).append("\"")
	                .append("}");
	            if (i < students.size() - 1) {
	                json.append(",");
	            }
	        }
	        json.append("],");
	        
	        // Add subjects array
	        json.append("\"subjects\":[");
	        for (int i = 0; i < subjects.size(); i++) {
	            Subject subject = subjects.get(i);
	            json.append("{")
	                .append("\"subjectId\":").append(subject.getSubjectId()).append(",")
	                .append("\"subjectName\":\"").append(subject.getSubjectName()).append("\",")
	                .append("\"subjectCode\":\"").append(subject.getSubjectCode()).append("\"")
	                .append("}");
	            if (i < subjects.size() - 1) {
	                json.append(",");
	            }
	        }
	        json.append("]}");
	        
	        response.getWriter().write(json.toString());
	    } catch (Exception e) {
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
	    }
	}
   
   private void handleStudentsPage(HttpServletRequest request, HttpServletResponse response, Teachers teacher) 
            throws ServletException, IOException {
        try {
            List<Student> students = teacherDao.getStudentsByDepartment(teacher.getDepartment());
            request.setAttribute("students", students);
            request.getRequestDispatcher("/TeacherStudents.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error loading student data: " + e.getMessage());
        }
    }

   
   private void handleGetMarksBySemester(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    try {
	        int semester = Integer.parseInt(request.getParameter("semester"));
	        String subjectIdParam = request.getParameter("subjectId");
	        
	        List<Mark> marks;
	        if (subjectIdParam != null && !subjectIdParam.isEmpty()) {
	            int subjectId = Integer.parseInt(subjectIdParam);
	            marks = teacherDao.getMarksBySemesterAndSubject(semester, subjectId);
	        } else {
	            marks = teacherDao.getMarksWithDetailsBySemester(semester);
	        }
	        
	        response.setContentType("application/json");
	        response.setCharacterEncoding("UTF-8");
	        
	        StringBuilder json = new StringBuilder("[");
	        for (int i = 0; i < marks.size(); i++) {
	            Mark mark = marks.get(i);
	            json.append("{")
	                .append("\"markId\":").append(mark.getMarkId()).append(",")
	                .append("\"studentId\":").append(mark.getStudentId()).append(",")
	                .append("\"studentName\":\"").append(mark.getStudentName()).append("\",")
	                .append("\"rollNumber\":\"").append(mark.getRollNumber()).append("\",")
	                .append("\"subjectId\":").append(mark.getSubjectId()).append(",")
	                .append("\"subjectName\":\"").append(mark.getSubjectName()).append("\",")
	                .append("\"subjectCode\":\"").append(mark.getSubjectCode()).append("\",")
	                .append("\"examType\":\"").append(mark.getExamType()).append("\",")
	                .append("\"marksObtained\":").append(mark.getMarksObtained()).append(",")
	                .append("\"totalMarks\":").append(mark.getTotalMarks()).append(",")
	                .append("\"percentage\":").append(String.format("%.2f", mark.getPercentage()))
	                .append("}");
	            if (i < marks.size() - 1) {
	                json.append(",");
	            }
	        }
	        json.append("]");
	        
	        response.getWriter().write(json.toString());
	    } catch (Exception e) {
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
	    }
	}
   
   private void loadAttendance(HttpServletRequest request, Teachers teacher) {
    List<Subject> subjects = teacherDao.getAllSubjects(); // Changed from getTeacherSubjects
    request.setAttribute("subjects", subjects);
    
    // Set current date as default
    String currentDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
    request.setAttribute("selectedDate", currentDate);
}
   
   private void loadMarks(HttpServletRequest request, Teachers teacher) {
    List<Subject> subjects = teacherDao.getAllSubjects();
    request.setAttribute("subjects", subjects);
    
    // Get semester parameter if provided
    String semesterParam = request.getParameter("semester");
    if (semesterParam != null && !semesterParam.isEmpty()) {
        try {
            int semester = Integer.parseInt(semesterParam);
            List<Mark> marks = teacherDao.getMarksWithDetailsBySemester(semester);
            List<Student> students = teacherDao.getStudentsBySemester(semester);
            List<Subject> semesterSubjects = teacherDao.getSubjectsBySemester(semester);
            
            request.setAttribute("marks", marks);
            request.setAttribute("students", students);
            request.setAttribute("semesterSubjects", semesterSubjects);
            request.setAttribute("selectedSemester", semester);
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }
}  

   private void loadSubjects(HttpServletRequest request, Teachers teacher) {
        List<Subject> subjects = teacherDao.getTeacherSubjects(teacher.getTeacherId());
        request.setAttribute("subjects", subjects);
    }
    
    private void handleStudentDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Student> students = teacherDao.getAllStudents();
        
        // Convert to JSON and send response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Create JSON array of students
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < students.size(); i++) {
            Student student = students.get(i);
            json.append("{")
                .append("\"studentId\":\"").append(student.getStudentId()).append("\",")
                .append("\"name\":\"").append(student.getName()).append("\",")
                .append("\"rollNumber\":\"").append(student.getRollNumber()).append("\",")
                .append("\"email\":\"").append(student.getEmail()).append("\",")
                .append("\"phone\":\"").append(student.getPhone()).append("\",")
                .append("\"department\":\"").append(student.getDepartment()).append("\",")
                .append("\"semester\":\"").append(student.getSemester()).append("\"")
                .append("}");
            if (i < students.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        
        response.getWriter().write(json.toString());
    }
    
    
    private void handleAttendanceUpdate(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    try {
        int semester = Integer.parseInt(request.getParameter("semester"));
        String dateStr = request.getParameter("date");
        String attendanceDataJson = request.getParameter("attendanceData");
        
        Date date = Date.valueOf(dateStr);
        
        // Parse attendance data and create list of AttendanceRecord objects
        List<TeacherDao.AttendanceRecord> attendanceRecords = parseAttendanceData(attendanceDataJson, date);
        
        // Use batch update method
        boolean success = teacherDao.updateAttendanceBatch(attendanceRecords);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            String jsonResponse = "{\"success\":true,\"message\":\"Attendance saved successfully\",\"updated\":" + attendanceRecords.size() + "}";
            response.getWriter().write(jsonResponse);
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Failed to save attendance\"}");
        }
        
    } catch (Exception e) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
    }
}

// Helper method to parse attendance data
private List<TeacherDao.AttendanceRecord> parseAttendanceData(String attendanceDataJson, Date date) {
    List<TeacherDao.AttendanceRecord> records = new ArrayList<>();
    
    try {
        // Remove brackets and split by record
        attendanceDataJson = attendanceDataJson.replace("[", "").replace("]", "");
        String[] recordStrings = attendanceDataJson.split("},\\{");
        
        for (String recordStr : recordStrings) {
            recordStr = recordStr.replace("{", "").replace("}", "");
            String[] fields = recordStr.split(",");
            
            int studentId = 0, subjectId = 0;
            String status = "";
            
            for (String field : fields) {
                String[] keyValue = field.split(":");
                if (keyValue.length == 2) {
                    String key = keyValue[0].replace("\"", "").trim();
                    String value = keyValue[1].replace("\"", "").trim();
                    
                    switch (key) {
                        case "studentId":
                            studentId = Integer.parseInt(value);
                            break;
                        case "subjectId":
                            subjectId = Integer.parseInt(value);
                            break;
                        case "status":
                            status = value;
                            break;
                    }
                }
            }
            
            if (studentId > 0 && subjectId > 0 && !status.isEmpty()) {
                records.add(new TeacherDao.AttendanceRecord(studentId, subjectId, date, status));
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    return records;
}

// Add this method to load existing attendance data when editing
private void handleGetAttendanceData(HttpServletRequest request, HttpServletResponse response) 
    throws ServletException, IOException {
    try {
        int semester = Integer.parseInt(request.getParameter("semester"));
        String dateStr = request.getParameter("date");
        Date date = Date.valueOf(dateStr);
        
        List<Student> students = teacherDao.getStudentsBySemester(semester);
        List<Subject> subjects = teacherDao.getSubjectsBySemester(semester);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        StringBuilder json = new StringBuilder("{");
        
        // Add students array
        json.append("\"students\":[");
        for (int i = 0; i < students.size(); i++) {
            Student student = students.get(i);
            json.append("{")
                .append("\"studentId\":").append(student.getStudentId()).append(",")
                .append("\"name\":\"").append(student.getName()).append("\",")
                .append("\"rollNumber\":\"").append(student.getRollNumber()).append("\"")
                .append("}");
            if (i < students.size() - 1) {
                json.append(",");
            }
        }
        json.append("],");
        
        // Add subjects array
        json.append("\"subjects\":[");
        for (int i = 0; i < subjects.size(); i++) {
            Subject subject = subjects.get(i);
            json.append("{")
                .append("\"subjectId\":").append(subject.getSubjectId()).append(",")
                .append("\"subjectName\":\"").append(subject.getSubjectName()).append("\",")
                .append("\"subjectCode\":\"").append(subject.getSubjectCode()).append("\"")
                .append("}");
            if (i < subjects.size() - 1) {
                json.append(",");
            }
        }
        json.append("],");
        
        // Add existing attendance data
        json.append("\"attendanceData\":[");
        boolean first = true;
        for (Student student : students) {
            for (Subject subject : subjects) {
                String status = teacherDao.getAttendanceStatus(student.getStudentId(), subject.getSubjectId(), date);
                if (status != null) {
                    if (!first) json.append(",");
                    json.append("{")
                        .append("\"studentId\":").append(student.getStudentId()).append(",")
                        .append("\"subjectId\":").append(subject.getSubjectId()).append(",")
                        .append("\"status\":\"").append(status).append("\"")
                        .append("}");
                    first = false;
                }
            }
        }
        json.append("]}");
        
        response.getWriter().write(json.toString());
        
    } catch (Exception e) {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
    }
}


private void handleAddMarks(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    try {
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        int subjectId = Integer.parseInt(request.getParameter("subjectId"));
        String examType = request.getParameter("examType");
        double marksObtained = Double.parseDouble(request.getParameter("marksObtained"));
        double totalMarks = Double.parseDouble(request.getParameter("totalMarks"));
        
        boolean success = teacherDao.insertMarks(studentId, subjectId, examType, marksObtained, totalMarks);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            response.getWriter().write("{\"success\":true,\"message\":\"Marks added successfully\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Failed to add marks\"}");
        }
    } catch (Exception e) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
    }
}

private void handleUpdateMarks(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    try {
        int markId = Integer.parseInt(request.getParameter("markId"));
        double marksObtained = Double.parseDouble(request.getParameter("marksObtained"));
        double totalMarks = Double.parseDouble(request.getParameter("totalMarks"));
        
        boolean success = teacherDao.updateMarks(markId, marksObtained, totalMarks);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            response.getWriter().write("{\"success\":true,\"message\":\"Marks updated successfully\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Failed to update marks\"}");
        }
    } catch (Exception e) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
    }
}

private void handleDeleteMarks(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    try {
        int markId = Integer.parseInt(request.getParameter("markId"));
        
        boolean success = teacherDao.deleteMarks(markId);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        if (success) {
            response.getWriter().write("{\"success\":true,\"message\":\"Marks deleted successfully\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"message\":\"Failed to delete marks\"}");
        }
    } catch (Exception e) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
    }
}

protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.getRole().equals("teacher")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        if ("/teacher/attendance".equals(path)) {
            handleAttendanceUpdate(request, response);
        }
        
        switch(path) {
	        case "/teacher/addMarks":
	            handleAddMarks(request, response);
	            break;
	        case "/teacher/updateMarks":
	            handleUpdateMarks(request, response);
	            break;
	        case "/teacher/deleteMarks":
	            handleDeleteMarks(request, response);
	            break;
        }
    }
    
    @Override
    public void destroy() {
        if (teacherDao != null) {
            teacherDao.close();
        }
    }
}