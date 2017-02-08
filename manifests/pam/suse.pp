# Class: pam_access::pam::suse
#
# Private class - Not to be used directly
# See README.md for usage information
#
# [Remember: No empty lines between comments and class definition]
class pam_access::pam::suse {

  pam { 'Set pam_access in common-account':
    ensure   => $pam_access::ensure,
    service  => 'common-account',
    type     => 'account',
    control  => 'required',
    module   => 'pam_access.so',
    position => 'after module pam_unix2.so',
  }

}
