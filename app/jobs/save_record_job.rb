# class SaveRecordJob
#   include Sidekiq::Job
#
#   POMAGAM_URL = "https://pomagam.pl/"
#
#   def perform(collection_id)
#     binding.pry
#     @collections = Collection.find(collection_id)
#     result = fetch_data
#
#     if result.code == 200
#       @collections.update()
#     end
#   end
#
#   private
#
#   def fetch_data
#     HTTParty.get("#{POMAGAM_URL}/#{@collections.slug}/stats")
#   end
# end
