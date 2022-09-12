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

      url = change_url(page, category)
      unparsed_page = HTTParty.get(url)

      while is_next(unparsed_page)
        url = change_url(page, category)

        unparsed_page = HTTParty.get(url)
        parsed_page = Nokogiri::HTML(unparsed_page['html'])

        parsed_page.css(".project-card.extra-shadow").each do |collection_card|
          # DLUZSZE POBIERANIE DANYCH
          slug = collection_card.children[1].attributes["href"].value
          slug_stats_url = basic_url + slug + "/stats"
          request = HTTParty.get(slug_stats_url)
          parsed_stats = to_json(request.body)


          data << {
            # DLUZSZE POBIERANIE DANYCH
            category: category,
            id_collection: collection_card.css("div.content-wrap").css("span")[0].attributes["id"].value[7...].to_i,
            title: collection_card.attributes["title"].value,
            slug: slug,
            amount: parsed_stats[:pledge],
            number_of_donors: parsed_stats[:count],
            percentage: parsed_stats[:percentage]


            # KROTSZE POBIERANIE DANYCH
            # category: category,
            # title: collection_card.attributes["title"].value,
            # slug: collection_card.children[1].attributes["href"].value,
            # id_collection: collection_card.css("div.content-wrap").css("span")[0].attributes["id"].value[7...].to_i,
            # amount:  collection_card.css("div.content-wrap").css("span").children.text
          }

          Collection.create()
          puts data

        end

        page = page + 1

      end

       # puts data
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
