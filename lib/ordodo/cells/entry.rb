module Ordodo
  module Cells
    class Entry < Cell
      def celebrations
        model.celebrations.each_with_index.collect do |celebration, i|
          Cells::Celebration.(celebration, order: i)
        end
      end

      def nth_entry?
        options[:order] > 0
      end

      def heading
        model.titles.join(', ') + ':'
      end

      def vespers_from_following?
        model.vespers_from_following?
      end

      def compline_worth_mentioning?
        vespers_from_following? && !model.vespers_from_following_sunday?
      end

      def vespers
        if model.vespers_from_following_sunday?
          I18n.t 'office.vespers_from_following.sunday'
        elsif model.vespers_from_following_feast?
          I18n.t 'office.vespers_from_following.feast'
        else
          I18n.t 'office.vespers_from_following.solemnity'
        end
      end

      def compline
        vespers_from_following? &&
          I18n.t('office.compline.sunday_first')
      end
    end
  end
end
