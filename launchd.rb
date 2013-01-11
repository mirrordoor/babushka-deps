dep "usr local bin in root launchd path" do
  requires "launchd.conf exists"
  met? { sudo("launchctl export|grep PATH|grep /usr/local/bin") != nil}
  meet do
    a = sudo "launchctl export|grep PATH"
    b = a.split ';'
    b[0].insert -2, ":/usr/local/bin:/usr/local/sbin"
    c = b[0].split '='
    sudo "launchctl setenv PATH #{c[1]}"
    sudo "echo #{b.join ';'} >> /etc/launchd.conf"
  end
end

def get_local_launchd_paths
  a = sudo "launchctl export|grep PATH"
  b = a.split ';'
  c = b[0].split '='
  c[1].slice!(0)
  c[1].slice!(-1)
  c[1]
end


dep "launchd.conf exists" do
  met? { shell? "ls -l /etc/launchd.conf" }
  meet { render_erb 'launchd/launchd.conf.erb', :to => '/etc/launchd.conf', :sudo => true, :comment => "#" }
end

dep "home set in root launchd env" do
  sudo "launchctl setenv HOME #{File.expand_path('~')}"
end