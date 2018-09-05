control 'puppetserver' do
  title ''
  impact 1.0
  desc ''

  describe package('puppetserver') do
    it { should be_installed }
  end

  describe service('puppetserver') do
    it { should be_enabled }
    it { should be_running }
  end
end
