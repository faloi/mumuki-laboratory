logger = Mumukit::Nuntius::Logger

namespace :messages do
  task listen: :environment do
    logger.info 'Listening to messages'

    Mumukit::Nuntius::Consumer.start 'teacher-messages', 'teacher-messages' do |_delivery_info, _properties, body|
      begin
        Message.import_from_json!(body)
      rescue ActiveRecord::RecordInvalid => e
        logger.info e
      end
    end
  end
end