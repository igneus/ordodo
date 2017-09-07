module Ordodo
  module Cells
    class Celebration < Cell
      UNPRINTED_RANKS = [
        CalendariumRomanum::Ranks::SUNDAY_UNPRIVILEGED,
        CalendariumRomanum::Ranks::FERIAL,
        CalendariumRomanum::Ranks::FERIAL_PRIVILEGED,
        CalendariumRomanum::Ranks::MEMORIAL_OPTIONAL
      ].freeze

      NOTBOLD_RANKS = [
        CalendariumRomanum::Ranks::MEMORIAL_OPTIONAL,
        CalendariumRomanum::Ranks::COMMEMORATION,
      ].freeze

      def show
        if commemoration?
          render 'commemoration'
        else
          render 'show'
        end
      end

      def nth_celebration?
        options[:order] > 0
      end

      def commemoration?
        model.rank == CalendariumRomanum::Ranks::COMMEMORATION
      end

      def commemoration_text
        if commemoration?
          return I18n.t('office.commemoration', title: "<span class=\"title\">#{model.title}</span>")
        end

        nil
      end

      def colour_css
        "colour colour-#{model.colour.symbol}"
      end

      def colour_name
        model.colour.name
      end

      def title_bold?
        !NOTBOLD_RANKS.include? model.rank
      end

      def title_heavy?
        model.solemnity?
      end

      def title
        model.title
      end

      def print_rank?
        !UNPRINTED_RANKS.include? model.rank
      end

      def rank
        if primary_solemnity? model
          return CalendariumRomanum::Ranks::SOLEMNITY_GENERAL.short_desc
        end

        model.rank.short_desc
      end

      def office
        if model.office_ferial?
          I18n.t 'office.ferial'
        elsif model.office_memorial?
          I18n.t 'office.memorial'
        elsif model.office_festal? || model.office_solemnity?
          I18n.t "office.daytime.#{model.daytime_prayer}"
        else
          nil
        end
      end

      def compline
        if model.office_solemnity?
          return I18n.t 'office.compline.sunday_second'
        end

        nil
      end

      private

      # some of the 'primary liturgical days' are customarily
      # called "solemnities", others not
      PRIMARY_SOLEMNITIES =
        %i(nativity epiphany easter_sunday ascension pentecost).freeze
      def primary_solemnity?(celebration)
        model.rank == CalendariumRomanum::Ranks::PRIMARY &&
          PRIMARY_SOLEMNITIES.include?(model.symbol)
      end
    end
  end
end
