dep 'svscan startup script' do
  requires 'daemontools.managed'
  on :linux do
    met? {
      raw_shell('initctl list | grep svscan').stdout[/^svscan\b/]
    }
    meet {
      render_erb 'svscan/svscan.init.conf.erb', :to => '/etc/init/svscan.conf'
    }
  end
  on :osx do
    requires "usr local bin in root launchd path"
    met? { !sudo('launchctl list').split("\n").grep(/to\.yp\.cr\.svscan/).empty? }
    meet {
      render_erb 'svscan/svscan.launchd.erb', :to => '/Library/LaunchDaemons/to.yp.cr.svscan.plist', :sudo => true, :comment => '<!--', :comment_suffix => '-->'
      sudo 'launchctl load -w /Library/LaunchDaemons/to.yp.cr.svscan.plist'
    }
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

dep "launchd.conf exists" do
  met? { shell? "ls -l /etc/launchd.conf" }
  meet { render_erb 'svscan/launchd.conf.erb', :to => '/etc/launchd.conf', :sudo => true, :comment => "#" }
end
