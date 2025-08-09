package beans;

public class Admins {
    private int adminId;
    private int userId;
    private String name;
    private String email;
    private String phone;

    public Admins() {
    }

    public Admins(int adminId, int userId, String name, String email, String phone) {
        this.adminId = adminId;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phone = phone;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    @Override
    public String toString() {
        return "Admins{" +
                "adminId=" + adminId +
                ", userId=" + userId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Admins admins = (Admins) o;
        return adminId == admins.adminId &&
                userId == admins.userId &&
                name.equals(admins.name) &&
                email.equals(admins.email) &&
                phone.equals(admins.phone);
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(adminId, userId, name, email, phone);
    }
}