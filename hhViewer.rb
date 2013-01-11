dep 'md-handHistory-viewer' do
  package = 'md-handHistory-viewer'
  requires [ "npm", 
    "nodejs.bin", 
    "mongodb.managed", 
    "md-package up to date".with(:package => package), 
    "md-package running".with(:package => package)
  ]
end

def md_handHistory_viewer_run_script_contents
  <<-rsc
#!/bin/sh
npm install
npm start
  rsc
end

