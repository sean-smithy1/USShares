class Database
  require 'sqlite3'
  DATABASE="#{USShares::DATA_DIR}/us_shares.sqlite3"

  def initialize()

  end

  def build
    db=SQLite3::Database.new(DATABASE)
    #industry Table
sql = <<SQL
    CREATE TABLE IF NOT EXISTS industry(id INTEGER PRIMARY KEY ASC, name TEXT, rank INTEGER);
    CREATE TABLE IF NOT EXISTS industry_ticker(id INTEGER PRIMARY KEY ASC, ind_id INTEGER, ticker TEXT, name TEXT);
SQL

    db.execute_batch(sql)
  end

  def write_company_cashflow (industry)
    begin
      @db=SQLite3::Database.new(DATABASE).results_as_hash

      industry[:query][:results][:cashflow].each do |ticker|
        @columns = [:symbol]
        @values = [ticker[:symbol]]
        if ticker[:statement]
          ticker[:statement].each do |period|
            period.each do |key, value|
              @columns << key
              if value.is_a?(Hash) # If the hash's value is itself a hash
                @values << value[:content] # get the :content key value
              else
                @values << value # otherwise just get the value
              end
            end
          end
        end
      end
      puts "\n\n ** This is the SQL to be Executed ** INSERT INTO Company_Cashflow (#{@columns}) VALUES (#{@values}) \n\n"
#      sql=db.prepare("INSERT INTO Company_Cashflow (#{*@columns}) VALUES (#{*@values}")
#      sql.execute
    rescue SQLite3::Exception => e
      puts "Exception occurred"
      puts e
    ensure
      @db.close if @db
    end
  end

  def write_industry(industry)
    db=SQLite3::Database.new(DATABASE).results_as_hash
      sql=db.prepare("INSERT or REPLACE INTO industry (id, name) VALUES (#{ industry[:id] }, \"#{ industry[:name] }\" );")
      sql.execute
  end

  def write_industry_tickers(ind_id, company)
    db=SQLite3::Database.new(DATABASE).results_as_hash
      sql=db.prepare("INSERT or REPLACE INTO industry_ticker (ind_id, ticker, name) VALUES (?, ?, ?);")
      sql.bind_params(ind_id, company[:symbol], company[:name])
      sql.execute()
  end

  def get_known_industries
    db=SQLite3::Database.new(DATABASE).results_as_hash
    sql=db.prepare("SELECT * FROM known_ind")
    sql.execute
  end

  def get_tickers
    db=SQLite3::Database.new(DATABASE).results_as_hash
    sql=db.prepare("SELECT ticker FROM industry_ticker WHERE length(ticker) <=4;")
    sql.execute
  end

end
