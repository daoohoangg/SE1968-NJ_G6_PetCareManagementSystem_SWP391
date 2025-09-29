package controller;

public class Service {
    private String name;
    private String email;
    private String password;
    public Service(String name, String email, String password) {
        this.name = name;
    }
    private  void setName(String name) {
        this.name = name;
    }
    private void setEmail(String email) {
        this.email = email;
    }
}
