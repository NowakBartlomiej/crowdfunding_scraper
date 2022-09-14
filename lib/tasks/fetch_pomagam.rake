namespace :fetch_pomagam do
  desc "Fetching data from pomagam.pl"
  task fetch_data: :environment do
     Scraper::FetchDataService.new.runner
  end
end