dep 'java' do
  requires 'default-jre.managed' if host.linux?
end

dep 'default-jre.managed'
  