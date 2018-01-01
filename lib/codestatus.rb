require "codestatus/version"
require "codestatus/build_status"
require "codestatus/repository_resolver"
require "codestatus/repository_resolver/user_defined_resolver"
require "codestatus/package_repository"
require "codestatus/package_repository/github_repository"

module Codestatus
  def self.status(slug = ARGV.first)
    slug = 'rubygems/apartment' unless slug
    package_registry, package_name = slug.split('/')

    resolver = RepositoryResolver.new(registry: package_registry, package: package_name)

    package_repository = resolver.repository
    if package_repository
      status = package_repository.status
      success = (status == BuildStatus::SUCCESS)
    else
      status = 'Repository not found'
      success = 1
    end
    puts status
    exit success ? 0 : 1
  end
end
