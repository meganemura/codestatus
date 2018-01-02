require "codestatus/version"
require "codestatus/build_status"
require "codestatus/cli"
require "codestatus/package_resolver"
require "codestatus/package_resolver/user_defined_resolver"
require "codestatus/package_resolver/rubygems_resolver"
require "codestatus/package_resolver/npm_resolver"
require "codestatus/package_repository"
require "codestatus/package_repository/github_repository"

module Codestatus
  def self.status(registry:, package:)
    resolver = RepositoryResolver.new(registry: registry, package: package)

    package_repository = resolver.repository

    if package_repository
      package_repository.status
    else
      BuildStatus.new(sha: nil, status: nil)
    end
  end
end
