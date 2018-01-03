require 'rest-client'

module Codestatus
  module PackageResolvers
    class NpmResolver < Base
      GITHUB_REPOSITORY_REGEXP = %r{(https?|git)://github.com/(?<owner>[^/]*)/(?<repo>[^/]*)(\.git)?/?.*}.freeze
      NPM_REGISTRY_ENDPOINT = 'https://registry.npmjs.org/'.freeze

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

      # FIXME: Copied from RubygemsResolver
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

      def package_info
        @package_info ||= JSON.parse(client.get("#{NPM_REGISTRY_ENDPOINT}/#{package}"))
      end

      def urls
        [
          bugs_url,
          repository_url,
          homepage_url,
        ].compact
      end

      def bugs_url
        package_info.dig('bugs', 'url')
      end

      def homepage_url
        package_info.dig('homepage')
      end

      def repository_url
        package_info.dig('repository', 'url')
      end

      def client
        RestClient
      end
    end
  end
end
