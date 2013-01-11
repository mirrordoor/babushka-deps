dep 'md-handHistory-logger' do
  package = 'md-handHistory-logger'
  requires [ "npm", 
    "nodejs.bin", 
    "mongodb.managed", 
    "md-package up to date".with(:package => package), 
    "md-package setenv".with(:package => package, :key => "RABBIT_HOST", :value => "localhost"),
    "rabbitmq-server running",
    "md-package running".with(:package => package)
  ]
  met? { true }
end

def md_handHistory_logger_run_script_contents
  <<-rsc
#!/bin/sh
npm install
envdir env npm start
  rsc
end

