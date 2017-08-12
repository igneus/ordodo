module Ordodo
  class Linearizer
    # takes a reduced solution tree for a given day,
    # produces a Record;
    #
    def linearize(tree)
      entries = []

      nodes = tree.to_a
      while !nodes.empty?
        node = nodes.shift
        titles = [node.name]

        nodes.delete_if do |n|
          n.content == node.content && titles << n.name
        end

        entries << Entry.new(titles, node.content)
      end

      Record.new(entries)
    end
  end
end
