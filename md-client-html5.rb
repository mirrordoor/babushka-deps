dep 'md-client-html5', :web_hostname do
  web_hostname.default(md_client_html5_hostname)
  package = 'client-html5'
  requires [ 
    "md-package up to date".with(:package => package, :web => "web"), 
    "md-client-html5 dependencies installed",
    "hostname configured".with(:myhostname => md_client_html5_hostname),
    "nagey:vhost enabled.nginx".with(
      :domain => web_hostname,
      :vhost_type => "static",
      :path => md_web_dir(package),
      :nginx_prefix => "/usr/local/nginx",
      :domain_aliases => '',
      :force_https => 'no',
      :enable_https => 'no',
      :listen_host => "*"
    ),
    "nagey:running.nginx".with(:nginx_prefix => "/usr/local/nginx")
  ]
end

dep "md-client-html5 dependencies installed" do
  requires "bower installed"
  met? { File.exists? md_web_dir('client-html5')+"/components" }
  meet { shell "cd #{md_web_dir('client-html5')}; ./node_modules/bower/bin/bower install" }
end

dep "bower installed" do
  requires "npm"
  met? { File.exists? md_web_dir('client-html5')+"/node_modules/bower/" }
  meet { shell "cd #{md_web_dir('client-html5')}; npm install" }
end

dep "hostname configured", :myhostname do
  met? { shell?("cat /etc/hosts|grep #{myhostname}") || shell?("host #{myhostname}") }
  meet { sudo "echo '127.0.0.1 #{myhostname}' >> /etc/hosts" }
end

def md_client_html5_hostname 
  "mirrordoor.local"
end