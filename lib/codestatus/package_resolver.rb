module Codestatus
  class RepositoryResolver
    def initialize(registry:, package:)
      @registry = registry
      @package = package
    end

    attr_reader :registry, :package

    def repository
      @repository ||= resolve
    end

    private

    def resolve
      result = nil
      resolvers.each do |resolver|
        result = resolver.resolve(registry: registry, package: package)
        break if result
      end
      result
    end

    def resolvers
      @resolvers ||= resolver_classes.map(&:new)
    end

    def resolver_classes
      @resolver_classes ||= [
        RepositoryResolver::RubygemsResolver,
        RepositoryResolver::NpmResolver,
        RepositoryResolver::UserDefinedResolver,
      ]
    end
  end
end
