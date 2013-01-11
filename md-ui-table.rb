dep 'md-ui-table' do
  package = 'md-ui-table'
  requires [ "npm", 
    "nodejs.bin", 
    "mongodb.managed",
    "md-package up to date".with(:package => package), 
    "rabbitmq-server running",
    "md-package setenv".with(:package => package, :key => "RABBIT_HOST", :value => "localhost"),
    "md-package setenv".with(:package => package, :key => "PORT", :value => "3000"),
    "md-package running".with(:package => package)
  ]
end

def md_ui_table_run_script_contents
  <<-rsc
#!/bin/sh
npm install
envdir env npm start
  rsc
end

