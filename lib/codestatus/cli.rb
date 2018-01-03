require "thor"

module Codestatus
  class CLI < Thor
    desc "status REGISTRY/PACKAGE", "Show status of the package"
    option :registry, type: :string, aliases: 'r'
    option 'show-package-name', type: :boolean, default: false
    def status(slug)
      if options[:registry]
        package_registry = options[:registry]
        package_name = slug
      else
        package_registry, package_name = slug.split('/', 2)
      end

      status = Codestatus.status(registry: package_registry, package: package_name)
      success = (status.status == BuildStatus::SUCCESS)

      if options['show-package-name']
        puts "#{package_name}: #{status.status}"
      else
        puts status.status
      end
      exit success ? 0 : 1
    end
  end
end
