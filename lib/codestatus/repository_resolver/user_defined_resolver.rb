module Codestatus
  class RepositoryResolver
    class UserDefinedResolver
      def self.definitions
        @definitions ||= {
          'rubygems/apartment': Codestatus::PackageRepository.new(github: 'influitive/apartment'),
          'rubygems/octokit': Codestatus::PackageRepository.new(github: 'octokit/octokit.rb'),
        }
      end

      def resolve(registry:, package:)
        key = [registry, package].join('/')

        self.class.definitions[key.to_sym]
      end
    end
  end
end
