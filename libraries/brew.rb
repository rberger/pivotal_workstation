class Chef::Recipe
  def brew_install(package, opts={})
    include_recipe "pivotal_workstation::homebrew"
    sha = opts.delete("sha")
    specific_version = "https://raw.github.com/mxcl/homebrew/#{sha}/Library/Formula/#{package}.rb"
    package = specific_version if sha
    prefix_command = (opts[:prefix_command]) ? "#{opts[:prefix_command]} && " : ""
    execute "brew install #{package} #{opts[:brew_args]}" do
      user WS_USER
      command "#{prefix_command}brew install #{package} #{opts[:brew_args]}"
      not_if "brew list | grep '^#{package}$'"
    end
  end

  def brew_installed?(package)
    include_recipe "pivotal_workstation::homebrew"

    system("brew list #{package}")
  end

  def brew_remove(package)
    include_recipe "pivotal_workstation::homebrew"

    brew_installed = `brew list | grep #{package}`
    unless brew_installed.empty?
      execute "brew remove #{package}" do
        user WS_USER
        command "brew remove #{package}"
      end
    end
  end

  def brew_update
    include_recipe "pivotal_workstation::homebrew"

    execute "brew update" do
      user WS_USER
      command "brew update"
    end
  end
end
