require "codestatus/version"
require "codestatus/build_status"
require "codestatus/repository_resolver"
require "codestatus/repository_resolver/user_defined_resolver"
require "codestatus/package_repository"
require "codestatus/package_repository/github_repository"

module Codestatus
  def self.status(package_registry: :rubygems, package_name: 'apartment')

    resolver = RepositoryResolver.new(registry: package_registry, package: package_name)

    package_repository = resolver.repository

    status = package_repository.status
    success = (status == BuildStatus::SUCCESS)
    puts status
    exit success ? 0 : 1
  end
end
