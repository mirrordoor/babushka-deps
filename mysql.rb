dep "mysql" do
  requires "mysql.managed"
  met? do
    true
    if Babushka::host.osx?
      shell? "launchctl list|grep mysql"
    end
  end
  meet do 
    if Babushka::host.osx?
      log_shell "Setting up MySQL for HomeBrew", "unset TMPDIR; mysql_install_db --verbose --user=`whoami` --basedir=\"$(brew --prefix mysql)\" --datadir=/usr/local/var/mysql --tmpdir=/tmp"
      log_shell "Linking MySQL init script", "ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents"
      log_shell "Starting MySQL", "launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    end
  end
end
  

dep "mysql.managed"