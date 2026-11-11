# Class: pam_access
#
# Manage entries in /etc/security/access.conf and optionally configure PAM
# to load pam_access.so.
#
# @param ensure Whether the PAM access configuration is enabled or disabled.
# @param manage_pam Whether this module manages PAM integration.
# @param enable_pamaccess_flags Arguments passed to authconfig on legacy
#   RedHat-family systems when enabling pam_access.
# @param disable_pamaccess_flags Arguments passed to authconfig on legacy
#   RedHat-family systems when disabling pam_access.
# @param entries Hash of pam_access::entry resources keyed by resource title.
class pam_access (
  Enum['present', 'absent'] $ensure,
  Boolean $manage_pam,
  Array[String] $enable_pamaccess_flags,
  Array[String] $disable_pamaccess_flags,
  Hash $entries,
) {
  if $facts['os']['name'] == 'Amazon' {
    if versioncmp($facts['os']['release']['major'], '2') < 0 {
      fail("The ${module_name} module does not support Amazon Linux versions older than 2.")
    }
  } elsif $facts['os']['family'] == 'RedHat' {
    if versioncmp($facts['os']['release']['major'], '6') < 0 {
      fail("The ${module_name} module requires RedHat-family version 6 or newer.")
    }
  } elsif $facts['os']['family'] != 'Debian' {
    fail("The ${module_name} module does not support ${facts['os']['name']} (${facts['os']['release']['full']}).")
  }

  file { '/etc/security/access.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  if $manage_pam {
    anchor { 'pam_access::begin': }
    -> class { 'pam_access::pam':
      require => File['/etc/security/access.conf'],
    }
    -> anchor { 'pam_access::end': }
  }

  create_resources('pam_access::entry', $entries)
}
