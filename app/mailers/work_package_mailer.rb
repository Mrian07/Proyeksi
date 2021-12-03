#-- encoding: UTF-8

class WorkPackageMailer < ApplicationMailer
  helper :mail_notification

  def mentioned(recipient, journal)
    @user = recipient
    @work_package = journal.journable
    @journal = journal

    author = journal.user

    User.execute_as author do
      set_work_package_headers(@work_package)

      message_id journal, recipient
      references journal

      with_locale_for(recipient) do
        mail to: recipient.mail,
             subject: I18n.t(:'mail.mention.subject',
                             user_name: author.name,
                             id: @work_package.id,
                             subject: @work_package.subject)
      end
    end
  end

  def watcher_changed(work_package, user, watcher_changer, action)
    User.execute_as user do
      @work_package = work_package
      @watcher_changer = watcher_changer
      @action = action

      set_work_package_headers(work_package)
      message_id work_package, user
      references work_package

      with_locale_for(user) do
        mail to: user.mail, subject: subject_for_work_package(work_package)
      end
    end
  end

  private

  def subject_for_work_package(work_package)
    "#{work_package.project.name} - #{work_package.status.name} #{work_package.type.name} " +
      "##{work_package.id}: #{work_package.subject}"
  end

  def set_work_package_headers(work_package)
    open_project_headers 'Project' => work_package.project.identifier,
                         'WorkPackage-Id' => work_package.id,
                         'WorkPackage-Author' => work_package.author.login,
                         'Type' => 'WorkPackage'

    if work_package.assigned_to
      open_project_headers 'WorkPackage-Assignee' => work_package.assigned_to.login
    end
  end
end
