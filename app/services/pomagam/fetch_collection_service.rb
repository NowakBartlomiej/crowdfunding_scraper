require 'pry'
require 'nokogiri'
require 'json'
require 'active_support/all'
require 'active_support/core_ext/hash'
require 'httparty'

module Pomagam
  class FetchCollectionService
    IGNORED_PAGES = [
      'https://pomagam.pl/',
      'https://pomagam.pl/pytania',
      'https://pomagam.pl/regulamin',
      'https://pomagam.pl/polityka-prywatnosci',
      'https://pomagam.pl/info',
      'https://pomagam.pl/oplaty',
      'https://pomagam.pl/dla-ngo',
      'https://pomagam.pl/konkrahenci-rodo',
      'https://pomagam.pl/rekrutacja',
      'https://pomagam.pl/rekrutacja/python-developer',
      'https://pomagam.pl/blog'
    ].freeze
    SITE_URL = "https://pomagam.pl/"

    def stats_url(slug)
      "#{SITE_URL}#{slug}/stats"
    end

    def runner
      file_name = "/Users/bartlomiejnowak/Documents/rails/crowdfunding_scraper/app/services/pomagam/pomagam.xml"

      xml = Nokogiri::XML(File.open(file_name))

      links = xml.css('loc').select{|loc|  loc.text}.join" "

      links_array = links.split(' ')

      links_array.reject! { |link| link.match(/\/(t|ts|blog)\//) }

      links_array = links_array - IGNORED_PAGES

      links_array.map! do |link|
        link.split('/').last
      end

      links_array.each do |slug|
        request = HTTParty.get(stats_url(slug))

        # data.append(JSON.parse(request.body))

        parsed_body = to_json(request.body)
        # puts JSON.parse(request.body)
        #   request
        # binding.pry
        # Table name
        data << parse_response(slug, parsed_body)
        Collection.create(data)
      end
    end

    # Metody
    def parse_response(slug, response)
      {
        slug: slug,
        amount: response[:pledge],
        donator: response[:count],
        percentage: response[:percentage],
        # **JSON.parse(request.body, symbolize_names: true)
      }
    end

    def data
      @data ||= []
    end

    def to_json(body)
      JSON.parse(body, symbolize_names: true)
    end

  end
end
