require "thor"

module Codestatus
  class CLI < Thor
    desc "status REGISTRY/PACKAGE", "Show status of the package"
    option :registry, type: :string, aliases: 'r'
    def status(slug)
      if options[:registry]
        package_registry = options[:registry]
        package_name = slug
      else
        package_registry, package_name = slug.split('/')
      end

      status = Codestatus.status(registry: package_registry, package: package_name)
      success = (status.status == BuildStatus::SUCCESS)

      puts status.status
      exit success ? 0 : 1
    end
  end
end
