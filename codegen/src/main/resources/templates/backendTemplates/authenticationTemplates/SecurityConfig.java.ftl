package [=PackageName];

import org.springframework.beans.factory.annotation.Autowired;
<#if AuthenticationType == "ldap">
import org.springframework.core.env.Environment;
</#if>   
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
<#if AuthenticationType == "database" || AuthenticationType=="oidc">
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
</#if> 
import [=PackageName].security.JWTAuthenticationFilter;
import [=PackageName].security.JWTAuthorizationFilter;

import static [=PackageName].security.SecurityConstants.CONFIRM;
import static [=PackageName].security.SecurityConstants.REGISTER;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

<#if AuthenticationType == "database" || AuthenticationType=="oidc">
    @Autowired
    private UserDetailsServiceImpl userDetailsService;
</#if>   
<#if AuthenticationType == "ldap">
    @Autowired
	private Environment env;
</#if>   
    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http
                .cors()
                .and()
                .csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and()
                .authorizeRequests()
                .antMatchers("/v2/api-docs", "/configuration/ui", "/swagger-resources", "/configuration/security", "/swagger-ui.html", "/webjars/**", "/swagger-resources/configuration/ui", "/swagger-resources/configuration/security", "/browser/index.html#", "/browser/**").permitAll()
                .antMatchers(HttpMethod.POST, REGISTER).permitAll()
                .antMatchers(HttpMethod.POST, CONFIRM).permitAll()
                .anyRequest().authenticated()
                .and()
                .addFilter(new JWTAuthenticationFilter(authenticationManager()))
                .addFilter(new JWTAuthorizationFilter(authenticationManager()));
    }

    @Autowired
    public void configure(AuthenticationManagerBuilder auth) throws Exception {

<#if AuthenticationType == "database" || AuthenticationType == "oidc">
            auth
                    .userDetailsService(userDetailsService)
                    .passwordEncoder(new BCryptPasswordEncoder());
</#if>
<#if AuthenticationType == "ldap">
       auth
                .ldapAuthentication()
                .contextSource()
                .url(env.getProperty("fastCode.ldap.contextsourceurl"))
                .ldif(env.getProperty("fastCode.ldap.ldiffilename"))
                .managerDn(env.getProperty("fastCode.ldap.manager.dn"))
                .managerPassword(env.getProperty("fastCode.ldap.manager.password"))
                .and()
                .userSearchBase(env.getProperty("fastCode.ldap.usersearchbase"))
                .userSearchFilter(env.getProperty("fastCode.ldap.usersearchfilter"))
                .groupSearchBase(env.getProperty("fastCode.ldap.groupsearchbase"))
                .groupSearchFilter(env.getProperty("fastCode.ldap.groupsearchfilter"))
                .rolePrefix(env.getProperty("fastCode.ldap.roleprefix"));
</#if>
    }

}
