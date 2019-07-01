package [=PackageName].security;

import com.fasterxml.jackson.databind.ObjectMapper;
import [=PackageName].application.Authorization.Users.Dto.LoginUserInput;

import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.Authorization.Roles.IRolesManager;
import [=PackageName].domain.model.RolesEntity;
import [=PackageName].domain.Authorization.Roles.RolesManager;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.ldap.userdetails.LdapUserDetailsImpl;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.FilterChain;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Collectors;


public class JWTAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    IRolesManager _roleManager;

    private AuthenticationManager authenticationManager;

    public JWTAuthenticationFilter(AuthenticationManager authenticationManager) {
        this.authenticationManager = authenticationManager;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest req,
                                                HttpServletResponse res) throws AuthenticationException {
        try {
            System.out.println("I am here ...");
            LoginUserInput creds = new ObjectMapper()
                    .readValue(req.getInputStream(), LoginUserInput.class);

            return authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            creds.getUserName(),
                            creds.getPassword(),
                            new ArrayList<>())
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest req,
                                            HttpServletResponse res,
                                            FilterChain chain,
                                            Authentication auth) throws IOException, ServletException {


        // We cannot autowire RolesManager, but need to use the code below to set it
        if(_roleManager==null){
            ServletContext servletContext = req.getServletContext();
            WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
            _roleManager = webApplicationContext.getBean(RolesManager.class);
        }

        Claims claims = Jwts.claims();
        claims.put("scopes", (convertToPrivilegeAuthorities(auth.getAuthorities())).stream().map(s -> s.toString()).collect(Collectors.toList()));
        //claims.put("scopes", (auth.getAuthorities().stream().map(s -> s.toString()).collect(Collectors.toList())));

        if (auth != null) {
            if (auth.getPrincipal() instanceof org.springframework.security.core.userdetails.User) {
                claims.setSubject(((User) auth.getPrincipal()).getUsername());
            } else if (auth.getPrincipal() instanceof LdapUserDetailsImpl) {
                claims.setSubject(((LdapUserDetailsImpl) auth.getPrincipal()).getUsername());
            }

            else {
                throw new IllegalStateException("Unkown type of UserDetailsObject");
            }
        }

        claims.setExpiration(new Date(System.currentTimeMillis() + SecurityConstants.EXPIRATION_TIME));
        String token = Jwts.builder()
                .setClaims(claims)
                .signWith(SignatureAlgorithm.HS512, SecurityConstants.SECRET.getBytes())
                .compact();
        res.addHeader(SecurityConstants.HEADER_STRING, SecurityConstants.TOKEN_PREFIX + token);
        res.setContentType("application/json");

        PrintWriter out = res.getWriter();
        out.println("{");
        out.println("\"token\":" + "\"" + SecurityConstants.TOKEN_PREFIX + token + "\"");
        out.println("}");
        out.close();


//        String responseToClient= "{"+ "token:"+ TOKEN_PREFIX + token + "}";
//        res.getWriter().write(responseToClient);
        //res.getWriter().flush();
    }

    private List<GrantedAuthority> convertToPrivilegeAuthorities(Collection<? extends GrantedAuthority> authorities) {

        List<GrantedAuthority> currentlistAuthorities = new ArrayList<GrantedAuthority>();
        currentlistAuthorities.addAll(authorities);

        List<GrantedAuthority> newlistAuthorities = new ArrayList<GrantedAuthority>();

        // Iterate through the list and check for ROLE_ authorities. We need to convert these into privileges and then remove duplicate privileges

        for (GrantedAuthority ga : currentlistAuthorities) {
            if (ga.getAuthority().startsWith("ROLE_")) {

                RolesEntity re = _roleManager.FindByRoleName(ga.getAuthority());
                Set<PermissionsEntity> spe = re.getPermissions();
                if(spe.size() != 0) {
                    for (PermissionsEntity pe : spe) {
                        SimpleGrantedAuthority authority = new SimpleGrantedAuthority(pe.getName());
                        newlistAuthorities.add(authority);
                    }
                }
            }

            else {

                newlistAuthorities.add(ga);
            }
        }
        return newlistAuthorities.stream()
                .distinct()
                .collect(Collectors.toList());

    }


}
