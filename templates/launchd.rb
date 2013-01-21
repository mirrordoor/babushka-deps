require 'fileutils'

meta :launchd, :for => :osx do
  accepts_value_for :destination, "~/Library/LaunchAgents"

  template {
    def plist
      brew_path = Babushka::BrewHelper.brew_path_for(basename)
      Dir["#{brew_path}/*.plist"].first.p.basename.to_s
    end

    def plist_path
      (destination / plist)
    end

    requires 'launchd plist copied'.with(
      :package => basename,
      :plist => plist,
      :destination => destination
    )

    met? {
      shell('launchctl list')[basename]
    }
    meet {
      log shell "launchctl load -w '#{plist_path}'"
    }
  }
end

dep 'launchd plist copied', :package, :plist, :destination, :for => :osx do
  def brew_path
    Babushka::BrewHelper.brew_path_for(package)
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
    plist_template.copy destination.p
  }
  after {
    log shell "launchctl unload -w '#{plist_path}'"
  }
end