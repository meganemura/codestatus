module Codestatus
  module Repositories
    class Base
      def initialize(slug)
        @slug = slug
      end
      attr_reader :slug
    end
  end
end
