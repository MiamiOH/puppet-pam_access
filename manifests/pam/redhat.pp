# Class: pam_access::pam::redhat
#
# Internal implementation for RedHat-family systems.
class pam_access::pam::redhat {
  $authconfig_flags = $pam_access::ensure ? {
    'present' => join($pam_access::enable_pamaccess_flags, ' '),
    'absent'  => join($pam_access::disable_pamaccess_flags, ' '),
  }
  $authconfig_update_cmd = "/usr/sbin/authconfig ${authconfig_flags} --update"
  $authconfig_test_cmd   = "/usr/sbin/authconfig ${authconfig_flags} --test"
  $authconfig_check_cmd  = "/usr/bin/test \"`${authconfig_test_cmd}`\" = \"`/usr/sbin/authconfig --test`\""

  exec { 'authconfig-access':
    command => $authconfig_update_cmd,
    unless  => $authconfig_check_cmd,
  }

  # Internal implementation for RedHat-family systems. RHEL 8 and later use
  # authselect; older releases use authconfig.
  # if ($facts['os']['name'] == 'Amazon' and versioncmp($facts['os']['release']['major'], '2023') < 0) or ($facts['os']['name'] != 'Amazon' and versioncmp($facts['os']['release']['major'], '8') < 0) {
  #   $authconfig_flags = $pam_access::ensure ? {
  #     'present' => join($pam_access::enable_pamaccess_flags, ' '),
  #     'absent'  => join($pam_access::disable_pamaccess_flags, ' '),
  #   }
  #   $authconfig_update_cmd = "/usr/sbin/authconfig ${authconfig_flags} --update"
  #   $authconfig_test_cmd   = "/usr/sbin/authconfig ${authconfig_flags} --test"
  #   $authconfig_check_cmd  = "/usr/bin/test \"`${authconfig_test_cmd}`\" = \"`/usr/sbin/authconfig --test`\""

  #   exec { 'authconfig-access':
  #     command => $authconfig_update_cmd,
  #     unless  => $authconfig_check_cmd,
  #     path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
  #   }
  # } else {
  #   if $pam_access::ensure == 'present' {
  #     exec { 'authselect-enable-pamaccess':
  #       command => '/usr/bin/authselect enable-feature with-pamaccess',
  #       unless  => '/usr/bin/authselect current | /usr/bin/grep -q with-pamaccess',
  #       path    => ['/usr/bin', '/bin'],
  #     }
  #   } else {
  #     exec { 'authselect-disable-pamaccess':
  #       command => '/usr/bin/authselect disable-feature with-pamaccess',
  #       onlyif  => '/usr/bin/authselect current | /usr/bin/grep -q with-pamaccess',
  #       path    => ['/usr/bin', '/bin'],
  #     }
  #   }
  # }
}
