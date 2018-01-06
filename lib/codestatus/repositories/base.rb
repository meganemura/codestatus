module Codestatus
  module Repositories
    class Base
      def initialize(slug)
        @slug = slug
      end
      attr_reader :slug

      def exist?
        !! repository
      end

      def status(ref)
        raise NotImplementedError
      end

      def html_url
        raise NotImplementedError
      end

      private

      def repository
        raise NotImplementedError
      end

      def exist!
        raise RepositoryNotFoundError unless exist?
      end
    end
  end
end
