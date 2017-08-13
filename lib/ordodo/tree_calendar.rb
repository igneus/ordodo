module Ordodo
  class TreeCalendar
    def initialize(year, sanctorale_tree, temporale_extensions, temporale_options)
      @year = year

      temporale_options_always =
        temporale_options[:always]&.dup || {}
      temporale_options_always[:extensions] = temporale_extensions

      @temporale_factory = lambda do |year|
        CalendariumRomanum::Temporale
          .new(
            year,
            **temporale_options_always
          )
      end

      @calendar_tree = build_calendar_tree sanctorale_tree

      if temporale_options[:optional]
        # add a branch for each optional Temporale option
        temporale_options[:optional][:transfer_to_sunday].each do |transferred|
          factory = lambda do |year|
            options = temporale_options_always.dup
            options[:transfer_to_sunday] =
              (options[:transfer_to_sunday] || []) + [transferred]
            CalendariumRomanum::Temporale
              .new(
                year,
                **options
              )
          end

          sanctorale = sanctorale_tree.content
          calendar = CalendariumRomanum::Calendar.new(@year, sanctorale, factory)
          variant_name = I18n.t "transfer.#{transferred}"
          @calendar_tree << Tree::TreeNode.new(variant_name, calendar)
        end
      end
    end

    def each_day
      root_calendar = @calendar_tree.content
      root_calendar.temporale.date_range.each do |date|
        yield day(date)
      end
    end

    def day(date)
      build_day_tree(date, @calendar_tree)
    end

    private

    def build_calendar_tree(sanctorale_tree)
      sanctorale = sanctorale_tree.content
      calendar = CalendariumRomanum::Calendar.new(@year, sanctorale, @temporale_factory)
      node = Tree::TreeNode.new(sanctorale_tree.name, calendar)

      sanctorale_tree.children.each do |child|
        node << build_calendar_tree(child)
      end

      node
    end

    def build_day_tree(date, calendar_tree)
      calendar = calendar_tree.content
      day = calendar.day date
      node = Tree::TreeNode.new(calendar_tree.name, day)

      calendar_tree.children.each do |child|
        node << build_day_tree(date, child)
      end

      node
    end
  end
end
