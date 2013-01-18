dep "md-stack" do
  requires [
    "md-client-html5",
    "md-handHistory-viewer",
    "md-handHistory-logger",
    "md-ui-table"
  ]
end

dep "update md-stack" do
  requires "md-stack"
  
  sudo "killall -9 node"
  
end