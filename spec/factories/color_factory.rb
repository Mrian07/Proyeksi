

FactoryBot.define do
  factory(:color, class: 'Color') do
    sequence(:name) { |n| "Color No. #{n}" }
    hexcode { ('#%0.6x' % rand(0xFFFFFF)).upcase }
  end
end

{ 'maroon' => '#800000',
  'red' => '#FF0000',
  'orange' => '#FFA500',
  'yellow' => '#FFFF00',
  'olive' => '#808000',
  'purple' => '#800080',
  'fuchsia' => '#FF00FF',
  'white' => '#FFFFFF',
  'lime' => '#00FF00',
  'green' => '#008000',
  'navy' => '#000080',
  'blue' => '#0000FF',
  'aqua' => '#00FFFF',
  'teal' => '#008080',
  'black' => '#000000',
  'silver' => '#C0C0C0',
  'gray' => '#808080' }.each do |name, code|
  FactoryBot.define do
    factory(:"color_#{name}", parent: :color) do
      name { name }
      hexcode { code }
    end
  end
end
