require "codestatus/version"
require "codestatus/build_status"
require "codestatus/cli"
require "codestatus/package_entry"
require "codestatus/package_resolvers/base"
require "codestatus/package_resolvers/rubygems_resolver"
require "codestatus/package_resolvers/npm_resolver"
require "codestatus/package_resolvers/repository_not_found_error"
require "codestatus/package_resolvers/resolver_not_found_error"
require "codestatus/package_resolvers/package_not_found_error"
require "codestatus/repositories/base"
require "codestatus/repositories/github_repository"
require "codestatus/repositories/bitbucket_repository"
require "codestatus/repositories/repository_not_found_error"

module Codestatus
  def self.status(repository: nil, registry: nil, package: nil)
    if !repository && registry && package
      repository = repository(registry: registry, package: package)
    end

    if repository
      repository.status
    else
      BuildStatus.new(sha: nil, status: nil)
    end
  end

  def self.repository(registry:, package:)
    resolver(registry).resolve!(package).repository
  end

  def self.resolver(registry)
    resolver = resolvers.detect { |resolver| resolver.match?(registry) }
    raise PackageResolvers::ResolverNotFoundError unless resolver
    resolver
  end

  # TODO: Register resolvers in PackageResolvers::Base.inherited
  def self.resolvers
    @resolvers ||= [
      PackageResolvers::RubygemsResolver,
      PackageResolvers::NpmResolver,
    ]
  end
end
