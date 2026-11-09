# Class: pam_access::pam
#
# Internal dispatcher for operating-system-specific PAM integration.
class pam_access::pam {
  case $facts['os']['family'] {
    'RedHat': {
      anchor { 'pam_access::pam::begin': } -> class { 'pam_access::pam::redhat': } -> anchor { 'pam_access::pam::end': }
    }
    'Debian': {
      anchor { 'pam_access::pam::begin': } -> class { 'pam_access::pam::debian': } -> anchor { 'pam_access::pam::end': }
    }
    default: {}
  }
}
