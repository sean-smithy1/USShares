#!/usr/bin/env ruby
module USShares
  VERSION = '0.0.1'
  DATA_DIR = "./data"

  require 'open-uri'
  require 'json'
  require 'net/http'
  require 'sqlite3'

  require_relative 'USShares/database'
  require_relative 'USShares/yahoo'

  system('clear') || system('cls')

  @db=Database.new
  @db.build if File.file?('data/us_shares.sqlite3')

  #Industries
    if ARGV[0] == "industry"
      industries=Yahoo.industries
      unless industries[:query][:results][:industry].nil?
        industries[:query][:results][:industry].each do |industry|
          @db.write_industry(industry)
        end
      else
        p "Yahoo returned an empty industry hash for some reason"
      end
    end

  if ARGV[0] == "tickers"
    @db.get_known_industries.each do |rec|
      companies=JSON.parse(Yahoo.industry_company_cashflow(rec['id']), symbolize_names: true)
      unless companies[:cashflow].nil?
        companies[:query][:results][:industry][:company].each do |company|
          @db.write_industry_tickers(rec['id'], company)
        end
      end
    end
  end
end
