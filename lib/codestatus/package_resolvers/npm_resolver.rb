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
        package_info&.dig('bugs', 'url')
      end

      def homepage_url
        package_info&.dig('homepage')
      end

      def repository_url
        package_info&.dig('repository', 'url')
      end

      def package_info
        @package_info ||= request(package_uri)
      end

      def request(uri)
        response = client.get(uri)
        JSON.parse(response)
      rescue RestClient::NotFound
        nil
      end

      def client
        RestClient
      end

      def package_uri
        File.join(NPM_REGISTRY_ENDPOINT, slash_escaped_package)
      end

      # for scoped package
      #   For example, to access @atlassian/aui information,
      #   we must use https://registry.npmjs.org/@atlassian%2Faui,
      #   not https://registry.npmjs.org/%40atlassian%2Faui.
      def slash_escaped_package
        package.gsub('/', CGI.escape('/'))
      end
    end
  end
end
