dep "client-html5 build" do
  requires "client-html5 updated", "client-html5 build-web", "client-html5 build-app"
end

dep "client-html5 build-web" do
  requires "grunt", "bower", "npm", "client-html5 build-web-task"
end

dep "client-html5 build-web-task" do 
  requires "grunt", "npm"
  shell "cd #{srcdir}/html; npm install && bower install && grunt && rm -rf #{webdir}/* && cp -pr #{srcdir}/html/dist/* #{webdir}"
end

dep "client-html5 build-app" do
  requires "npm", "nodejs.src", "client-html5 build-app-task"
end

dep "client-html5 build-app-task" do 
  sudo "cd #{srcdir}/app; killall -9 node; cp -pr #{srcdir}/app/* #{appdir}; npm install && npm start"
end

dep "npm" do
  requires "nagey:nodejs.src", "npm globals path"
end

dep "npm globals path" do
  met? { shell? "echo $PATH|grep npm; echo $PATH|grep nodejs" }
  meet { 
    sudo 'echo "PATH=$PATH:/usr/local/share/npm/bin:/usr/local/nodejs/bin" >> /etc/profile' 
  }
end

dep "grunt" do
  requires "npm", "phantomjs", "compass"
  met? { shell? "which grunt" }
  meet { sudo "npm install -g grunt-cli" }
end

dep "compass" do
  met? { shell? "gem list | grep -i compass" }
  meet { sudo "gem install compass" }
end

dep "bower" do
  requires "npm"
  met? { shell? "which bower" }
  meet { sudo "npm install -g bower" }
end

dep "phantomjs" do
  requires "npm"
  met? { shell? "which phantomjs" }
  meet { sudo "npm install -g phantomjs" }
end