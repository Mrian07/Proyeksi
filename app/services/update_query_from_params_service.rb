class UpdateQueryFromParamsService
  def initialize(query, user)
    self.query = query
    self.current_user = user
  end

  def call(params, valid_subset: false)
    apply_group_by(params)

    apply_sort_by(params)

    apply_filters(params)

    apply_columns(params)

    apply_sums(params)

    apply_timeline(params)

    apply_hierarchy(params)

    apply_highlighting(params)

    apply_display_representation(params)

    disable_hierarchy_when_only_grouped_by(params)

    if valid_subset
      query.valid_subset!
    end

    if query.valid?
      ServiceResult.new(success: true,
                        result: query)
    else
      ServiceResult.new(errors: query.errors)
    end
  end

  private

  def apply_group_by(params)
    query.group_by = params[:group_by] if params.key?(:group_by)
  end

  def apply_sort_by(params)
    query.sort_criteria = params[:sort_by] if params[:sort_by]
  end

  def apply_filters(params)
    return unless params[:filters]

    query.filters = []

    params[:filters].each do |filter|
      query.add_filter(filter[:field], filter[:operator], filter[:values])
    end
  end

  def apply_columns(params)
    query.column_names = params[:columns] if params[:columns]
  end

  def apply_sums(params)
    query.display_sums = params[:display_sums] if params.key?(:display_sums)
  end

  def apply_timeline(params)
    query.timeline_visible = params[:timeline_visible] if params.key?(:timeline_visible)
    query.timeline_zoom_level = params[:timeline_zoom_level] if params.key?(:timeline_zoom_level)
    query.timeline_labels = params[:timeline_labels] if params.key?(:timeline_labels)
  end

  def apply_hierarchy(params)
    query.show_hierarchies = params[:show_hierarchies] if params.key?(:show_hierarchies)
  end

  def apply_highlighting(params)
    query.highlighting_mode = params[:highlighting_mode] if params.key?(:highlighting_mode)
    query.highlighted_attributes = params[:highlighted_attributes] if params.key?(:highlighted_attributes)
  end

  def apply_display_representation(params)
    query.display_representation = params[:display_representation] if params.key?(:display_representation)
  end

  def disable_hierarchy_when_only_grouped_by(params)
    if params.key?(:group_by) && !params.key?(:show_hierarchies)
      query.show_hierarchies = false
    end
  end

  attr_accessor :query,
                :current_user,
                :params
end
