dep 'redis' do
  requires 'redis.managed'
  requires 'redis.launchd'
  requires "redis-server.managed" if Babushka::host.linux?
end

dep 'redis.managed' do
  provides 'redis-benchmark', 'redis-check-aof', 'redis-check-dump', 'redis-cli', 'redis-server'
end

dep 'redis.launchd'


dep "redis-apt-repository" do
  met? { "/etc/apt/sources.list".p.grep /dotdeb/ }

  meet {
    sources = <<-SRC

# Dotdeb sources for up-to-date redis
deb http://packages.dotdeb.org squeeze all
deb-src http://packages.dotdeb.org squeeze all
    SRC

    sudo "echo '#{sources}' >> /etc/apt/sources.list"

    sudo "wget -P /tmp http://www.dotdeb.org/dotdeb.gpg"
    sudo "cat /tmp/dotdeb.gpg | apt-key add -"

    sudo "apt-get update"
  }
end

dep "redis-server.managed" do
  requires "redis-apt-repository"
end
