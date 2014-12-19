mmodule Yahoo

HOST = "https://query.yahooapis.com/v1/public/yql?q="
OPTIONS = "&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="

  def Yahoo.industries
    query=URI.encode("SELECT * FROM yahoo.finance.industry WHERE id IN (SELECT industry.id FROM yahoo.finance.sectors)")
    url="#{Yahoo::HOST}#{query}#{Yahoo::OPTIONS}"
    begin
      JSON.parse(Net::HTTP.get_response(URI.parse(url)).body, symbolize_names: true)
    rescue
      print "Connection error."
    end
  end

  def Yahoo.companies_by_industry(id)
    #Use YahooAPIS
    open("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.industry%20where%20id%3D%22#{id}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=").read
  end

  def Yahoo.industry_company_cashflow(id)
    query=URI.encode("SELECT * FROM yahoo.finance.cashflow WHERE symbol IN (SELECT company.symbol FROM yahoo.finance.industry WHERE id = '#{id}' AND company.symbol MATCHES '^[A-Z]{3,4}$')")
    url="#{Yahoo::HOST}#{query}#{Yahoo::OPTIONS}"
    begin
      JSON.parse(Net::HTTP.get_response(URI.parse(url)).body, symbolize_names: true)
    rescue
      print "Connection error."
    end
  end

  def Yahoo.industry_company_balancesheet(id)
    query=URI.encode("SELECT * FROM yahoo.finance.balancesheet WHERE symbol IN (SELECT company.symbol FROM yahoo.finance.industry WHERE id = '#{id}' AND company.symbol MATCHES '^[A-Z]{3,4}$')")
    url="#{Yahoo::HOST}#{query}#{Yahoo::OPTIONS}"
    begin
      JSON.parse(Net::HTTP.get_response(URI.parse(url)).body, symbolize_names: true)
    rescue
      print "Connection error."
    end
  end

  def Yahoo.return_on_investment_capital

  end

end
