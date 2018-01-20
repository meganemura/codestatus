RSpec.describe Codestatus::PackageResolvers::Base do
  describe 'GitHub Repository Regexp' do
    [
      ["https://github.com/angular/angular-cli",         "angular/angular-cli"],
      ["git+https://github.com/angular/angular-cli.git", "angular/angular-cli"],
    ].each do |uri, slug|
      it "matches to #{uri}" do
        matched = described_class::GITHUB_REPOSITORY_REGEXP.match(uri)
        expect(matched).to be_truthy
        repo = matched[:repo].gsub(described_class::REPO_REJECT_REGEXP, '')
        expect([matched[:owner], repo].join('/')).to eq(slug)
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
