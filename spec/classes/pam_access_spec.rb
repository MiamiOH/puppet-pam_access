require 'spec_helper'

describe 'pam_access' do
  context 'on RedHat 9' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'Rocky',
          release: { full: '9.4', major: '9' },
        },
      }
    end

    let(:params) { { manage_pam: false } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/etc/security/access.conf').with(
        owner: 'root',
        group: 'root',
        mode: '0644',
        ensure: 'file',
      )
    end
  end

  context 'on RHEL 8 with PAM management' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { full: '8.9', major: '8' },
        },
      }
    end

    it { is_expected.to compile.with_all_deps }

    # Exercise all resources in the existing anchor-based catalog structure.
    it { is_expected.to contain_anchor('pam_access::begin') }
    it { is_expected.to contain_anchor('pam_access::end') }
    it { is_expected.to contain_anchor('pam_access::pam::begin') }
    it { is_expected.to contain_anchor('pam_access::pam::end') }
    it { is_expected.to contain_class('pam_access::pam') }
    it { is_expected.to contain_class('pam_access::pam::redhat') }

    it do
      is_expected.to contain_exec('authselect-enable-pamaccess').with(
        command: '/usr/bin/authselect enable-feature with-pamaccess',
      )
    end
  end

  context 'on RHEL 7 with Hiera-provided authconfig defaults' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'RedHat',
          release: { full: '7.9', major: '7' },
        },
      }
    end

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_exec('authconfig-access').with(
        command: '/usr/sbin/authconfig --enablelocauthorize --enablepamaccess --update',
      )
    end
  end

  context 'on Debian 12' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: { full: '12.0', major: '12' },
        },
      }
    end

    let(:params) { { manage_pam: false } }

    it { is_expected.to compile.with_all_deps }
  end
end
