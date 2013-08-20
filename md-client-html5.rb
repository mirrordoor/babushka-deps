dep 'md-client-html5', :web_hostname, :listen_port do
  web_hostname.default(md_client_html5_hostname)
  listen_port.default(80)
  package = 'client-html5'
  requires [ 
    "md-package up to date".with(:package => package, :web => "web"), 
    "md-client-html5 dependencies installed",
    "hostname configured".with(:myhostname => md_client_html5_hostname),
    "nagey:vhost enabled.nginx".with(
      :domain => web_hostname,
      :vhost_type => "websocket_proxy",
      :path => md_web_dir(package)+"/app",
      :nginx_prefix => "/usr/local/nginx",
      :domain_aliases => '',
      :force_https => 'no',
      :enable_https => 'no',
      :listen_host => "*",
      :listen_port => listen_port,
      :proxy_port => 3000,
      :proxy_host => "localhost"
    ),
    "nagey:running.nginx".with(:nginx_prefix => "/usr/local/nginx")
  ]
end

dep "md-client-html5 dependencies installed" do
  requires "bower installed", "grunt", "compass", "bower", "phantomjs"
  met? { File.exists? md_web_dir('client-html5')+"/app/components" }
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
