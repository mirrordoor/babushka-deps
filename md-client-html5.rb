dep 'md-client-html5' do
  package = 'client-html5'
  requires [ 
    "md-package up to date".with(:package => package, :web => true), 
    "nagey:vhost configured.nginx".with(
      :domain => "mirrordoor.local",
      :vhost_type => "static",
      :path => md_web_dir(package),
      :nginx_prefix => "/usr/local/nginx",
      :domain_aliases => '',
      :force_https => 'no',
      :enable_https => 'no'
    ),
    "nagey:running.nginx".with(:nginx_prefix => "/usr/local/nginx")
  ]
end
