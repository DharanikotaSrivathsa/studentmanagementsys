package beans;

import java.util.Objects;

public class Teachers {
    private int teacher_id;
    private int user_id;
    private String name;
    private String email;
    private String phone;
    private String department;
    private String qualification;
    private String date_of_joining;

    public Teachers() {
        super();
    }

    public Teachers(int teacher_id, int user_id, String name, String email, String phone, 
                   String department, String qualification, String date_of_joining) {
        super();
        this.teacher_id = teacher_id;
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.department = department;
        this.qualification = qualification;
        this.date_of_joining = date_of_joining;
    }

    // Getters and Setters
    public int getTeacherId() {
        return teacher_id;
    }

    public void setTeacherId(int teacher_id) {
        this.teacher_id = teacher_id;
    }

    public int getUserId() {
        return user_id;
    }

    public void setUserId(int user_id) {
        this.user_id = user_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getDate_of_joining() {
        return date_of_joining;
    }

    public void setDate_of_joining(String date_of_joining) {
        this.date_of_joining = date_of_joining;
    }

    @Override
    public int hashCode() {
        return Objects.hash(teacher_id, user_id, name, email, phone, department, qualification, date_of_joining);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null) return false;
        if (getClass() != obj.getClass()) return false;
        Teachers other = (Teachers) obj;
        return teacher_id == other.teacher_id && user_id == other.user_id 
                && Objects.equals(name, other.name) && Objects.equals(email, other.email)
                && Objects.equals(phone, other.phone) && Objects.equals(department, other.department)
                && Objects.equals(qualification, other.qualification) 
                && Objects.equals(date_of_joining, other.date_of_joining);
    }

    @Override
    public String toString() {
        return "Teacher [teacher_id=" + teacher_id + ", user_id=" + user_id + ", name=" + name 
                + ", email=" + email + ", phone=" + phone + ", department=" + department 
                + ", qualification=" + qualification + ", date_of_joining=" + date_of_joining + "]";
    }
}