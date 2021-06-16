class UpdateWorker
  include Sidekiq::Worker

  def perform
    BotService.update_all
  end
end
