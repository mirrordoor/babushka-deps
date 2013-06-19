dep "md-stack" do
  requires [
    "md-handHistory-viewer",
    "md-handHistory-logger",
    "md-ui-table",
    "md-client-html5"
  ]
end

dep "update md-stack" do
  requires "md-stack"
  
  sudo "killall -9 node"
  
end