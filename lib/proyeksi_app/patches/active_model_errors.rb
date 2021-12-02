#-- encoding: UTF-8



# This patch should no longer be necessary.
# But we have references to symbolds_and_messages_for as well as for symbols_for all over
# the code base.
module ProyeksiApp::ActiveModelErrorsPatch
  def symbols_and_messages_for(attribute)
    symbols = details[attribute].map { |e| e[:error] }
    messages = full_messages_for(attribute)

    symbols.zip(messages)
  end

  def symbols_for(attribute)
    details[attribute].map { |r| r[:error] }
  end
end

ActiveModel::Errors.prepend(ProyeksiApp::ActiveModelErrorsPatch)
