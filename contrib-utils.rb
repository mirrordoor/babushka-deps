dep "mongodb.managed" do
  provides "mongod"
end

dep "daemontools.managed" do
  provides "svc", "supervise", "svscan"
end

dep "user exists with password", :username, :password do
  home_dir_base = "/home"
  home_dir_base = "/Users" if Babushka::host.osx?
  requires [
    "benhoskings:user exists".with(username, home_dir_base), 
    "benhoskings:user exists with password".with(username, password)
  ]
end