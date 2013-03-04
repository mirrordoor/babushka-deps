# Shamelessly stolen from github.com/ivanvanderbyl & added mac support

dep('rabbitmq-server.managed') {
  requires {
    on :ubuntu, 'updated rabbitmq source'
  }
  requires "usr local sbin in PATH", "usr local bin in PATH"
  
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

dep 'rabbitmq-dev' do
  requires "rabbitmq-c.managed" if Babushka::host.osx?
  requires "rabbitmq-dev linux" if Babushka::host.linux?
end

dep "rabbitmq-dev linux" do
  requires 'librabbitmq-dev.managed', 'librabbitmq0.managed'
end

dep "rabbitmq-c.managed" do
  met? { shell? "ls /usr/local/Cellar/rabbitmq-c/0.2/lib/librabbitmq.dylib" }
end

dep 'librabbitmq-dev.managed' do
  met? { shell? "ls /usr/lib/librabbitmq.so"}
end

dep 'librabbitmq0.managed' do
  met? { shell? "ls /usr/lib/librabbitmq.so.0" }
end


dep "rabbitmq-server running" do
  requires "rabbitmq-server launch script"
end

dep "rabbitmq-server launch script" do
  requires 'rabbitmq-server.managed' 
  on :linux do
    met? {
      raw_shell('initctl list | grep rabbitmq-server').stdout[/^rabbitmq-server\b/]
    }
    meet {
      render_erb 'rabbitmq/rabbitmq-server.init.conf.erb', :to => '/etc/init/rabbitmq-server.conf'
    }
  end
  on :osx do
    requires "usr local bin in root launchd path"
    met? { !sudo('launchctl list').split("\n").grep(/com\.rabbitmq\.server/).empty? }
    meet {
      render_erb 'rabbitmq/rabbitmq-server.launchd.erb', :to => '/Library/LaunchDaemons/com.rabbitmq.server.plist', :sudo => true, :comment => '<!--', :comment_suffix => '-->'
      sudo 'launchctl load -w /Library/LaunchDaemons/com.rabbitmq.server.plist'
    }
  end
end

dep "usr local sbin in PATH" do
  met? { (shell("echo $PATH") =~ /usr\/local\/sbin/) != nil }
  meet { 
    sudo "echo 'PATH=$PATH:/usr/local/sbin' >> /etc/profile"
    shell "export PATH=$PATH:/usr/local/sbin"
   }
end
  
dep "usr local bin in PATH" do
  met? { (shell("echo $PATH") =~ /usr\/local\/bin/) != nil }
  meet { 
    sudo "echo 'PATH=$PATH:/usr/local/bin' >> /etc/profile"
    shell "export PATH=$PATH:/usr/local/bin"
   }
end
