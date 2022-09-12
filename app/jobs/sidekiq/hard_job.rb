class HardJob
  include Sidekiq::Job

  def perform(collection_id)
    @collection = Collection.find(collection_id)
  end

  private

  def get_stats
    HTTParty.get("#{@collction.slug}/stats")
  end
end
