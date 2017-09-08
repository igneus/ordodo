module Ordodo
  module Cells
    class Cell < ::Cell::ViewModel
      include ::Cell::Erb
      extend Forwardable

      self.view_paths = ['templates/html']
    end
  end
end
