# monkey-patch to allow cloning of nodes with non-clonable
# content (like Symbols)
class Tree::TreeNode
  def detached_copy
    c = nil
    if @content
      begin
        c = @content.clone
      rescue TypeError
        c = @content
      end
    end
    self.class.new(@name, c)
  end
end

module Ordodo
  class TreeReducer
    def initialize(&blk)
      @callback = blk || lambda {|x,y| x.content == y.content }
    end

    def reduce(tree)
      recursively_reduce tree.dup
    end

    private

    def recursively_reduce(node)
      node.children.each do |c|
        recursively_reduce c
      end

      return node if node.is_root?
      return node unless @callback.call(node, node.parent)

      if (!node.has_children?)
        node.parent.remove! node
      else node.children.size == 1
        node.children.each {|c| node.parent << c }
        node.parent.remove! node
      end

      node
    end
  end
end
