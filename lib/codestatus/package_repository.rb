module Codestatus
  class PackageRepository
    def initialize(github: nil)
      @github = GitHubRepository.new(github) if github
      # bitbucket, gitlab, ...
    end

    attr_reader :github

    def status
      if github
        github.status # default branch's commit's status
      end
    end
  end
end
