module Codestatus
  module Repositories
    class Base
      def initialize(slug)
        @slug = slug
      end
      attr_reader :slug

      def status(ref)
        raise NotImplementedError
      end

      def html_url
        raise NotImplementedError
      end
    end
  end
end
