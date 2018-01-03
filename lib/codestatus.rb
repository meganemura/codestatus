require "codestatus/version"
require "codestatus/build_status"
require "codestatus/cli"
require "codestatus/package_resolvers/rubygems_resolver"
require "codestatus/package_resolvers/npm_resolver"
require "codestatus/repositories/github_repository"

module Codestatus
  def self.status(registry:, package:)
    repository = resolver(registry).resolve(package: package)

    if repository
      repository.status
    else
      BuildStatus.new(sha: nil, status: nil)
    end
  end

  def self.resolver(registry)
    case registry
    when /rubygems/
      PackageResolvers::RubygemsResolver
    when /npm/
      PackageResolvers::NpmResolver
    end
  end
end
