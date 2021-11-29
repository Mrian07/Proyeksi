

module Engine
  ##
  # Subclass of Report to be used for constant lookup and such.
  # It is considered public API to override this method i.e. in Tests.
  #
  # @return [Class] subclass
  # TODO: get rid of this module
  def engine
    return @engine if @engine

    CostQuery
  end
end
