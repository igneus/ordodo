module Ordodo
  module Cells
    class Cell < ::Cell::ViewModel
      include ::Cell::Erb

      self.view_paths = ['templates/html']
    end
  end
end
