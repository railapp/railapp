namespace :db do
  namespace :seed do
  
    task :countries => :environment do

      data=[
        "AD","Andorra, Principality of",
        "AE","United Arab Emirates",
        "AF","Afghanistan, Islamic State of",
        "AG","Antigua and Barbuda",
        "AI","Anguilla",
        "AL","Albania",
        "AM","Armenia",
        "AN","Netherlands Antilles",
        "AO","Angola",
        "AQ","Antarctica",
        "AR","Argentina",
        "AS","American Samoa",
        "AT","Austria",
        "AU","Australia",
        "AW","Aruba",
        "AZ","Azerbaidjan",
        "BA","Bosnia-Herzegovina",
        "BB","Barbados",
        "BD","Bangladesh",
        "BE","Belgium",
        "BF","Burkina Faso",
        "BG","Bulgaria",
        "BH","Bahrain",
        "BI","Burundi",
        "BJ","Benin",
        "BM","Bermuda",
        "BN","Brunei Darussalam",
        "BO","Bolivia",
        "BR","Brazil",
        "BS","Bahamas",
        "BT","Bhutan",
        "BV","Bouvet Island",
        "BW","Botswana",
        "BY","Belarus",
        "BZ","Belize",
        "CA","Canada",
        "CC","Cocos Keeling Islands",
        "CF","Central African Republic",
        "CD","Congo, The Democratic Republic of the",
        "CG","Congo",
        "CH","Switzerland",
        "CI","Ivory Coast Cote D'Ivoire",
        "CK","Cook Islands",
        "CL","Chile",
        "CM","Cameroon",
        "CN","China",
        "CO","Colombia",
        "CR","Costa Rica",
        "CS","Former Czechoslovakia",
        "CU","Cuba",
        "CV","Cape Verde",
        "CX","Christmas Island",
        "CY","Cyprus",
        "CZ","Czech Republic",
        "DE","Germany",
        "DJ","Djibouti",
        "DK","Denmark",
        "DM","Dominica",
        "DO","Dominican Republic",
        "DZ","Algeria",
        "EC","Ecuador",
        "EE","Estonia",
        "EG","Egypt",
        "EH","Western Sahara",
        "ER","Eritrea",
        "ES","Spain",
        "ET","Ethiopia",
        "FI","Finland",
        "FJ","Fiji",
        "FK","Falkland Islands",
        "FM","Micronesia",
        "FO","Faroe Islands",
        "FR","France",
        "FX","France European Territory",
        "GA","Gabon",
        "GB","Great Britain",
        "GD","Grenada",
        "GE","Georgia",
        "GF","French Guyana",
        "GH","Ghana",
        "GI","Gibraltar",
        "GL","Greenland",
        "GM","Gambia",
        "GN","Guinea",
        "GP","Guadeloupe French",
        "GQ","Equatorial Guinea",
        "GR","Greece",
        "GS","S. Georgia & S. Sandwich Isls.",
        "GT","Guatemala",
        "GU","Guam USA",
        "GW","Guinea Bissau",
        "GY","Guyana",
        "HK","Hong Kong",
        "HM","Heard and McDonald Islands",
        "HN","Honduras",
        "HR","Croatia",
        "HT","Haiti",
        "HU","Hungary",
        "ID","Indonesia",
        "IE","Ireland",
        "IL","Israel",
        "IN","India",
        "IO","British Indian Ocean Territory",
        "IQ","Iraq",
        "IR","Iran",
        "IS","Iceland",
        "IT","Italy",
        "JM","Jamaica",
        "JO","Jordan",
        "JP","Japan",
        "KE","Kenya",
        "KG","Kyrgyz Republic Kyrgyzstan",
        "KH","Cambodia, Kingdom of",
        "KI","Kiribati",
        "KM","Comoros",
        "KN","Saint Kitts & Nevis Anguilla",
        "KP","North Korea",
        "KR","South Korea",
        "KW","Kuwait",
        "KY","Cayman Islands",
        "KZ","Kazakhstan",
        "LA","Laos",
        "LB","Lebanon",
        "LC","Saint Lucia",
        "LI","Liechtenstein",
        "LK","Sri Lanka",
        "LR","Liberia",
        "LS","Lesotho",
        "LT","Lithuania",
        "LU","Luxembourg",
        "LV","Latvia",
        "LY","Libya",
        "MA","Morocco",
        "MC","Monaco",
        "MD","Moldavia",
        "MG","Madagascar",
        "MH","Marshall Islands",
        "MK","Macedonia",
        "ML","Mali",
        "MM","Myanmar",
        "MN","Mongolia",
        "MO","Macau",
        "MP","Northern Mariana Islands",
        "MQ","Martinique French",
        "MR","Mauritania",
        "MS","Montserrat",
        "MT","Malta",
        "MU","Mauritius",
        "MV","Maldives",
        "MW","Malawi",
        "MX","Mexico",
        "MY","Malaysia",
        "MZ","Mozambique",
        "NA","Namibia",
        "NC","New Caledonia French",
        "NE","Niger",
        "NF","Norfolk Island",
        "NG","Nigeria",
        "NI","Nicaragua",
        "NL","Netherlands",
        "NO","Norway",
        "NP","Nepal",
        "NR","Nauru",
        "NT","Neutral Zone",
        "NU","Niue",
        "NZ","New Zealand",
        "OM","Oman",
        "PA","Panama",
        "PE","Peru",
        "PF","Polynesia French",
        "PG","Papua New Guinea",
        "PH","Philippines",
        "PK","Pakistan",
        "PL","Poland",
        "PM","Saint Pierre and Miquelon",
        "PN","Pitcairn Island",
        "PR","Puerto Rico",
        "PT","Portugal",
        "PW","Palau",
        "PY","Paraguay",
        "QA","Qatar",
        "RE","Reunion French",
        "RO","Romania",
        "RU","Russian Federation",
        "RW","Rwanda",
        "SA","Saudi Arabia",
        "SB","Solomon Islands",
        "SC","Seychelles",
        "SD","Sudan",
        "SE","Sweden",
        "SG","Singapore",
        "SH","Saint Helena",
        "SI","Slovenia",
        "SJ","Svalbard and Jan Mayen Islands",
        "SK","Slovak Republic",
        "SL","Sierra Leone",
        "SM","San Marino",
        "SN","Senegal",
        "SO","Somalia",
        "SR","Suriname",
        "ST","Saint Tome Sao Tome and Principe",
        "SU","Former USSR",
        "SV","El Salvador",
        "SY","Syria",
        "SZ","Swaziland",
        "TC","Turks and Caicos Islands",
        "TD","Chad",
        "TF","French Southern Territories",
        "TG","Togo",
        "TH","Thailand",
        "TJ","Tadjikistan",
        "TK","Tokelau",
        "TM","Turkmenistan",
        "TN","Tunisia",
        "TO","Tonga",
        "TP","East Timor",
        "TR","Turkey",
        "TT","Trinidad and Tobago",
        "TV","Tuvalu",
        "TW","Taiwan",
        "TZ","Tanzania",
        "UA","Ukraine",
        "UG","Uganda",
        "UK","United Kingdom",
        "UM","USA Minor Outlying Islands",
        "US","United States",
        "UY","Uruguay",
        "UZ","Uzbekistan",
        "VA","Holy See Vatican City State",
        "VC","Saint Vincent & Grenadines",
        "VE","Venezuela",
        "VG","Virgin Islands British",
        "VI","Virgin Islands USA",
        "VN","Vietnam",
        "VU","Vanuatu",
        "WF","Wallis and Futuna Islands",
        "WS","Samoa",
        "YE","Yemen",
        "YT","Mayotte",
        "YU","Yugoslavia",
        "ZA","South Africa",
        "ZM","Zambia",
        "ZR","Zaire",
        "ZW","Zimbabwe"
      ]

      while data.size>0
        c = Country.new
        c.id   = data.shift
        c.name = data.shift
        c.save!
      end

    end
  end
end
