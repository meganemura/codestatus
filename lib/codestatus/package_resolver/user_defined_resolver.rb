module Codestatus
  class PackageResolver
    class UserDefinedResolver
      def self.resolve(registry:, package:)
        self.new(registry: registry, package: package).resolve
      end

      def initialize(registry:, package:)
        @registry = registry
        @package = package
      end

      attr_reader :registry, :package

      def self.definitions
        @definitions ||= {
          'rubygems/apartment': Repositories::GitHubRepository.new('influitive/apartment'),
          'rubygems/octokit': Repositories::GitHubRepository.new('octokit/octokit.rb'),
        }
      end

      def resolve
        key = [registry, package].join('/')

        self.class.definitions[key.to_sym]
      end
    end
  end
end
