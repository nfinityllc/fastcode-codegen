package [=PackageName];

import [=PackageName].application.Authorization.User.IUserAppService;
import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.model.UserpermissionEntity;
import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.IRepository.IUserRepository;
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
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class UserDetailsServiceImpl implements UserDetailsService {

	public UserDetailsServiceImpl(IUserAppService userAppService) {
	}

	@Autowired
	private IUserRepository usersRepository;


	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {

		UserEntity applicationUser = usersRepository.findByUserName(userName);

		if (applicationUser == null) {
			throw new UsernameNotFoundException(userName);
		}

		List<String> permissions = getAllPermissions(applicationUser);
		List<GrantedAuthority> authorities = getGrantedAuthorities(permissions);

		return new User(applicationUser.getUserName(), applicationUser.getPassword(), authorities); // User class implements UserDetails Interface
	}


	private List<String> getAllPermissions(UserEntity user) {


		List<String> permissions = new ArrayList<>();

//        if (user.getRole() != null) {
//			for (PermissionEntity item : user.getRole().getPermissions()) {
//				permissions.add(item.getName());
//			}
//        }
//
//        if (user.getPermissions() != null) {
//            for (PermissionEntity item : user.getPermissions()) {
//                permissions.add(item.getName());
//            }
//        }
		
      if (user.getRole() != null) {
    	  Set<RolepermissionEntity> spe= user.getRole().getRolepermissionSet();
			for (RolepermissionEntity item : spe) {
				permissions.add(item.getPermission().getName());
			}
      }

      if (user.getUserpermissionSet() != null) {
    	  Set<UserpermissionEntity> upe=user.getUserpermissionSet();
          for (UserpermissionEntity item : upe) {
              permissions.add(item.getPermission().getName());
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
