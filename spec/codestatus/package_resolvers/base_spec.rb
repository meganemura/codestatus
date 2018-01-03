RSpec.describe Codestatus::PackageResolvers::Base do
  describe 'GitHub Repository Regexp' do
    [
      "https://github.com/angular/angular-cli",
      "git+https://github.com/angular/angular-cli.git",
    ].each do |uri|
      it "matches to #{uri}" do
        expect(described_class::GITHUB_REPOSITORY_REGEXP.match?(uri)).to be true
      end
    end
  end

  describe 'Bitbucket Repository Regexp' do
    [
      'git+https://bitbucket.org/atlassian/aui.git'
    ].each do |uri|
      it "matches to #{uri}" do
        expect(described_class::BITBUCKET_REPOSITORY_REGEXP.match?(uri)).to be true
      end
    end
  end
end
