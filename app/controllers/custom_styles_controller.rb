#-- encoding: UTF-8



class CustomStylesController < ApplicationController
  layout 'admin'
  menu_item :custom_style

  before_action :require_admin, except: %i[logo_download favicon_download touch_icon_download]
  before_action :require_ee_token, except: %i[upsale logo_download favicon_download touch_icon_download]
  skip_before_action :check_if_login_required, only: %i[logo_download favicon_download touch_icon_download]

  def show
    @custom_style = CustomStyle.current || CustomStyle.new
    @current_theme = @custom_style.theme
    @theme_options = options_for_theme_select
  end

  def upsale; end

  def create
    @custom_style = CustomStyle.create(custom_style_params)
    if @custom_style.valid?
      redirect_to custom_style_path
    else
      flash[:error] = @custom_style.errors.full_messages
      render action: :show
    end
  end

  def update
    @custom_style = get_or_create_custom_style
    if @custom_style.update(custom_style_params)
      redirect_to custom_style_path
    else
      flash[:error] = @custom_style.errors.full_messages
      render action: :show
    end
  end

  def logo_download
    file_download(:logo_path)
  end

  def favicon_download
    file_download(:favicon_path)
  end

  def touch_icon_download
    file_download(:touch_icon_path)
  end

  def logo_delete
    file_delete(:remove_logo!)
  end

  def favicon_delete
    file_delete(:remove_favicon!)
  end

  def touch_icon_delete
    file_delete(:remove_touch_icon!)
  end

  def update_colors
    variable_params = params[:design_colors].first

    ::Design::UpdateDesignService
      .new(colors: variable_params, theme: params[:theme])
      .call

    redirect_to action: :show
  end

  def update_themes
    theme = OpenProject::CustomStyles::ColorThemes.themes.find { |t| t[:theme] == params[:theme] }

    call = ::Design::UpdateDesignService
      .new(theme)
      .call

    call.on_success do
      flash[:notice] = I18n.t(:notice_successful_update)
    end

    call.on_failure do
      flash[:error] = call.message
    end

    redirect_to action: :show
  end

  def show_local_breadcrumb
    true
  end

  private

  def options_for_theme_select
    options = OpenProject::CustomStyles::ColorThemes.themes.map { |val| val[:theme] }
    unless @current_theme.present?
      options << [t('admin.custom_styles.color_theme_custom'), '',
                  { selected: true, disabled: true }]
    end

    options
  end

  def get_or_create_custom_style
    CustomStyle.current || CustomStyle.create!
  end

  def require_ee_token
    unless EnterpriseToken.allows_to?(:define_custom_style)
      redirect_to custom_style_upsale_path
    end
  end

  def custom_style_params
    params.require(:custom_style).permit(:logo, :remove_logo, :favicon, :remove_favicon, :touch_icon, :remove_touch_icon)
  end

  def file_download(path_method)
    @custom_style = CustomStyle.current
    if @custom_style && @custom_style.send(path_method)
      expires_in 1.years, public: true, must_revalidate: false
      send_file(@custom_style.send(path_method))
    else
      head :not_found
    end
  end

  def file_delete(remove_method)
    @custom_style = CustomStyle.current
    if @custom_style.nil?
      return render_404
    end

    @custom_style.send(remove_method)
    @custom_style.save
    redirect_to custom_style_path
  end
end
