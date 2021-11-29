#-- encoding: UTF-8


#
if defined?(LivingStyleGuide)
  ##
  # Override CSS to never be called
  module DocumentTemplatePatch
    ##
    # Define our own template
    def template_erb
      if @template == :layout
        File.read(Rails.root.join('app/views/layouts/styleguide/styleguide.layout.html.erb'))
      else
        super
      end
    end
  end

  LivingStyleGuide::Document.prepend DocumentTemplatePatch
end
