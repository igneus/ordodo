module Ordodo
  module Cells
    class Record < Cell
      def entries
        model.entries.each_with_index.collect do |entry, i|
          Cells::Entry.(entry, order: i)
        end
      end

      def anchor
        model.date.strftime('%m-%d')
      end

      def date
        model.date.strftime(I18n.t('date_format'))
      end

      def weekday
        I18n.t "weekday.#{model.date.wday}"
      end

      def psalter_week
        I18n.t 'psalter_week', week: model.psalter_week
      end
    end
  end
end
