dep 'libjsoncpp0.managed' do
  met? { shell? "ls /usr/lib/libjsoncpp.so.0" }
end

dep 'libjsoncpp-dev.managed' do
  met? { shell? "ls /usr/lib/libjsoncpp.so" }
end