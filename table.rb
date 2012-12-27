dep 'table.src' do
  requires 'gcc', 'rabbitmq', 'coreutils', 'doc'

  source "git@github.com:/mirrordoor/md-table"
 
  provides 'table >= 0.1.0'

  configure_env "LIBBFD='-lbfd'" if host.linux?
  configure_env "STD='-std=c++0x'" if host.linux?
  configure_env "WERROR='-Werror'" if host.linux?
end