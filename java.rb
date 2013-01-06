dep 'java' do
  requires_when_unmet {
    on :osx, 'java-mac'
    on :ubuntu, 'default-jre.managed'
  } 
  met? { `java -version`.include? "java version" }
  meet { }
end

dep 'default-jre.managed'

dep 'java-mac'
  