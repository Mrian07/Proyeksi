

FactoryBot.define do
  factory :design_color  do
    hexcode { ('#%0.6x' % rand(0xFFFFFF)).upcase }
  end
end

{ "primary-color" => "#3493B3" }.each do |name, code|
  FactoryBot.define do
    factory(:"design_color_#{name}", parent: :design_color) do
      variable { name }
      hexcode { code }
    end
  end
end
