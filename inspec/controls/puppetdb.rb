control 'puppetdb' do
  title ''
  impact 1.0
  desc ''

  describe package('puppetdb') do
    it { should be_installed }
  end

  describe service('puppetdb') do
    it { should be_enabled }
    it { should be_running }
  end
end
