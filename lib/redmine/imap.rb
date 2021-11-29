#-- encoding: UTF-8



require 'net/imap'

module Redmine
  module IMAP
    class << self
      def check(imap_options = {}, options = {})
        folder = imap_options[:folder] || 'INBOX'
        imap = connect_imap(imap_options)

        imap.select(folder)
        imap.search(['NOT', 'SEEN']).each do |message_id|
          receive(message_id, imap, imap_options, options)
        end

        imap.expunge
      end

      private

      def connect_imap(imap_options)
        host = imap_options[:host] || '127.0.0.1'
        port = imap_options[:port] || '143'
        ssl = ssl_option(imap_options)
        imap = Net::IMAP.new(host, port, ssl)

        imap.login(imap_options[:username], imap_options[:password]) unless imap_options[:username].nil?

        imap
      end

      def ssl_option(imap_options)
        return false if imap_options[:ssl] == false # don't use SSL

        if imap_options[:ssl_verification] == false
          { verify_mode: OpenSSL::SSL::VERIFY_NONE } # use SSL without verification
        else
          true # use SSL with verification
        end
      end

      def receive(message_id, imap, imap_options, options)
        msg = imap.fetch(message_id, 'RFC822')[0].attr['RFC822']
        raise "Message was not successfully handled." unless MailHandler.receive(msg, options)

        message_received(message_id, imap, imap_options)
      rescue StandardError => e
        Rails.logger.error { "Message #{message_id} resulted in error #{e} #{e.message}" }
        message_error(message_id, imap, imap_options)
      end

      def message_received(message_id, imap, imap_options)
        log_debug { "Message #{message_id} successfully received" }

        if imap_options[:move_on_success]
          imap.copy(message_id, imap_options[:move_on_success])
        end

        imap.store(message_id, '+FLAGS', %i[Seen Deleted])
      end

      def message_error(message_id, imap, imap_options)
        log_debug { "Message #{message_id} can not be processed" }

        imap.store(message_id, '+FLAGS', [:Seen])

        if imap_options[:move_on_failure]
          imap.copy(message_id, imap_options[:move_on_failure])
          imap.store(message_id, '+FLAGS', [:Deleted])
        end
      end

      def log_debug(&_message)
        logger.debug(yield) if logger && logger.debug?
      end

      def logger
        Rails.logger
      end
    end
  end
end
