namespace :db do
  namespace :seed do

    task :genders => :environment do

      data=[
        "F","Female",
        "M","Male",
        "T","Transgender",
      ]

      while data.size>0
        g = Gender.new
        g.id          = data.shift
        g.name        = data.shift
        g.save!
      end

    end
  end
end

