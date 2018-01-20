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

          owner = matched[:owner]
          repo = matched[:repo].gsub(REPO_REJECT_REGEXP, '')

          repo = [owner, repo].join('/')
          Repositories::GitHubRepository.new(repo)
        }.compact.first
      end

      def bitbucket_repository
        urls.map { |url|
          matched = BITBUCKET_REPOSITORY_REGEXP.match(url)
          next unless matched

          owner = matched[:owner]
          repo = matched[:repo].gsub(REPO_REJECT_REGEXP, '')

          repo = [owner, repo].join('/')
          Repositories::BitbucketRepository.new(repo)
        }.compact.first
      end

      # candidate urls for detecting repository
      def urls
        raise NotImplementedError
      end
    end
  end
end
