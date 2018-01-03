require 'rest-client'

module Codestatus
  module PackageResolvers
    class NpmResolver < Base
      NPM_REGISTRY_ENDPOINT = 'https://registry.npmjs.org/'.freeze

      private

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

      def package_info
        @package_info ||= JSON.parse(client.get("#{NPM_REGISTRY_ENDPOINT}/#{package}"))
      end

      def client
        RestClient
      end
    end
  end
end
