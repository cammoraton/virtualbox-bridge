control 'postgresql' do
  title ''
  impact 1.0
  desc ''

  describe package('postgresql') do
    it { should be_installed }
  end

  describe service('postgresql') do
    it { should be_enabled }
    it { should be_running }
  end
end
