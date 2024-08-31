package ge.freeuni.studentsplatformapp.security;

import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;

public class CustomUserDetails implements UserDetails {
    @Getter
    private Long id;
    private String email;
    @Getter
    private String displayName;
    private String hashedPassword;
    private Collection<? extends GrantedAuthority> authorities;

    public CustomUserDetails(Long id, String email, String displayName, String hashedPassword, Collection<? extends GrantedAuthority> authorities) {
        this.id = id;
        this.email = email;
        this.displayName = displayName;
        this.hashedPassword = hashedPassword;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return hashedPassword;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
