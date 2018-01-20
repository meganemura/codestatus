module Codestatus
  module PackageResolvers
    class Base
      GITHUB_REPOSITORY_REGEXP = %r{(https?|git)://github.com/(?<owner>[^/]*)/(?<repo>[^/]*)(\.git)?/?.*}.freeze
      BITBUCKET_REPOSITORY_REGEXP = %r{(https?|git)://bitbucket.org/(?<owner>[^/]*)/(?<repo>[^/]*)(\.git)?/?.*}.freeze
      REPO_REJECT_REGEXP = /\.git$/

      # Given registry name is for self class or not
      def self.match?(registry)
        raise NotImplementedError
      end

      def self.resolve(package)
        self.new(package).resolve
      end

      def self.resolve!(package)
        self.new(package).resolve!
      end

      def self.registry_name
        raise NotImplementedError
      end

      def initialize(package)
        @package = package
      end

      attr_reader :package

      def resolve
        detect_repository
      rescue PackageNotFoundError, RepositoryNotFoundError
        # noop
      end

      def resolve!
        detect_repository
      end

      def registry_name
        self.class.registry_name
      end

      private

      def detect_repository
        raise PackageNotFoundError unless found?
        repository = github_repository || bitbucket_repository
        raise RepositoryNotFoundError unless repository
        repository
      end

      # package is found or not in the registry
      def found?
        raise NotImplementedError
      end

      def github_repository
        urls.map { |url|
          matched = GITHUB_REPOSITORY_REGEXP.match(url)
          next unless matched
          repository = Repositories::GitHubRepository.new(build_slug(matched))
          PackageEntry.new(registry: registry_name, repository: repository)
        }.compact.first
      end

      def bitbucket_repository
        urls.map { |url|
          matched = BITBUCKET_REPOSITORY_REGEXP.match(url)
          next unless matched
          repository = Repositories::BitbucketRepository.new(build_slug(matched))
          PackageEntry.new(registry: registry_name, repository: repository)
        }.compact.first
      end

      # candidate urls for detecting repository
      def urls
        raise NotImplementedError
      end

      private

      def build_slug(named_captures)
        owner = named_captures[:owner]
        repo = named_captures[:repo].gsub(REPO_REJECT_REGEXP, '')

        [owner, repo].join('/')
      end
    end
  end
end
