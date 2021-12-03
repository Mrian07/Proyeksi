#-- encoding: UTF-8



namespace :attachments do
  desc 'Clear all attachments created before yesterday'
  task clear: [:environment] do
    CarrierWave.clean_cached_files!
  end

  desc 'Copies all attachments from the current to the given storage.'
  task :copy_to, [:to] => :environment do |_task, args|
    if args.empty?
      puts 'rake attachments:copy_to[file|fog]'
      exit 1
    end

    storage_name = args[:to].to_sym
    current_uploader = ProyeksiApp::Configuration.file_uploader
    target_uploader = ProyeksiApp::Configuration.available_file_uploaders[storage_name]

    if target_uploader.nil?
      puts "unknown storage: #{args[:to]}"
      exit 1
    end

    if target_uploader == current_uploader
      puts "attachments already in #{target_uploader} storage"
      exit 1
    end

    if target_uploader == :fog && (
         ProyeksiApp::Configuration.fog_credentials.empty? ||
         ProyeksiApp::Configuration.fog_directory.nil?)
      puts 'the fog storage is not configured'
      exit 1
    end

    target_attachment = Class.new(Attachment) do
      def self.store_all!(attachments)
        attachments.each_with_index do |attachment, index|
          print "Copying attachment #{attachment.id} [#{index + 1}/#{attachments.size}] \
                 (#{attachment.file.path}) ... ".squish
          STDOUT.flush

          if store! attachment
            puts ' ok'
          else
            puts ' failed (missing file)'
          end
        end
      end

      ##
      # Given an attachment using the source uploader creates a TargetAttachment
      # which uses the destination uploader to store the original attachment's
      # file in the target location.
      def self.store!(attachment)
        return nil unless attachment.attributes['file'].present? &&
                          File.exists?(attachment.file.path)

        new.tap do |target|
          target.id = attachment.id
          target.file = attachment.file.local_file
          target.file.store!
        end
      end

      ##
      # Pretends to be a plain old Attachment in order not to break store paths.
      def self.to_s
        'attachment'
      end
    end

    attachments = Attachment.all

    puts "Copying #{attachments.size} attachments to #{storage_name}."
    puts

    target_attachment.mount_uploader :file, target_uploader
    target_attachment.store_all! attachments
  end

  desc 'Extract text content from attachment that were not extracted yet synchronously.'
  task extract_fulltext_where_missing: :environment do
    Attachment.extract_fulltext_where_missing(run_now: true)
  end

  desc 'Extract text content from attachment that were not extracted yet.'
  task schedule_fulltext_extraction_where_missing: :environment do
    Attachment.extract_fulltext_where_missing(run_now: false)
  end

  desc 'Extracts fulltext of all attachments and provide it for attachment filter even if that attachment has been \
        extracted before.'
  task force_extract_fulltext: :environment do
    Attachment.force_extract_fulltext
  end
end
