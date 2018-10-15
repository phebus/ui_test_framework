require 'mail'
require 'retriable'

class Mailer
  include Mail

  def initialize(username:, password:)
    Mail.defaults do
      retriever_method(:imap,
                       address: EnvSettings.configs.api.email.address,
                       port: EnvSettings.configs.api.email.port,
                       enable_ssl: EnvSettings.configs.api.email.enable_ssl,
                       user_name: username,
                       password: password)
    end
  end

  def read_all
    Mail.find(what: :last, count: 100, order: :asc, keys: 'UNSEEN') do |_email, imap, uid|
      imap.uid_store(uid, '+FLAGS', [Net::IMAP::SEEN])
    end
  end

  def find_email(keys:, count: 5, what: :last, delete: false, retriable_settings: {})
    keys              = keys_builder(keys)
    tries             = retriable_settings.fetch(:tries, 100)
    max_elapsed_time  = retriable_settings.fetch(:max_elapsed_time, 600)

    Retriable.retriable on: StandardError, tries: tries, max_elapsed_time: max_elapsed_time do
      mail = Mail.find(what: what, count: count, keys: keys, delete_after_find: delete).last

      fail "Email may not have sent\n\nSearched by: #{keys}" if mail.nil?

      mail
    end
  end

  private

  # NOTE: https://tools.ietf.org/html/rfc3501#section-6.4.4 Search keys
  def method_missing(method, *args, &block)
    return super unless method.to_s =~ /^find_by_(.*)$/

    key = $1.delete('_').upcase
    key_value = args.shift
    options = args.first.nil? ? {} : args.first
    retriable_settings = { tries: options.fetch(:tries, 100),
                           max_elapsed_time: options.fetch(:max_elapsed_time, 300) }

    find_email(keys: [key, key_value],
               count: options.fetch(:count, 5),
               what: options.fetch(:what, :last),
               retriable_settings: retriable_settings)
  end

  def respond_to_missing?(method_name, _include_private = false)
    method_name.to_s.start_with?('find_by_') || super
  end

  def keys_builder(keys)
    keys << 'UNSEEN'
  end
end
