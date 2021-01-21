require 'spec_helper'

describe 'pam_access', type => class do
  describe 'does stuff if os supported' do
    let(:facts) { { osfamily => 'RedHat', operatingsystemrelease => '7.1' } }
    let(:params) { { manage_pam => false } }

    it { is_epected.to compile.with_all_deps }

    it do
      is_epected.to contain_file('/etc/security/access.conf').with(
        its('owner') { is_epected.to eq 'root' },
        its('group') { is_epected.to eq 'root' },
        its('mode') { is_epected.to eq '0644' },
      )
    end

    describe 'execs authconfig-access' do
      let(:params) { { manage_pam => true } }

      it { is_epected.to compile.with_all_deps }

      it do
        is_epected.to contain_exec('authconfig-access').with(
          command => '/usr/sbin/authconfig --enablelocauthorize --enablepamaccess --update',
        )
      end
    end
  end
end
