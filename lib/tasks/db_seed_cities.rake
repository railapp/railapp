namespace :db do
  namespace :seed do

    task :cities => :environment do

      data=[
        "JP", "Tokyo", 32450000, 8014,
        "KR", "Seoul", 20550000, 5076,
        "MX", "Mexico City", 20450000, 7346,
        "US", "New York City", 19750000, 17884,
        "IN","Mumbai", 19200000, 2350,
        "ID", "Jakarta", 18900000, 5100,
        "BR", "Sao Paulo", 18850000, 8479,
        "IN", "Delhi", 18600000, 3182,
        "JP", "Osaka-Kobe-Kyoto", 17375000, 6930,
        "CN", "Shanghai", 16650000, 5177,
        "PH", "Manila", 16300000, 2521,
        "CN", "Hong Kong Shenzhen",15800000,3051,
        "US", "Los Angeles", 15250000, 10780,
        "IN", "Kolkata", 15100000, 1785,
        "RU", "Moscow", 15000000, 14925,
        "EG", "Cairo", 14450000, 1600,
        "AR", "Buenos Aires", 13170000, 10888,
        "UK", "London", 12875000, 11391,
        "CN", "Beijing", 12500000, 6562,
        "PK", "Karachi", 11800000, 1100,
      ]
      
      while data.size>0
        c = City.new
        c.country_id   = data.shift
        c.name         = data.shift
        c.population   = data.shift
        c.area         = data.shift
        c.save!
      end

    end
  end
end
