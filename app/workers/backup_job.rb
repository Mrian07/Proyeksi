#-- encoding: UTF-8



require 'tempfile'
require 'zip'

class BackupJob < ::ApplicationJob
  queue_with_priority :low

  attr_reader :backup, :user

  def perform(
    backup:,
    user:,
    include_attachments: Backup.include_attachments?,
    attachment_size_max_sum_mb: Backup.attachment_size_max_sum_mb
  )
    @backup = backup
    @user = user
    @include_attachments = include_attachments
    @attachment_size_max_sum_mb = attachment_size_max_sum_mb

    run_backup!
  rescue StandardError => e
    failure! error: e.message

    raise e
  ensure
    remove_files! db_dump_file_name, archive_file_name

    backup.attachments.each(&:destroy) unless success?

    Rails.logger.info(
      "BackupJob(include_attachments: #{include_attachments}) finished " \
      "with status #{job_status.status} " \
      "(dumped: #{dumped?}, archived: #{archived?})"
    )
  end

  def run_backup!
    @dumped = dump_database! db_dump_file_name # sets error on failure

    return unless dumped?

    file_name = create_backup_archive!(
      file_name: archive_file_name,
      db_dump_file_name: db_dump_file_name
    )

    store_backup file_name, backup: backup, user: user
    cleanup_previous_backups!

    UserMailer.backup_ready(user).deliver_later
  end

  def dumped?
    @dumped
  end

  def archived?
    @archived
  end

  def db_dump_file_name
    @db_dump_file_name ||= tmp_file_name "proyeksiapp", ".sql"
  end

  def archive_file_name
    @archive_file_name ||= tmp_file_name "proyeksiapp-backup", ".zip"
  end

  def status_reference
    arguments.first[:backup]
  end

  def updates_own_status?
    true
  end

  def cleanup_previous_backups!
    Backup.where.not(id: backup.id).destroy_all
  end

  def success?
    job_status.status == JobStatus::Status.statuses[:success]
  end

  def remove_files!(*files)
    Array(files).each do |file|
      FileUtils.rm file if File.exists? file
    end
  end

  def store_backup(file_name, backup:, user:)
    File.open(file_name) do |file|
      call = Attachments::CreateService
        .bypass_whitelist(user: user)
        .call(container: backup, filename: file_name, file: file, description: 'ProyeksiApp backup')

      call.on_success do
        download_url = ::API::V3::Utilities::PathHelper::ApiV3Path.attachment_content(call.result.id)

        upsert_status(
          status: :success,
          message: I18n.t('export.succeeded'),
          payload: download_payload(download_url)
        )
      end

      call.on_failure do
        upsert_status status: :failure,
                      message: I18n.t('export.failed', message: call.message)
      end
    end
  end

  def create_backup_archive!(file_name:, db_dump_file_name:, attachments: attachments_to_include)
    Zip::File.open(file_name, Zip::File::CREATE) do |zipfile|
      attachments.each do |attachment|
        # If an attachment is destroyed on disk, skip i
        diskfile = attachment.diskfile
        next unless diskfile

        path = diskfile.path

        zipfile.add "attachment/file/#{attachment.id}/#{attachment[:file]}", path
      end

      zipfile.get_output_stream("proyeksiapp.sql") { |f| f.write File.read(db_dump_file_name) }
    end

    @archived = true

    file_name
  end

  def attachments_to_include
    return Attachment.none if skip_attachments?

    Backup.attachments_query
  end

  def skip_attachments?
    !(include_attachments? && Backup.attachments_size_in_bounds?(max: attachment_size_max_sum_mb))
  end

  def date_tag
    Time.zone.today.iso8601
  end

  def tmp_file_name(name, ext)
    file = Tempfile.new [name, ext]

    file.path
  ensure
    file.close
    file.unlink
  end

  def include_attachments?
    @include_attachments
  end

  def attachment_size_max_sum_mb
    @attachment_size_max_sum_mb
  end

  def dump_database!(path)
    _out, err, st = Open3.capture3 pg_env, dump_command(path)

    failure! error: err unless st.success?

    st.success?
  end

  def dump_command(output_file_path)
    "pg_dump -x -O -f '#{output_file_path}'"
  end

  def success!
    payload = download_payload(url_helpers.backups_path(target_project))

    if errors.any?
      payload[:errors] = errors
    end

    upsert_status status: :success,
                  message: I18n.t('copy_project.succeeded', target_project_name: target_project.name),
                  payload: payload
  end

  def failure!(error: nil)
    msg = I18n.t 'backup.failed'

    upsert_status(
      status: :failure,
      message: error.present? ? "#{msg}: #{error}" : msg
    )
  end

  def pg_env
    config = ActiveRecord::Base.connection_db_config.configuration_hash
    entries = pg_env_to_connection_config.map do |key, config_key|
      value = config[config_key].to_s

      [key.to_s, value] if value.present?
    end

    entries.compact.to_h
  end

  ##
  # Maps the PG env variable name to the key in the AR connection config.
  def pg_env_to_connection_config
    {
      PGHOST: :host,
      PGPORT: :port,
      PGUSER: :username,
      PGPASSWORD: :password,
      PGDATABASE: :database
    }
  end
end
