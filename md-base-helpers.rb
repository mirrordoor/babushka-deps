
def md_name
  "mirrordoor"
end

def md_username
  shell 'whoami'
end

def md_password
  "foo"
end

def md_src_dir(app=nil)
  return File.expand_path "~/src/#{md_name}" if app.nil?
  File.expand_path "~/src/#{md_name}/#{app}" unless app.nil?
end

def md_bin_dir(app=nil)
  return "/usr/local/#{md_name}" if app.nil?
  "/usr/local/#{md_name}/#{app}" unless app.nil?
end

def md_web_dir(app=nil)
  "/var/www/mirrordoor/#{app}"
end

def md_git_url(app=nil)
  return "git@github.com:#{md_name}" if app.nil?
  "git@github.com:#{md_name}/#{app}.git" unless app.nil?
end

def md_run_script(app)
  md_bin_dir(app)+"/run"
end

def md_run_script_contents(app)
  send(app.to_str.tr("-","_")+"_run_script_contents")
end

def md_svscan_logfile
  date = `date "+%Y-%m-%d-%H-%M-%S"`.chomp
  "#{md_bin_dir}/svscan.#{date}.log"
end

def rsync_package(package, web=false)
  to_dir = md_bin_dir unless web
  to_dir = md_web_dir if web
  sudo "rsync -a --exclude=.git #{md_src_dir(package)} #{to_dir}"
end
