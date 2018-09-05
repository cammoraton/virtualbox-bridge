control 'repos' do
  title ''
  impact 1.0
  desc ''

  if ['redhat'].include?($os_family)

  elsif ['debian'].include?($os_family)
    describe apt('http://apt.puppetlabs.com') do
      it { should exist }
      it { should be_enabled }
    end
  end
end
