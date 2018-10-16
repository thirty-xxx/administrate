require "administrate/field/encrypted"
require "support/field_matchers"

describe Administrate::Field::Encrypted do
  include FieldMatchers

  describe 'settings' do
    it 'is encrypted and not searchable' do
      expect(described_class).not_to be_searchable
      expect(described_class).to be_encrypted
    end
  end

  describe "#to_partial_path" do
    it "returns a partial based on the page being rendered" do
      page = :show
      field = described_class.new(:string, "hello", page)

      path = field.to_partial_path

      expect(path).to eq("/fields/encrypted/#{page}")
    end
  end

  it { should_permit_param(:foo, for_attribute: :foo) }

  describe "#truncate" do
    it "renders an empty string for nil" do
      string = described_class.new(:description, nil, :show)

      expect(string.truncate).to eq("")
    end

    it "defaults to displaying up to 50 characters" do
      short = described_class.new(:title, lorem(30), :show)
      long = described_class.new(:description, lorem(60), :show)

      expect(short.truncate).to eq(lorem(30))
      expect(long.truncate).to eq(lorem(50))
    end

    context "with a `truncate` option" do
      it "shortens to the given length" do
        string = string_with_options(lorem(30), truncate: 20)

        expect(string.truncate).to eq(lorem(20))
      end
    end
  end

  def string_with_options(string, options)
    described_class.new(:string, string, :page, options)
  end

  def lorem(n)
    "a" * n
  end
end
