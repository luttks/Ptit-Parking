package vn.bacon.parking.config;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.bacon.parking.domain.Account;
import vn.bacon.parking.domain.Staff;
import vn.bacon.parking.domain.Student;
import vn.bacon.parking.repository.AccountRepository;

import java.io.IOException;
import java.util.Collection;

public class CustomSuccessHandler implements AuthenticationSuccessHandler {

    private final RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
    private final AccountRepository accountRepository;

    public CustomSuccessHandler(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    protected String determineTargetUrl(final Authentication authentication) {
        final Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        for (final GrantedAuthority grantedAuthority : authorities) {
            String authorityName = grantedAuthority.getAuthority();
            if (authorityName.equals("ROLE_STUDENT") || authorityName.equals("ROLE_TEACHER")) {
                return "/";
            } else if (authorityName.equals("ROLE_ADMIN") || authorityName.equals("ROLE_EMPLOYEE")) {
                return "/admin";
            }
        }
        throw new IllegalStateException("No valid role found for user");
    }

    protected void clearAuthenticationAttributes(HttpServletRequest request, Authentication authentication) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);

        String username = authentication.getName();
        Account account = accountRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalStateException("User not found: " + username));
        String fullName = null;
        String avatar = null;

        if (account.getMaNV() != null) {
            Staff staff = account.getMaNV();
            session.setAttribute("isStaff", true);
            session.setAttribute("chucVu", staff.getChucVu());
            session.setAttribute("fullName", staff.getHoTen());
            session.setAttribute("avatar", staff.getAvatar());
        } else if (account.getMaSV() != null) {
            Student student = account.getMaSV();
            fullName = student.getHoTen();
            avatar = student.getAvatar();
        }

        if (fullName != null) {
            session.setAttribute("fullName", fullName);
        }
        if (avatar != null) {
            session.setAttribute("avatar", avatar);
        }
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        String targetUrl = determineTargetUrl(authentication);

        if (response.isCommitted()) {
            return;
        }

        redirectStrategy.sendRedirect(request, response, targetUrl);
        clearAuthenticationAttributes(request, authentication);
    }
}