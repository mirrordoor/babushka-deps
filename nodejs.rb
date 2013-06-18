:nodepath = "/usr/local/nodejs"

dep 'nodejs.src', :version do
  requires "node_path"
  version.default!('0.10.11')
  source "http://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"
  provides "node ~> #{version}"
  prefix :nodepath
  met? { in_path? "node >= #{version}" }
end

dep "node_path" do
  met? { shell? "echo $PATH | grep #{:nodepath}" }
  meet { sudo "echo #{:nodepath} >> /etc/profile" }
end
  