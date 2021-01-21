require 'spec_helper'

describe 'pam_access::entry', type => define do
  let(:facts) { { osfamily => 'RedHat', operatingsystemrelease => '7.1' } }
  let(:title) { 'mailman-cron' }

  let(:params) { { user => 'mailman', origin => 'cron' } }

  it { is_expected.to compile.with_all_deps }
end
