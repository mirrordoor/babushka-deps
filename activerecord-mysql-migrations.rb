dep "activerecord-mysql2-adapter.gem" do
  met? do 
    begin
      Gem.clear_paths
      require "activerecord-mysql2-adapter/version" 
    rescue Exception=>e
      false
    end
  end
end

dep "activerecord mysql migrations" do
  requires "mysql", "activerecord-mysql2-adapter.gem"
  log_shell "rebuild native extensions for adapter gem", "gem pristine activerecord-mysql2-adapter"
  log_shell "rebuild native extensions for mysql2", "gem pristine mysql2"
end