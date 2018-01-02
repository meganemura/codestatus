module Codestatus
  class PackageResolver
    class UserDefinedResolver
      def self.definitions
        @definitions ||= {
          'rubygems/apartment': Repositories::GitHubRepository.new('influitive/apartment'),
          'rubygems/octokit': Repositories::GitHubRepository.new('octokit/octokit.rb'),
        }
      end

      def resolve(registry:, package:)
        key = [registry, package].join('/')

        self.class.definitions[key.to_sym]
      end
    end
  end
end
