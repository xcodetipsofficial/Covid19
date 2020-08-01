//
//  Country.swift
//  Covid19
//
//  Created by Kyle Wilson on 2020-07-13.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import Foundation

struct Country: Codable {
    
    var country: String
    var updated: Double
    var cases: Double
    var active: Double
    var recovered: Double
    var countryInfo: CountryInfo
}

struct CountryInfo: Codable {
    var _id: Int
    var iso2: String
    var iso3: String
    var lat: Int
    var long: Int
    var flag: String
}
