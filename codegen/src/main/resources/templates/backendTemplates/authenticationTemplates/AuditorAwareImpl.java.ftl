package [=PackageName];

import org.springframework.data.domain.AuditorAware;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.core.env.Environment;
//import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
//import org.springframework.security.core.Authentication;
//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.security.core.authority.SimpleGrantedAuthority;
//import org.springframework.security.core.context.SecurityContextHolder;
//
//import java.util.ArrayList;
//import java.util.Arrays;
//import java.util.List;
import java.util.Optional;


public class AuditorAwareImpl implements AuditorAware<String> {

//    @Autowired
//    private Environment environment;

    public Optional<String> getCurrentAuditor() {


       return Optional.ofNullable("shb");

        // Note: The code below is used by bootstrap profile in order to populate the database tables with
        // initial data.
//        if(Arrays.stream(environment.getActiveProfiles()).anyMatch(
//                env -> (env.equalsIgnoreCase("bootstrap")) )) {
//            // Need to set the SecurityContextHolder so that AuditorAwareImpl does not set it to null because we are creating data without authentication
//            GrantedAuthority go = new SimpleGrantedAuthority("ROLE_ADMIN");
//            List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
//            authorities.add(go);
//            final Authentication authToken = new UsernamePasswordAuthenticationToken("sunil", "secret", authorities);
//            SecurityContextHolder.getContext().setAuthentication(authToken);
//
//        }
//            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//            if (authentication == null || !authentication.isAuthenticated()) {
//                return null;
//            }
//            return Optional.ofNullable(authentication.getName());

    }
    
}