package [=PackageName].application.Authorization.Users.Dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

public class CreateUserInput {

    // We display only the mandatory fields in thE User DTO - we can certainly add additional optional fields
    // to DTO
    @Email(message = "Email Address should be valid ")
    @NotNull(message = "Email Address Should not be null")
    private String emailAddress;
    
    @NotNull(message = "First Name Should not be null")
    @Length(max = 32, message = "First Name must be less than 32 characters")
    private String firstName;
    
    @NotNull(message = "Last Name Should not be null")
    @Length(max = 32, message = "Last Name must be less than 32 characters")
    private String lastName;
    
    @NotNull(message = "User Name Should not be null")
    @Length(max = 32, message = "User Name must be less than 32 characters")
    private String userName;
    
    @NotNull(message = "IsActive Should not be null")
    private Boolean isActive;
    
    @NotNull(message = "Password Should not be null")
    private String password;
    
    private Long roleId;

    public CreateUserInput() {
    }
    
    public Long getRoleId() {
   	 return roleId;
    }

    public void setRoleId(Long roleId){
  		this.roleId = roleId;
  	}

    public String getPassword() {
        return password;
    }

    public void setPassword(String password){
        this.password = password;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }
}
