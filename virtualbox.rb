deb 'virtualbox' do 
  requires 'VirtualBox.app' if Babushka::host.osx?
  requires 'virtualbox.managed' if Babushka::host.linux?
end

dep 'virtualbox.managed'

dep 'VirtualBox.app' do
  source 'http://download.virtualbox.org/virtualbox/4.2.6/VirtualBox-4.2.6-82870-OSX.dmg'
  print Babushka::host.flavour
end

