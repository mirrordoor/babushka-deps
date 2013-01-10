# Shamelessly stolen from github.com/ivanvanderbyl & added mac support

dep('rabbitmq-server.managed') {
  requires {
    on :ubuntu, 'updated rabbitmq source'
  }
  
  installs {
    via :apt, 'rabbitmq-server' if Babushka::host.linux?
    via :brew, "rabbitmq" if Babushka::host.osx?
  }
  
  provides %w(rabbitmq-server rabbitmqctl)  
}

dep('updated rabbitmq source') {
  met? { File.exists? "/etc/apt/sources.list.d/rabbitmq.list"}
  meet {
    shell 'echo "deb http://www.rabbitmq.com/debian/ testing main" | sudo tee /etc/apt/sources.list.d/rabbitmq.list'
    shell 'wget -qO - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | sudo apt-key add -'
    shell 'sudo apt-get update'
  }
}

dep "rabbitmq-c.managed" do
  met? { shell? "ls /usr/local/Cellar/rabbitmq-c/0.2/lib/librabbitmq.dylib" }
end