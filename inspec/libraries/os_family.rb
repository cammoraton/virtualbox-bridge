
# Quick and dirty way to differentiate
if File.exists?('/etc/redhat-release')
  $os_family = 'redhat'
else
  $os_family = 'debian'
end

$os_family.freeze
