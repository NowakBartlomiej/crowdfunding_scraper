require 'nokogiri'
require 'httparty'


module Scraper
  class FetchDataService
    POPULARNE = "popularne" #14 stron
    LECZENIE = "leczenie" #704 stron
    POTRZEBY = "potrzeby" #970 stron
    ZWIERZETA = "zwierzeta" # 1755 stron
    PROJEKTY = "projekty" # 992 stron

    # Lacznie około stron: 4435
    # Lacznie około zbiorek: 26610

    def runner
      get_data_from_category(POPULARNE)
      get_data_from_category(LECZENIE)
      get_data_from_category(POTRZEBY)
      get_data_from_category(ZWIERZETA)
      get_data_from_category(PROJEKTY)
    end

    def sum_daily_amount
      sum = Collection.sum(:amount)
      DailySummary.create(daily_sum: sum)
    end

    def data
      @data ||= []
    end


    def change_url(page, category)
      "https://pomagam.pl/t/#{category}?current_page=#{page}&type=category_projects"
    end

    def get_data_from_category(category)
      page = 0
      basic_url = "https://pomagam.pl"
      #i = 1

      url = change_url(page, category)
      unparsed_page = HTTParty.get(url)

      while is_next(unparsed_page)
        url = change_url(page, category)

        unparsed_page = HTTParty.get(url)
        parsed_page = Nokogiri::HTML(unparsed_page['html'])

        parsed_page.css(".project-card.extra-shadow").each do |collection_card|


          data = {
            # number: i,
            category: category,
            title: collection_card.attributes["title"].value,
            slug: collection_card.children[1].attributes["href"].value,
            external_collection_id: collection_card.css("div.content-wrap").css("span")[0].attributes["id"].value[7...],
            #amount:  collection_card.css("div.content-wrap").css("span").children.text
            amount:  format_amount_to_int(collection_card.css("div.content-wrap").css("span").children.text)
          }
          # i = i + 1


          # data.each do |fetched_data_collection|

            # collections = Collection.find_by(external_collection_id: fetched_data_collection[:external_collection_id])
            # if collections
            #   next if collections.updated_at.to_date == Time.current.to_date
            #
            #   # Collection.update(parse_data(fetched_data_collection).except(:external_collection_id))
            #   Collection.update(collection_update_data(fetched_data_collection))
            # else
            #   # Collection.create(parse_data(fetched_data_collection))
            #
            #   Collection.create(collection_create_data(fetched_data_collection))
            # end

            # binding.pry
            Collection.upsert(data, unique_by: :index_collections_on_external_collection_id)

          # end
        end

        page = page + 1
      end



      # puts data
    end

    def collection_update_data(data)
      {
        **collection_create_data(data),
        external_collection_id: data[:external_collection_id],
      }
    end

    def format_amount_to_int(amount)
      amount.to_s
      amount.tr('^0-9', '')

    end

    def collection_create_data(data)
      {
        category: data[:category],
        slug: data[:slug],
        amount: data[:amount],
        external_collection_id: data[:external_collection_id],
        title: data[:title]
      }
    end

    def to_json(body)
      JSON.parse(body, symbolize_names: true)
    end

    def is_next(unparsed_page)
      unparsed_text = unparsed_page.to_s
      if unparsed_text.include? "\"has_next\": true"
        true
      else
        false
      end
    end

    end
  end
