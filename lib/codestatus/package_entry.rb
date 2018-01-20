module Codestatus
  class PackageEntry
    def initialize(registry:, repository_class:, repository_slug:)
      @registry = registry
      @repository = repository_class.new(repository_slug)
    end

    attr_reader :registry, :repository
  end
end
