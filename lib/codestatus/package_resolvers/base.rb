module Codestatus
  module PackageResolvers
    class Base
      GITHUB_REPOSITORY_REGEXP = %r{(https?|git)://github.com/(?<owner>[^/]*)/(?<repo>[^/]*)(\.git)?/?.*}.freeze

      def self.resolve(package:)
        self.new(package: package).resolve
      end

      def initialize(package:)
        @package = package
      end

      attr_reader :package

      def resolve
        @package = package

        github_repository
      end

      private

      def github_repository
        result = nil
        urls.each do |url|
          matched = GITHUB_REPOSITORY_REGEXP.match(url)
          next unless matched

          repo = [matched[:owner], matched[:repo]].join('/')
          result = Repositories::GitHubRepository.new(repo)
          break
        end
        result
      end

      def urls
        raise NotImplementedError
      end
    end
  end
end
