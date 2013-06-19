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

dep "svscan running" do
  requires "svscan startup script"
  meet :on => :linux do
    sudo 'initctl start svscan'
  end
  meet :on => :osx do
    log_error "launchctl should have already started svscan. Check /var/log/system.log for errors."
  end
end
