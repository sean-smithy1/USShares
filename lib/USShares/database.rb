class Database
  require 'sqlite3'
  DATABASE="#{USShares::DATA_DIR}/us_shares.sqlite3"

  def initialize()
    @db.results_as_hash = true
  end

  def build
    #industry Table
sql = <<SQL
    CREATE TABLE IF NOT EXISTS industry(id INTEGER PRIMARY KEY ASC, name TEXT, rank INTEGER);
    CREATE TABLE IF NOT EXISTS industry_ticker(id INTEGER PRIMARY KEY ASC, ind_id INTEGER, ticker TEXT, name TEXT);
SQL

    @db.execute_batch(sql)
  end

  def write_company_cashflow (industry)
    begin
      db=SQLite3::Database.new(DATABASE)
      columns = [:symbol, :period]
      columns << industry[:query][:results][:cashflow][3][:statement][0].keys

      industry[:query][:results][:cashflow].each |ticker| do

        ticker[statement].each |item| do
          sql=db.prepare "INSERT INTO Company_Cashflow "
        end
      end

    rescue SQLite3::Exception => e

      puts "Exception occurred"
      puts e

    ensure
      stm.close if stm
      db.close if db
    end


#    sql=@db.prepare("INSERT or REPLACE INTO Company_Cashflow () VALUES (")
  end

  def write_industry(industry)
      sql=@db.prepare("INSERT or REPLACE INTO industry (id, name) VALUES (#{ industry[:id] }, \"#{ industry[:name] }\" );")
      sql.execute
  end

  def write_industry_tickers(ind_id, company)
      sql=@db.prepare("INSERT or REPLACE INTO industry_ticker (ind_id, ticker, name) VALUES (?, ?, ?);")
      sql.bind_params(ind_id, company[:symbol], company[:name])
      sql.execute()
  end

  def get_known_industries
    sql=@db.prepare("SELECT * FROM known_ind")
    sql.execute
  end

  def get_tickers
    sql=@db.prepare("SELECT ticker FROM industry_ticker WHERE length(ticker) <=4;")
    sql.execute
  end

end
