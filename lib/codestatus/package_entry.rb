module Codestatus
  class PackageEntry
    def initialize(registry:, repository:)
      @registry = registry
      @repository = repository
    end

    attr_reader :registry, :repository
  end
end
