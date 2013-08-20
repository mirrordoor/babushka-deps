def haproxy_prefix
  return "" if Babushka::host.linux?
end

def haproxy_config
  return "/etc/haproxy/haproxy.cfg" if Babushka::host.linux?

dep "haproxy" do
  requires "haproxy.managed"
  met? { 
    Babushka::Renderable.new(haproxy_config).from?(dependency.load_path.parent / "haproxy/haproxy.cfg.erb")
  }
  meet {
	render_erb "haproxy/haproxy.cfg.erb", :to => haproxy_config, :sudo => true
  }
end

dep "haproxy.managed"