import Foundation

//Constants file to specifically hold key/identifiers that should not change.

struct Constants {
    struct pickerValues{
        static let usStates = ["AK - Alaska",
                               "AL - Alabama",
                               "AR - Arkansas",
                               "AZ - Arizona",
                               "CA - California",
                               "CO - Colorado",
                               "CT - Connecticut",
                               "DC - District of Columbia",
                               "DE - Delaware",
                               "FL - Florida",
                               "GA - Georgia",
                               "HI - Hawaii",
                               "IA - Iowa",
                               "ID - Idaho",
                               "IL - Illinois",
                               "IN - Indiana",
                               "KS - Kansas",
                               "KY - Kentucky",
                               "LA - Louisiana",
                               "MA - Massachusetts",
                               "MD - Maryland",
                               "ME - Maine",
                               "MI - Michigan",
                               "MN - Minnesota",
                               "MO - Missouri",
                               "MS - Mississippi",
                               "MT - Montana",
                               "NC - North Carolina",
                               "ND - North Dakota",
                               "NE - Nebraska",
                               "NH - New Hampshire",
                               "NJ - New Jersey",
                               "NM - New Mexico",
                               "NV - Nevada",
                               "NY - New York",
                               "OH - Ohio",
                               "OK - Oklahoma",
                               "OR - Oregon",
                               "PA - Pennsylvania",
                               "RI - Rhode Island",
                               "SC - South Carolina",
                               "SD - South Dakota",
                               "TN - Tennessee",
                               "TX - Texas",
                               "UT - Utah",
                               "VA - Virginia",
                               "VT - Vermont",
                               "WA - Washington",
                               "WI - Wisconsin",
                               "WV - West Virginia",
                               "WY - Wyoming"]
    }



    //Identifiers assigned to Scene's on Storyboard.
    struct StoryboardIdentifiers {
        static let storyboardIdentifier = "Main"
        static let primaryWeatherViewControllerIdentifier = "PrimaryWeatherViewControllerIdentifier"
        static let settingsViewControllerIdentifier = "SettingsViewControllerIdentifier"
    }
    
    
    struct OpenWeatherKeys {
        static let APIKEY = "d2bbe6f03b030bf85baebbd7e270fba0"
        static let UNITKEY = "imperial"
    }
    
    //Keys used for data from UserDefaults
    struct UserDefaultKeys{
        static let scientificSegmentControlKey = "TEMPERATURE_UNIT_KEY"
        static let previousSearchKey = "PREVIOUS_SEARCH_KEY"
    }
}
