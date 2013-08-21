dep 'md-users' do
  package = 'users'
  requires [ "npm", 
    "nodejs.src", 
    "mysql", 
    "md-package up to date".with(:package => package, :web => 'no'), 
    "md-package setenv".with(:package => package, :key => "RABBIT_HOST", :value => "localhost"),
    "md-package setenv".with(:package => package, :key => "PORT", :value => "4001"),
    "md-package setenv".with(:package => package, :key => "DB_TYPE", :value => "mysql"),
    "md-package setenv".with(:package => package, :key => "DB_USER", :value => "root"),
    "md-package setenv".with(:package => package, :key => "DB_NAME", :value => "lgp"),
    "md-package setenv".with(:package => package, :key => "DB_HOST", :value => "localhost"),
    "md-package setenv".with(:package => package, :key => "DB_PORT", :value => "3306"),
    "md-package setenv".with(:package => package, :key => "DB_PASS", :value => ""),
    "md-package setenv".with(:package => package, :key => "DB_POOL", :value => "true"),
    "md-package setenv".with(:package => package, :key => "DB_DEBUG", :value => "false"),
    "rabbitmq-server running",
    "md-package running".with(:package => package)
  ]
  met? { true }
end

def md_users_run_script_contents
  <<-rsc
#!/bin/sh
npm install
envdir env npm start
  rsc
end

def users_run_script_contents
	md_users_run_script_contents
end
