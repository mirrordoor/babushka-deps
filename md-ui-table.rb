dep 'md-ui-table' do
  package = 'md-ui-table'
  requires [ "npm", 
    "nodejs.bin", 
    "mongodb.managed",
    "md-package up to date".with(:package => package), 
    "md-package running".with(:package => package)
  ]
  met? { true }
end

def md_ui_table_run_script_contents
  <<-rsc
#!/bin/sh
npm install
npm start
  rsc
end

