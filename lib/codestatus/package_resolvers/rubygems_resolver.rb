require "gems"

module Codestatus
  module PackageResolvers
    class RubygemsResolver < Base
      private

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

      def gem_info
        @info ||= Gems.info(package)
      end
    end
  end
end
