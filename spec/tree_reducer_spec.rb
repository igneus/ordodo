require 'spec_helper'

# compares two trees by node content (only)
RSpec::Matchers.define :tree_eq do |expected|
  match do |actual|
    # this doesn't really check that structure of both trees
    # is the same, but it should be good enough for our needs
    e = expected.each.collect &:content
    a = actual.each.collect &:content

    a == e
  end
end

describe Ordodo::TreeReducer do
  TreeBuilder = Ordodo::Util::TreeBuilder

  let(:r) { described_class.new }
  let(:reduced) { r.reduce tree }

  describe 'single node' do
    let(:tree) { TreeBuilder.build { a } }

    it 'leaves it as it is' do
      expect(reduced).to tree_eq tree
    end
  end

  describe 'parent and child equal' do
    let(:tree) do
      TreeBuilder.build { a(a) }
    end

    it 'removes the child' do
      expect(reduced).to tree_eq TreeBuilder.build { a }
      expect(reduced).not_to have_children
    end
  end

  describe 'parent and child different' do
    let(:tree) do
      TreeBuilder.build { a(b) }
    end

    it 'no reduction takes place' do
      expect(reduced).to tree_eq tree
    end
  end

  describe 'parent and children, both equal and different' do
    let(:tree) do
      TreeBuilder.build { a(a, b) }
    end

    it 'removes the equal child' do
      expect(reduced).to tree_eq TreeBuilder.build { a(b) }
    end
  end

  describe 'parent and child equal, grandchild different' do
    let(:tree) do
      TreeBuilder.build { a(a(b)) }
    end

    it 'removes the one in the middle' do
      expect(reduced).to tree_eq TreeBuilder.build { a(b) }
    end
  end

  describe 'parent and child equal, some grandchildren different' do
    let(:tree) do
      TreeBuilder.build { a(a(a,a,b,c)) }
    end

    it 'removes the redundant descendants' do
      expect(reduced).to tree_eq TreeBuilder.build { a(b,c) }
    end
  end
end
