# Define: pam_access::entry
#
# Manage one rule in /etc/security/access.conf.
#
# @param ensure Whether the rule is present or absent.
# @param permission Access decision: '+' allows and '-' denies.
# @param user Optional username. When set, the resource title is not used
#   as the username.
# @param group Optional group name. When set, the resource title is not used
#   as the group name.
# @param origin PAM access origin expression, such as LOCAL, ALL, a host,
#   network, or tty.
# @param position Whether a new rule is inserted before or after existing
#   rules. Defaults to before for allow rules and after for deny rules.
define pam_access::entry (
  Enum['present', 'absent'] $ensure = 'present',
  Enum['+', '-'] $permission = '+',
  Optional[String[1]] $user = undef,
  Optional[String[1]] $group = undef,
  String[1] $origin = 'LOCAL',
  Optional[Enum['after', 'before']] $position = undef,
) {
  include pam_access

  if $user != undef and $group != undef {
    fail('pam_access::entry: user and group cannot both be specified')
  }

  $identity = $user ? {
    undef   => $group ? {
      undef   => $title,
      default => $group,
    },
    default => $user,
  }
  $context = $group ? {
    undef   => 'user',
    default => 'group',
  }
  $real_position = $position ? {
    undef   => $permission ? {
      '+'     => 'before',
      default => 'after',
    },
    default => $position,
  }

  Augeas {
    context => '/files/etc/security/access.conf/',
    incl    => '/etc/security/access.conf',
    lens    => 'Access.lns',
  }

  if $pam_access::manage_pam {
    Augeas { notify => Class['pam_access::pam'] }
  }

  if $ensure == 'present' {
    if $real_position == 'after' {
      $changes = [
        "set access[last()+1] ${permission}",
        "set access[last()]/${context} ${identity}",
        "set access[last()]/origin ${origin}",
      ]
    } else {
      $changes = [
        'ins access before access[1]',
        "set access[1] ${permission}",
        "set access[1]/${context} ${identity}",
        "set access[1]/origin ${origin}",
      ]
    }

    augeas { "pam_access/${context}/${permission}:${identity}:${origin}/present":
      changes => $changes,
      onlyif  => "match access[. = '${permission}'][${context} = '${identity}'][origin = '${origin}'] size == 0",
    }
  } else {
    augeas { "pam_access/${context}/${permission}:${identity}:${origin}/absent":
      changes => [
        "rm access[. = '${permission}'][${context} = '${identity}'][origin = '${origin}']",
      ],
      onlyif  => "match access[. = '${permission}'][${context} = '${identity}'][origin = '${origin}'] size > 0",
    }
  }
}
