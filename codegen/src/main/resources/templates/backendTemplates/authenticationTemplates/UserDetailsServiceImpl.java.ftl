package [=PackageName];

import [=PackageName].application.Authorization.Users.IUserAppService;
import [=PackageName].domain.model.PermissionsEntity;
import [=PackageName].domain.model.UsersEntity;
import [=PackageName].domain.IRepository.IUsersRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class UserDetailsServiceImpl implements UserDetailsService {

	public UserDetailsServiceImpl(IUserAppService userAppService) {
	}

	@Autowired
	private IUsersRepository usersRepository;


	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {

		UsersEntity applicationUser = usersRepository.findByUserName(userName);

		if (applicationUser == null) {
			throw new UsernameNotFoundException(userName);
		}

		List<String> permissions = getAllPermissions(applicationUser);
		List<GrantedAuthority> authorities = getGrantedAuthorities(permissions);

		return new User(applicationUser.getUserName(), applicationUser.getPassword(), authorities); // User class implements UserDetails Interface
	}


	private List<String> getAllPermissions(UsersEntity user) {


		List<String> permissions = new ArrayList<>();

        if (user.getRole() != null) {

			for (PermissionsEntity item : user.getRole().getPermissions()) {
				permissions.add(item.getName());
			}
        }

        if (user.getPermissions() != null) {
            for (PermissionsEntity item : user.getPermissions()) {
                permissions.add(item.getName());
            }
        }

        return permissions
				.stream()
				.distinct()
				.collect(Collectors.toList());
    }


	// Pass the results of getPermissions method above to the method below

	private List<GrantedAuthority> getGrantedAuthorities(List<String> permissions) {
		List<GrantedAuthority> authorities = new ArrayList<>();

		if (!permissions.isEmpty()) {
			for (String permission : permissions) {
				authorities.add(new SimpleGrantedAuthority(permission));
			}
		}
		return authorities;
	}
}
