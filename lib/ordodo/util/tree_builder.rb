module Ordodo
  module Util
    # DSL for quickly creating example tree structures
    #
    # TreeBuilder.build { parent(child, child(grandchild)) }
    class TreeBuilder
      class << self
        def build(&blk)
          instance_eval &blk
        end

        def method_missing(symbol, *args)
          node = Tree::TreeNode.new('', symbol)
          node.rename node.object_id.to_s
          args.each {|a| node << a }

          node
        end
      end
    end
  end
end
