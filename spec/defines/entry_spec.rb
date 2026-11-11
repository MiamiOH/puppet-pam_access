require 'spec_helper'

describe 'pam_access::entry' do
  let(:facts) do
    {
      os: {
        family: 'RedHat',
        name: 'Rocky',
        release: { full: '9.4', major: '9' },
      },
    }
  end

  let(:title) { 'mailman-cron' }

  context 'with an explicit user' do
    let(:params) { { user: 'mailman', origin: 'cron' } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_augeas('pam_access/user/+:mailman:cron/present')
    end
  end

  context 'with an explicit group' do
    let(:params) { { group: 'operators', origin: 'LOCAL' } }

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_augeas('pam_access/group/+:operators:LOCAL/present')
    end
  end

  context 'with both user and group' do
    let(:params) { { user: 'mailman', group: 'operators' } }

    it { is_expected.to compile.and_raise_error(%r{user and group cannot both be specified}) }
  end
end
