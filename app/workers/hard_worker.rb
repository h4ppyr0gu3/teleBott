class HardWorker
  include Sidekiq::Worker
  require 'telegram/bot'
  def perform
    BotService.update_all
    BotService.Cron
  end
end
