dep 'md-client-html5' do
  package = 'client-html5'
  requires [ "npm", 
    "nodejs.bin", 
    "mongodb.managed",
    "benhoskings:nginx",
    "md-package up to date".with(:package => package)
  ]
  met? { true }
end

def client_html5_run_script_contents
  <<-rsc
#!/bin/sh
bower install
  rsc
end

