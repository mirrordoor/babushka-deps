host = Babushka::host

dep 'gcc' do
  requires "tap-gcc", "gcc46.managed" if host.osx?
  requires "gcc.managed" if host.linux?
end

dep "tap-gcc" do
  met? { shell? "brew info gcc46" }
  meet { shell "brew tap homebrew/versions" }
end

dep "gcc.managed"

dep "gcc46.managed" do
  provides "gcc-4.6"
end



dep 'binutils.managed' do
  requires "binutils-dev.managed" if host.linux?
  met? { shell? "ls /usr/bin/ld" }
end

dep "binutils-dev.managed" do
  met? { shell? "ls /usr/include/bfd.h" }
end

dep 'table.src' do
  requires 'gcc', 'binutils.managed', 'rabbit-dev', 'libjsoncpp0.managed', 'libjsoncpp-dev.managed', 'nagey:coreutils.managed', "md-package cloned".with(:package => "md-table")

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

dep "md-table clean" do
  shell "rm -rf #{md_bin_dir('md-table')}"
  requires "md-table"
end

dep "md-table" do
  package = 'md-table'
  requires [ 
    "md-package up to date".with(:package => package, :web => 'no'),
    "rabbitmq-server running",
    "md-package setenv".with(:package => package, :key => "LOCAL", :value => "/usr/local"),
    "md-table built".with(:package => package),
    "md-package running".with(:package => package)
  ]
end


dep "md-table built", :package do
  requires 'gcc', 'binutils.managed', 'rabbitmq-dev', 'libjsoncpp0.managed', 'libjsoncpp-dev.managed', 'nagey:coreutils.managed'

  env_var = {}
  
  env_var['LOCAL'] = md_bin_dir(package)+"/"
  
  if host.linux?
    env_var['LIBBFD'] = "-lbfd"
    env_var['STD'] = "-std=c++0x"
    env_var['WERROR'] = "-Werror"
  end
  
  if host.osx?
    env_var['LIBBFD'] = ""
    env_var['STD'] = ""
    env_var['WERROR'] = ""
  end    
  
  env_var = env_var.map  { |x,i| "export #{x}='#{i}'" }
  env_var = env_var.join ';'
  
  something = false
  
  met? { something }
  meet do
    log_shell "clean", "#{env_var}; cd #{md_src_dir(package)}; make clean"
    log_shell "build", "#{env_var}; cd #{md_src_dir(package)}; make"
    Babushka::SrcHelper.install_src! "#{env_var}; cd #{md_src_dir(package)}; make install"
    log_shell "final install", "mv #{md_bin_dir(package)}/bin/* #{md_bin_dir(package)}/"
    log_shell "Starting Tables", "cd #{md_bin_dir('md-table')}; ./sometables.sh"
    something = true
  end
  
end


def md_table_run_script_contents
  <<-rsc
#!/bin/sh
./supervise.sh ./tblsrv
  rsc
end