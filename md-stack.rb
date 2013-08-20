dep "md-stack" do
  requires [
    "md-handHistory-viewer",
    "md-handHistory-logger",
    "md-ui-table",
    "md-client-html5",
    "md-table",
    "haproxy"
  ]
end

dep "update md-stack" do
  requires [
    "md-stack",
    "md-table clean"
  ]
  
  sudo "killall -9 node"
  
end
