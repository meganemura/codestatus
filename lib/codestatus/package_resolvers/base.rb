module Codestatus
  module PackageResolvers
    class Base
      GITHUB_REPOSITORY_REGEXP = %r{(https?|git)://github.com/(?<owner>[^/]*)/(?<repo>[^/]*)(\.git)?/?.*}.freeze
      BITBUCKET_REPOSITORY_REGEXP = %r{(https?|git)://bitbucket.org/(?<owner>[^/]*)/(?<repo>[^/]*)(\.git)?/?.*}.freeze

      def self.resolve(package)
        self.new(package).resolve
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

      private

      def detect_repository
        raise PackageNotFoundError unless found?
        repository = github_repository || bitbucket_repository
        raise RepositoryNotFoundError unless repository
        repository
      end

      def found?
        raise NotImplementedError
      end

      def github_repository
        urls.map { |url|
          matched = GITHUB_REPOSITORY_REGEXP.match(url)
          next unless matched

          repo = [matched[:owner], matched[:repo]].join('/')
          Repositories::GitHubRepository.new(repo)
        }.compact.first
      end

      def bitbucket_repository
        urls.map { |url|
          matched = BITBUCKET_REPOSITORY_REGEXP.match(url)
          next unless matched

          repo = [matched[:owner], matched[:repo]].join('/')
          Repositories::BitbucketRepository.new(repo)
        }.compact.first
      end

      def urls
        raise NotImplementedError
      end
    end
  end
end
