require "gems"

module Codestatus
  module PackageResolvers
    class RubygemsResolver < Base
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

      attr_reader :package

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

      def gem_info
        @info ||= Gems.info(package)
      end

      def urls
        [
          source_code_uri,
          homepage_uri,
          bug_tracker_uri,
        ].compact
      end

      def homepage_uri
        gem_info['homepage_uri']
      end

      def source_code_uri
        gem_info['source_code_uri']
      end

      def bug_tracker_uri
        gem_info['bug_tracker_uri']
      end
    end
  end
end
