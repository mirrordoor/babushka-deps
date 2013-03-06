dep "mysql.managed"

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
  requires "mysql.managed", "activerecord-mysql2-adapter.gem"
end