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

      repository = find_repository(package_registry, package_name)
      status = repository.status
      success = (status.status == BuildStatus::SUCCESS)

      if options['show-package-name']
        puts "#{package_name}: #{status.status}"
      else
        puts status.status
      end
      exit success ? 0 : 1
    end

    desc "repository REGISTRY/PACKAGE", "Show repository of the package"
    option :registry, type: :string, aliases: 'r'
    option 'show-package-name', type: :boolean, default: false
    def repository(slug)
      if options[:registry]
        package_registry = options[:registry]
        package_name = slug
      else
        package_registry, package_name = slug.split('/', 2)
      end

      repository = find_repository(package_registry, package_name)

      if options['show-package-name']
        puts "#{package_name}: #{repository.html_url}"
      else
        puts repository.html_url
      end
    end

    private

    def find_repository(registry, package)
      repository = Codestatus.repository(registry: registry, package: package)
      repository.exist!
      repository
    rescue PackageResolvers::ResolverNotFoundError
      abort "#{package}: Resolver for `#{registry}` not found"
    rescue PackageResolvers::PackageNotFoundError
      abort "#{package}: Package not found"
    rescue PackageResolvers::RepositoryNotFoundError
      abort "#{package}: Repository not found"
    rescue Repositories::RepositoryNotFoundError
      abort "#{package}: Repository not found on the resolved url"
    end
  end
end
