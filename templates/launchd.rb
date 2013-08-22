require 'fileutils'

meta :launchd, :for => :osx do
  accepts_value_for :destination, "/Library/LaunchDaemons"

  template {
    def plist
      brew_path = Babushka::BrewHelper.brew_path_for(basename)
      Dir["#{brew_path}/*.plist"].first.p.basename.to_s
    end

    def plist_path
      (destination / plist)
    end

    pltemplate = Babushka::BrewHelper.brew_path_for(basename);

    requires 'launchd plist copied'.with(
      :package => basename,
      :plist => plist,
      :plist_templ => pltemplate,
      :destination => destination
    )

    met? {
      sudo('launchctl list')[basename]
    }
    meet {
      log sudo "launchctl load -w '#{plist_path}'"
    }
  }
end

dep 'launchd plist copied', :package, :plist, :destination, :plist_templ, :for => :osx do
  def brew_path
     #Babushka::BrewHelper.brew_path_for(package)
     plist_templ
  end

  def plist_template
    (brew_path / plist)
  end

  def plist_path
    (destination / plist)
  end

  met? {
    plist_path.exists? &&
    FileUtils.compare_file(plist_template, plist_path)
  }
  meet {
    sudo "cp #{plist_template} #{destination}"
  }
  after {
    log sudo "launchctl unload -w '#{plist_path}'"
  }
end