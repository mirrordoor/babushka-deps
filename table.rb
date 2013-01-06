host = Babushka::host

dep 'table.src' do
  requires 'gcc', 'rabbitmq-server', 'coreutils', 'doc'

  source "git@github.com:/mirrordoor/md-table"
 
  provides 'table >= 0.1.0'
  configure_env "LIBBFD='-lbfd'" if host.linux?
  configure_env "STD='-std=c++0x'" if host.linux?
  configure_env "WERROR='-Werror'" if host.linux?
  
  met? { `/usr/local/mirrordoor/md-table/table --version`.include? "0.1.0"}

end