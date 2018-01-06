RSpec.describe Codestatus::PackageResolvers::NpmResolver do
  describe '.match?' do
    %w(
      npm
      npmjs
      npmjs.org
    ).each do |registry|
      it "matches to #{registry}" do
        expect(described_class.match?(registry)).to be true
      end
    end

    %w(
      xnpm
      xnpmjs
      xnpmjs.org
      npmx
      npmjsx
      npmjs.orgx
    ).each do |registry|
      it "does not matche to #{registry}" do
        expect(described_class.match?(registry)).to be false
      end
    end
  end
end
