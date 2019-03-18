package com.ninfinity.model;


import java.sql.Timestamp;
//import java.util.Objects;
public class TestEntity {
    private long id;
   
    private String emailAddress;    
    private String firstName;
    private String lastName;
    private boolean isActive;
   private Timestamp creationTime;

   
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

       public Timestamp getCreationtime() {
        return creationTime;
    }

    public void setCreationtime(Timestamp creationtime) {
        this.creationTime = creationtime;
    }

  

      public String getEmailaddress() {
        return emailAddress;
    }

    public void setEmailaddress(String emailaddress) {
        this.emailAddress = emailaddress;
    }
  
    public String getFirstname() {
        return firstName;
    }

    public void setFirstname(String firstname) {
        this.firstName = firstname;
    }

  
    public boolean isIsactive() {
        return isActive;
    }

    public void setIsactive(boolean isactive) {
        this.isActive = isactive;
    }

    public String getLastname() {
        return lastName;
    }

    public void setLastname(String lastname) {
        this.lastName = lastname;
    }

  

}
