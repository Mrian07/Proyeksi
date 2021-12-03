#-- encoding: UTF-8

class WorkPackages::Exports::ScheduleService
  attr_accessor :user

  def initialize(user:)
    self.user = user
  end

  def call(query:, mime_type:, params: {})
    export_storage = WorkPackages::Export.create
    job = schedule_export(export_storage, mime_type, params, query)

    ServiceResult.new success: true, result: job.job_id
  end

  private

  def schedule_export(export_storage, mime_type, params, query)
    WorkPackages::ExportJob.perform_later(export: export_storage,
                                          user: user,
                                          mime_type: mime_type,
                                          query: serialize_query(query),
                                          query_attributes: serialize_query_props(query),
                                          **params)
  end

  ##
  # Pass the query to the job if it was saved
  def serialize_query(query)
    if query.persisted?
      query
    end
  end

  def serialize_query_props(query)
    query.attributes.tap do |attributes|
      attributes['filters'] = Queries::WorkPackages::FilterSerializer.dump(query.attributes['filters'])
    end
  end
end
