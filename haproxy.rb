def haproxy_prefix
  return "" if Babushka::host.linux?
end

def haproxy_config
  return "/etc/haproxy/haproxy.cfg" if Babushka::host.linux?
end

def haproxy_defaults
  return "/etc/defaults/haproxy" if Babushke::host.linux?
end

dep "haproxy" do
  requires "haproxy.managed"
  met? { 
    Babushka::Renderable.new(haproxy_config).from?(dependency.load_path.parent / "haproxy/haproxy.cfg.erb") and
    Babushka::Renderable.new(haproxy_defaults).from?(dependency.load_path.parent / "haproxy/haproxy.defaults.erb")
  }
  meet {
	render_erb "haproxy/haproxy.cfg.erb", :to => haproxy_config, :sudo => true
	render_erb "haproxy/haproxy.defaults.erb", :to => haproxy_defaults, :sudo => true	
  }
end

dep "haproxy.managed"