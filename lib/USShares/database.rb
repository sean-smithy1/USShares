class Database


  DATABASE="#{USShares::DATA_DIR}/us_shares.sqlite3"

  def build
    db=SQLite3::Database.new(DATABASE)
    #industry Table
sql = <<SQL
    CREATE TABLE IF NOT EXISTS industry(id INTEGER PRIMARY KEY ASC, name TEXT, rank INTEGER);
    CREATE TABLE IF NOT EXISTS industry_ticker(id INTEGER PRIMARY KEY ASC, ind_id INTEGER, ticker TEXT, name TEXT);
SQL

    db.execute_batch(sql)
  end

  def write_company_cashflow (params)
    begin
      @db=SQLite3::Database.new(DATABASE)
      @db.results_as_hash = true

      place_holders=[ ]
      params[:values].count.times { place_holders << '?' }
      @db.execute("INSERT INTO Company_Cashflow ( #{ params[:columns].join(', ') } ) VALUES ( #{ place_holders.join(', ') } )", params[:values])
      true

    rescue SQLite3::Exception => e
      print "Exception occurred: "
      puts e
      false

    ensure
      @db.close if @db
    end
  end

  def write_company_balancesheet(params)
    begin
      @db=SQLite3::Database.new(DATABASE)
      @db.results_as_hash = true

      place_holders=[ ]
      params[:values].count.times { place_holders << '?' }
      @db.execute("INSERT INTO Company_BalanceSheet ( #{ params[:columns].join(', ') } ) VALUES ( #{ place_holders.join(', ') } )", params[:values])
      true

    rescue SQLite3::Exception => e
      print "Exception occurred: "
      puts e
      false

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

end
