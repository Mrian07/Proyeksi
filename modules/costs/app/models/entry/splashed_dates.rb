#-- encoding: UTF-8



module Entry::SplashedDates
  extend ActiveSupport::Concern

  included do
    # tyear, tmonth, tweek assigned where setting spent_on attributes
    # these attributes make time aggregations easier
    def spent_on=(date)
      super
      if spent_on.is_a?(Time)
        self.spent_on = spent_on.to_date
      end
      set_tyear
      set_tmonth
      set_tweek
    end

    private

    def set_tyear
      self.tyear = spent_on ? spent_on.year : nil
    end

    def set_tmonth
      self.tmonth = spent_on ? spent_on.month : nil
    end

    def set_tweek
      self.tweek = spent_on ? Date.civil(spent_on.year, spent_on.month, spent_on.day).cweek : nil
    end
  end
end
