package [=PackageName].application.Authorization.Users.Dto;

import javax.validation.constraints.AssertTrue;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Length;

import java.sql.Date;


public class UpdateUserInput {

	@NotNull(message = "Id Should not be null")
    private Long id;
    
    @Email(message = "Email Address should be valid ")
    @NotNull(message = "Email Address Should not be null")
    private String emailAddress;
    
    @Length(max = 328, message = "Last Name must be less than 328 characters")
    private String emailConfirmationCode;
    
    @NotNull(message = "IsActive Should not be null")
    private Boolean isActive;
    
    @AssertTrue
    private Boolean isEmailConfirmed;
    
    @NotNull(message = "First Name Should not be null")
    @Length(max = 32, message = "First Name must be less than 32 characters")
    private String firstName;
    
    @Length(max = 128, message = "Last Name must be less than 128 characters")
    private String password;
    
    @Length(max = 328, message = "Last Name must be less than 328 characters")
    private String passwordResetCode;
    
    @Length(max = 32, message = "Last Name must be less than 32 characters")
    private String phoneNumber;
    private Long profilePictureId;
    private Boolean shouldChangePasswordOnNextLogin;
    
    @Length(max = 8000, message = "Last Name must be less than 8000 characters")
    private String signInToken;
    private Date signInTokenExpireTimeUtc;

    @NotNull(message = "Last Name Should not be null")
    @Length(max = 32, message = "Last Name must be less than 32 characters")
    private String lastName;

    @NotNull(message = "User Name Should not be null")
    @Length(max = 32, message = "User Name must be less than 32 characters")
    private String userName;

    private Boolean isLockoutEnabled;
    private Boolean isPhoneNumberConfirmed;
    private Date lastLoginTime;
    private Date lockoutEndDateUtc;
    private int accessFailedCount;
    
    private Long roleId;


  	public Long getRoleId() {
  		return roleId;
  	}

  	public void setRoleId(Long roleId){
  		this.roleId = roleId;
  	}

    public Long getId() {
        return id;
    }


    public void setId(Long id) {
        this.id = id;
    }

    public int getAccessFailedCount() {
        return accessFailedCount;
    }

    public void setAccessFailedCount(int accessFailedCount) {
        this.accessFailedCount = accessFailedCount;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getEmailConfirmationCode() {
        return emailConfirmationCode;
    }

    public void setEmailConfirmationCode(String emailConfirmationCode) {
        this.emailConfirmationCode = emailConfirmationCode;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    public Boolean getIsEmailConfirmed() {
        return isEmailConfirmed;
    }

    public void setIsEmailConfirmed(Boolean emailConfirmed) {
        isEmailConfirmed = emailConfirmed;
    }

    public Boolean getIsLockoutEnabled() {
        return isLockoutEnabled;
    }

    public void setIsLockoutEnabled(Boolean lockoutEnabled) {
        isLockoutEnabled = lockoutEnabled;
    }

   public Boolean getIsPhoneNumberEnabled() {
        return isPhoneNumberConfirmed;
    }

    public void setIsPhoneNumberConfirmed(Boolean phoneNumberConfirmed) {
        isPhoneNumberConfirmed = phoneNumberConfirmed;
    }

   public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public Date getLockoutEndDateUtc() {
        return lockoutEndDateUtc;
    }

    public void setLockoutEndDateUtc(Date lockoutEndDateUtc) {
        this.lockoutEndDateUtc = lockoutEndDateUtc;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
  
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPasswordResetCode() {
        return passwordResetCode;
    }

    public void setPasswordResetCode(String passwordResetCode) {
        this.passwordResetCode = passwordResetCode;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Long getProfilePictureId() {
        return profilePictureId;
    }

    public void setProfilePictureId(Long profilePictureId) {
        this.profilePictureId = profilePictureId;
    }

  //   @Basic
  //  @Column(name = "ShouldChangePasswordOnNextLogin", nullable = false)
    public Boolean isShouldChangePasswordOnNextLogin() {
        return shouldChangePasswordOnNextLogin;
    }

    public void setShouldChangePasswordOnNextLogin(Boolean shouldChangePasswordOnNextLogin) {
        this.shouldChangePasswordOnNextLogin = shouldChangePasswordOnNextLogin;
    }

    public String getSignInToken() {
        return signInToken;
    }

    public void setSignInToken(String signInToken) {
        this.signInToken = signInToken;
    }

    public Date getSignInTokenExpireTimeUtc() {
        return signInTokenExpireTimeUtc;
    }

    public void setSignInTokenExpireTimeUtc(Date signInTokenExpireTimeUtc) {
        this.signInTokenExpireTimeUtc = signInTokenExpireTimeUtc;
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
}
