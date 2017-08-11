require_relative 'spec_helper'

describe Ordodo::Util::TreeBuilder do
  let(:t) { described_class}

  it 'builds single node' do
    tree = t.build { a }

    expect(tree).to be_a Tree::TreeNode
    expect(tree.name).not_to be_empty
    expect(tree.content).to be :a
    expect(tree).not_to have_children
  end

  it 'builds a node with a child' do
    tree = t.build { a(b) }

    expect(tree.content).to be :a
    expect(tree.children.first.content).to be :b
    expect(tree.children.size).to eq 1
  end

  it 'builds a node with a child and a grandchild' do
    tree = t.build { a(b(c)) }

    expect(tree.content).to be :a
    expect(tree.children.first.content).to be :b
    expect(tree.children.first.children.first.content).to be :c
  end

  it 'builds two children with the same content' do
    tree = t.build { a(b, b) }

    expect(tree.content).to be :a
    expect(tree.children[0].content).to be :b
    expect(tree.children[1].content).to be :b
  end

  it 'builds parent and child with the same content' do
    tree = t.build { a(a) }

    expect(tree.content).to be :a
    expect(tree.children.first.content).to be :a
  end

  it 'builds a deep nested structure' do
    tree = t.build { a(a(a, b, b(c)), a(a, a(a, a(b(c(d(e(f)))))), b)) }

    expect(tree.size).to eq 17
  end
end
