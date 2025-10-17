# Class: pam_access::params
#
# Default parameters
#
# [Remember: No empty lines between comments and class definition]
class pam_access::params {

  if (($facts['os']['family'] == 'RedHat') and (versioncmp($facts['os']['release']['full'], '5') >= 0)) or (
    ($facts['os']['distro']['id'] == 'Amazon') and (versioncmp($facts['os']['release']['full'], '2') >= 0)
  ) {
    $enable_pamaccess_flags  = ['--enablelocauthorize', '--enablepamaccess']
    $disable_pamaccess_flags = ['--enablelocauthorize', '--disablepamaccess']
  } elsif ($facts['os']['family'] == 'Debian') and (
    (($facts['os']['distro']['id'] == 'Debian') and (versioncmp($facts['os']['release']['full'], '7') >= 0)) or
    (($facts['os']['distro']['id'] == 'Ubuntu') and (versioncmp($facts['os']['release']['full'], '10') >= 0))
  ) {
    $enable_pamaccess_flags  = []
    $disable_pamaccess_flags = []
  } else {
    fail("The ${module_name} module is not supported on a ${facts['os']['family']} based system with version ${facts['os']['release']['full']}.")
  }

}
