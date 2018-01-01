module Codestatus
  class BuildStatus
    UNDEFINED = 'undefined'.freeze

    # Defined in GitHub
    ERROR = 'error'.freeze
    FAILURE = 'failure'.freeze
    PENDING = 'pending'.freeze
    SUCCESS = 'success'.freeze

    STATUSES = [
      ERROR,
      FAILURE,
      PENDING,
      SUCCESS,
    ].freeze

    def initialize(sha:, status:)
      @sha = sha

      if STATUSES.include?(status.to_s)
        @status = status.to_s
      else
        @status = UNDEFINED
      end
    end

    attr_reader :sha, :status
  end
end
