require "gems"

module Codestatus
  module PackageResolvers
    class RubygemsResolver < Base

      def self.match?(registry)
        /^rubygems$/.match?(registry)
      end

      def self.registry_name
        'rubygems'
      end

      private

      def found?
        gem_info
      end

      def urls
        [
          source_code_uri,
          homepage_uri,
          bug_tracker_uri,
        ].compact
      end

      def homepage_uri
        gem_info&.dig('homepage_uri')
      end

      def source_code_uri
        gem_info&.dig('source_code_uri')
      end

      def bug_tracker_uri
        gem_info&.dig('bug_tracker_uri')
      end

      def gem_info
        @info ||= begin
                    Gems.info(package)
                  rescue JSON::ParserError
                    # When the package is not found on rubygems,
                    # Gems does try to parse html as json and raise JSON::ParserError :sob:
                    nil
                  end
      end
    end
  end
end
