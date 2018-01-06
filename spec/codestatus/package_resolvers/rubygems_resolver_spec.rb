RSpec.describe Codestatus::PackageResolvers::RubygemsResolver do
  describe '.match?' do
    %w(
      rubygems
    ).each do |registry|
      it "matches to #{registry}" do
        expect(described_class.match?(registry)).to be true
      end
    end

    %w(
      xrubygems
      rubygemsx
    ).each do |registry|
      it "does not matche to #{registry}" do
        expect(described_class.match?(registry)).to be false
      end
    end
  end
end
