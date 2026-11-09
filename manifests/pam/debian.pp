# Class: pam_access::pam::debian
#
# Internal PAM integration for Debian-family systems.
class pam_access::pam::debian {
  pam { 'Set pam_access in login':
    ensure   => $pam_access::ensure,
    service  => 'login',
    type     => 'account',
    control  => 'required',
    module   => 'pam_access.so',
    position => 'after *[type="auth" and module="pam_group.so"]',
  }

  pam { 'Set pam_access in sshd':
    ensure   => $pam_access::ensure,
    service  => 'sshd',
    type     => 'account',
    control  => 'required',
    module   => 'pam_access.so',
    position => 'after module pam_nologin.so',
  }
}
