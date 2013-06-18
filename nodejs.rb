dep 'nodejs.src', :version do
  version.default!('0.10.11')
  source "http://nodejs.org/dist/v#{version}/node-v#{version}.tar.gz"
  provides "node ~> #{version}"
  prefix "/usr/local/nodejs"
  met? { in_path? "node >= #{version}" }
end