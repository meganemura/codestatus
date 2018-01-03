require "codestatus/version"
require "codestatus/build_status"
require "codestatus/cli"
require "codestatus/package_resolver/user_defined_resolver"
require "codestatus/package_resolver/rubygems_resolver"
require "codestatus/package_resolver/npm_resolver"
require "codestatus/repositories/github_repository"

module Codestatus
  def self.status(registry:, package:)
    repository = resolver(registry).resolve(registry: registry, package: package)

    if repository
      repository.status
    else
      BuildStatus.new(sha: nil, status: nil)
    end
  end

  def self.resolver(registry)
    case registry
    when /rubygems/
      PackageResolver::RubygemsResolver
    when /npm/
      PackageResolver::NpmResolver
    else
      PackageResolver::UserDefinedResolver
    end
  end
end
