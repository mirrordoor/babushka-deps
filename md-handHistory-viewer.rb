dep 'md-handHistory-viewer' do
  package = 'md-handHistory-viewer'
  requires [ "npm", 
    "nodejs.src", 
    "mongodb.managed", 
    "md-package up to date".with(:package => package, :web => 'no'), 
    "md-package setenv".with(:package => package, :key => "PORT", :value => "3002"),
    "md-package running".with(:package => package)
  ]
end

def md_handHistory_viewer_run_script_contents
  <<-rsc
#!/bin/sh
npm install
envdir env npm start
  rsc
end

