

FactoryBot.define do
  factory :custom_style

  factory :custom_style_with_logo, class: 'CustomStyle' do
    logo do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'support', 'custom_styles', 'logos', 'logo_image.png')
      )
    end
  end

  factory :custom_style_with_favicon, class: 'CustomStyle' do
    favicon do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'support', 'custom_styles', 'favicons', 'favicon_image.png')
      )
    end
  end

  factory :custom_style_with_touch_icon, class: 'CustomStyle' do
    touch_icon do
      Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'support', 'custom_styles', 'touch_icons', 'touch_icon_image.png')
      )
    end
  end
end
