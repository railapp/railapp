namespace :db do
  namespace :seed do
  
    task :provinces => :environment do

      data=[
        "US","AL","Alabama",
        "US","AK","Alaska",
        "US","AS","American Samoa",
        "US","AZ","Arizona",
        "US","AR","Arkansas",
        "US","CA","California",
        "US","CO","Colorado",
        "US","CT","Connecticut",
        "US","DE","Delaware",
        "US","DC","District of Columbia",
        "US","FL","Florida",
        "US","GA","Georgia",
        "US","GU","Guam",
        "US","HI","Hawaii",
        "US","ID","Idaho",
        "US","IL","Illinois",
        "US","IN","Indiana",
        "US","IA","Iowa",
        "US","KS","Kansas",
        "US","KY","Kentucky",
        "US","LA","Louisiana",
        "US","ME","Maine",
        "US","MD","Maryland",
        "US","MA","Massachusetts",
        "US","MI","Michigan",
        "US","MN","Minnesota",
        "US","MP","Mariana Islands",
        "US","MS","Mississippi",
        "US","MO","Missouri",
        "US","MT","Montana",
        "US","NC","North Carolina",
        "US","ND","North Dakota",
        "US","NE","Nebraska",
        "US","NV","Nevada",
        "US","NH","New Hampshire",
        "US","NJ","New Jersey",
        "US","NM","New Mexico",
        "US","NY","New York",
        "US","OH","Ohio",
        "US","OK","Oklahoma",
        "US","OR","Oregon",
        "US","PA","Pennsylvania",
        "US","PR","Puerto Rico",
        "US","RI","Rhode Island",
        "US","SC","South Carolina",
        "US","SD","South Dakota",
        "US","TN","Tennessee",
        "US","TX","Texas",
        "US","UT","Utah",
        "US","VT","Vermont",
        "US","VA","Virginia",
        "US","VI","Virgin Islands",
        "US","WA","Washington",
        "US","WV","West Virginia",
        "US","WI","Wisconsin",
        "US","WY","Wyoming",
        "CA","AB","Alberta",
        "CA","BC","British Columbia",
        "CA","MB","Manitoba",
        "CA","NB","New Brunswick",
        "CA","NL","Newfoundland and Labrador",
        "CA","NS","Nova Scotia",
        "CA","NT","Northwest Territories",
        "CA","NU","Nunavut",
        "CA","ON","Ontario",
        "CA","PE","Prince Edward Island",
        "CA","QC","Quebec",
        "CA","SK","Saskatchewan",
        "CA","YT","Yukon Territory",
      ]

      while data.size>0
        p = Province.new
        code1         = data.shift
        code2         = data.shift
        p.id          = "#{code1}-#{code2}"
        p.country_id  = code1
        p.code        = code2
        p.name        = data.shift
        p.save!
      end

    end
  end
end

