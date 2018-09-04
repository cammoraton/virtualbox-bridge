

control 'repos' do
  describe file('/tmp') do
    it { should exist }
  end
end
