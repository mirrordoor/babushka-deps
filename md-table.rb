host = Babushka::host

dep 'table.src' do
  requires 'gcc', 'binutils.managed', 'rabbitmq-c.managed', 'libjsoncpp0.managed', 'libjsoncpp-dev.managed', 'librabbitmq-dev.managed', 'librabbitmq0.managed', 'nagey:coreutils.managed', "md-package cloned".with(:package => "md-table")

  source File.expand_path("~/src")
 
  provides 'table >= 0.1.0'
  configure_env "LIBBFD='-lbfd'" if host.linux?
  configure_env "STD='-std=c++0x'" if host.linux?
  configure_env "WERROR='-Werror'" if host.linux?

  configure_env "LIBBFD=" if host.osx?
  configure_env "STD=" if host.osx?
  configure_env "WERROR=" if host.osx?
  
  met? { `/usr/local/mirrordoor/md-table/table --version`.include? "0.1.0"}

end

dep "md-table" do
  package = 'md-table'
  requires [ 
    "md-package up to date".with(:package => package),
    "rabbitmq-server running",
    "md-package setenv".with(:package => package, :key => "LOCAL", :value => "/usr/local"),
    "md-table built",
    "md-package running".with(:package => package)
  ]
end

dep "md-table built" do
  requires 'gcc', 'binutils.managed', 'rabbitmq-c.managed', 'libjsoncpp0.managed', 'libjsoncpp-dev.managed', 'librabbitmq-dev.managed', 'librabbitmq0.managed', 'nagey:coreutils.managed'
  provides 'table >= 0.1.0'
  configure_env "LIBBFD='-lbfd'" if host.linux?
  configure_env "STD='-std=c++0x'" if host.linux?
  configure_env "WERROR='-Werror'" if host.linux?

  configure_env "LIBBFD=" if host.osx?
  configure_env "STD=" if host.osx?
  configure_env "WERROR=" if host.osx?
  
  something = false
  
  met? { something }
  meet do
    log_shell "clean", "make clean"
    log_shell "build", "make"
    Babushka::SrcHelper.install_src! "make install"
    something = true
  end
  
end
