

module OpenProject::Reporting::Patches::BigDecimalPatch
  class BigDecimal
    def to_d; self end
  end

  class Integer
    def to_d; to_f.to_d end
  end

  class String
    def to_d
      BigDecimal self
    end
  end

  class NilClass
    def to_d; 0 end
  end
end
