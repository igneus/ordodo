module Ordodo
  # Liturgical details of a particular celebration
  # (Both Divine Office and Mass);
  # exposes complete public interface of Celebration
  # and adds additional methods
  class Office < DelegateClass(CalendariumRomanum::Celebration)
    def initialize(day, celebration)
      @day = day
      @celebration = celebration
      super(@celebration)
    end

    def office_ferial?
      rank == CR::Ranks::FERIAL ||
        rank == CR::Ranks::FERIAL_PRIVILEGED
    end

    def office_memorial?
      rank.memorial?
    end

    def office_festal?
      rank == CR::Ranks::FEAST_LORD_GENERAL ||
        rank == CR::Ranks::FEAST_GENERAL ||
        rank == CR::Ranks::FEAST_PROPER
    end

    def office_solemnity?
      rank == CR::Ranks::SOLEMNITY_GENERAL ||
        rank == CR::Ranks::SOLEMNITY_PROPER
    end

    def daytime_prayer
      if office_solemnity?
        if @day.date.sunday?
          :sunday
        else
          :supplementary
        end
      else
        :psalter
      end
    end
  end
end
