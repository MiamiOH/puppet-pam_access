# Changelog

## 1.1.0

- Add Puppet 7/8 and stdlib 8/9 compatibility metadata.
- Add modern Linux OS support and authselect integration.
- Correct pam_access::entry user/group parameter types.
- Document all public parameters and enable documentation linting.
- Declare the `augeas_core` module dependency required by the `augeas` resources.
- Pin test fixtures to releases compatible with Puppet 7 and 8.
- Clarify the supported Puppet and stdlib version ranges.

2021-1-26 (1.0.3) Frank Luo
        * convert to pdk
        * fix spec tests to use augeas_core for puppet6

2020-08-24 (1.0.2) Brad Koby
        * Bump stdlib max
        * Remove pe requirement
        * Bump puppet version max

2016-10-05 (1.0.1) Chris Edester
        * Update meta files and fix spec tests etc.

2015-10-15 (1.0.0) Chris Edester
        * Released ver 1.0.0 to Github and The Forge

0.2.2:
    Fixes to work with groups

0.2.1:
    Specify position as an parameter to pam_access::entry
    Fix for adding first entry to empty file via position

0.2.0:
    General Clean up and improved structure to support other Platforms
    Rake/Lint/Spec improvements
    Accept entries as hash

0.1.0:
    Implemented a fix for dependency cycle and more efficient insertion of access.conf elements (thanks @FutureSharks!)

0.0.2:
    Specify `incl` and `lens` parameters to augeas resources for performance improvement.

0.0.1:
    Initial release.

## 1.2.0

- Exercise the existing anchor resources, PAM dispatcher classes, and Augeas
  entries in unit tests so resource coverage reflects the complete catalog.
- Move legacy authconfig flags into OS-specific Hiera data
