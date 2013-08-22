dep "mysql" do
  if Babushka::host.osx?
    requires "mysql.managed"
    met? do
      shell? "launchctl list|grep mysql"
    end
    meet do 
      log_shell "Setting up MySQL for HomeBrew", "unset TMPDIR; mysql_install_db --verbose --user=`whoami` --basedir=\"$(brew --prefix mysql)\" --datadir=/usr/local/var/mysql --tmpdir=/tmp"
      log_shell "Linking MySQL init script", "ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents"
      log_shell "Starting MySQL", "launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    end
  else
    requires "mysql-server.managed"
  end
end

dep "mysql-server.managed" do
  provides "mysqld"
end

dep "mysql.managed"