namespace :sum_pomagam do
  desc "summing daily ammounts from database"
  task fetch_data: :environment do
    puts "=============== start  Scraper::FetchDataService=="
    Scraper::FetchDataService.new.sum_daily_amount
    puts "=============== stop Scraper::FetchDataService"
  end
end