

class Attachments::DeleteService < ::BaseServices::Delete
  include Attachments::TouchContainer

  def call(params = nil)
    in_context(model.container || model) do
      perform(params)
    end
  end

  private

  def destroy(attachment)
    super.tap do
      touch(attachment.container) if attachment.container
    end
  end
end
