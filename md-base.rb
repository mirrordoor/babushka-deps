dep 'src-md dir available' do
  met? { File.exists? md_src_dir }
  meet { shell "mkdir -p ~/src/#{md_name}" }
end

dep "local-md dir available" do
  requires "local-md-dir exists", "local-md-dir owned by appropriate user"
end

dep "local-md-dir exists" do
  met? { File.exists? md_bin_dir }
  meet { sudo "mkdir -p #{md_bin_dir}" }
end

dep "local-md-dir owned by appropriate user" do
  requires "user exists with password".with(:username => md_username, :password => md_password)
  met? { shell("ls -l #{md_bin_dir}/..|grep #{md_name}").split(' ')[2] == md_username }
  meet { sudo "chown -R #{md_username} #{md_bin_dir}" }
end

dep "svscan md-bin-dir" do
  requires "daemontools.managed" 
  met? { shell("ps axu") =~ /svscan #{md_name}$/ }
  meet { shell "cd #{md_bin_dir}/..; svscan #{md_name} &> #{md_svscan_logfile} &" }
end


dep "md-package up to date", :package do
  requires [
    "md-package cloned".with(:package => package), 
    "local-md dir available", 
    "git"
  ]
  
  met? do
    shell "cd #{md_src_dir(package)}; git remote update"
    shell("cd #{md_src_dir(package)}; git status -uno -sb").grep(/behind/).length == 0
  end
  
  meet do
    log_shell "Updating Git Repository", "cd #{md_src_dir(package)}; git pull"
    rsync_package(package)
  end
  
end

dep "md-package cloned", :package do
  requires "src-md dir available", "git"
  
  src_dir = md_src_dir(package)
  git_url = md_git_url(package)
  
  met? { File.exists? "#{src_dir}/.git/config" }
  meet do
    shell "git clone #{git_url} #{src_dir}"
    rsync_package(package)
  end
end

dep "md-package running", :package do
  requires [
    "md-package run script".with(:package => package), 
    "svscan md-bin-dir"
  ]
end

dep "md-package run script", :package do
  requires "md-package run script exists".with(:package => package)
  
  run_script = md_run_script package
  
  met? { ((shell("ls -l #{run_script}").split(' ')[0][3]) == 120) }
  meet { shell "chmod u+x #{run_script}" }
end

dep "md-package run script exists", :package do
  run_script = md_run_script package
  run_script_contents = md_run_script_contents package
  met? { shell?("ls -l #{run_script}") }
  meet do
    script_handle = open run_script, "w+"
    script_handle.write run_script_contents
    script_handle.close
    shell "chmod u+x #{run_script}"
  end
end
