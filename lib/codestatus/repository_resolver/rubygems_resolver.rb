require "gems"

module Codestatus
  class RepositoryResolver
    class RubygemsResolver
      GITHUB_REPOSITORY_REGEXP = %r{https://github.com/(?<owner>.*)/(?<repo>.*)/?.*}.freeze

      def resolve(registry:, package:)
        return unless registry.to_s == 'rubygems'
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
          result = Codestatus::PackageRepository.new(github: repo)
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
