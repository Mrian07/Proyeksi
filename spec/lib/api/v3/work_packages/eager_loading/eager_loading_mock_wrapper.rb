#-- encoding: UTF-8



class EagerLoadingMockWrapper
  def self.wrap(klass, work_packages)
    klass_module = klass.module

    delegator_class = Class.new(SimpleDelegator) do
      include(klass_module)
    end

    wrapped = work_packages.map do |wp|
      delegator_class.new(wp)
    end

    loader = klass.new(wrapped)

    wrapped.each do |w|
      loader.apply(w)
    end

    wrapped
  end
end
