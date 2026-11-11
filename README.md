# pam_access

Manage rules in `/etc/security/access.conf` with Puppet and Augeas.

## Compatibility

- Puppet 7 and 8
- `puppetlabs/stdlib` 8.x and 9.x
- Red Hat Enterprise Linux, CentOS Stream, Rocky Linux, AlmaLinux and Oracle Linux 7–10
- Amazon Linux 2 and 2023
- Debian 10–13 and Ubuntu 18.04–26.04

PAM integration on RHEL-family 8+ and Amazon Linux 2023+ uses `authselect`.
Older RedHat-family releases use `authconfig`. Debian-family systems use the
`augeasproviders_pam` provider to manage PAM service files.

## Dependencies

- Puppet >= 7.0.0 < 9.0.0 (Puppet 7 and Puppet 8)
- `puppetlabs/stdlib` >= 8.0.0 < 10.0.0 (stdlib 8.x and 9.x)
- `puppetlabs/augeas_core` >= 1.3.0 < 2.0.0 (provides the `augeas` resource type)
- `herculesteam/augeasproviders_pam` >= 2.1.0 < 3.0.0 (provides the `pam` resource type)
- Augeas with the `Access.lns` lens

## Usage

```puppet
class { 'pam_access':
  manage_pam => true,
  entries    => {
    'mailman-cron' => {
      user   => 'mailman',
      origin => 'cron',
    },
  },
}

pam_access::entry { 'root-localonly':
  permission => '-',
  user       => 'root',
  origin     => 'ALL EXCEPT LOCAL',
}

pam_access::entry { 'lusers-revoke-access':
  ensure => 'absent',
  group  => 'lusers',
}
```

`user` and `group` are optional strings. Specify at most one. If neither is
supplied, the defined-resource title is used as the username.

`manage_pam` defaults to `true`. Set it to `false` if PAM stack integration
is managed elsewhere. On RHEL 8+ the module enables or disables the
`with-pamaccess` authselect feature; it does not select or replace the
system's authselect profile.

## Notes

Test authselect changes on a representative host before broad deployment.
Authselect may refuse to modify a host whose PAM configuration is not
currently managed by an authselect profile. Custom PAM stacks should be
managed explicitly and can use `manage_pam => false`.

## License

MIT
