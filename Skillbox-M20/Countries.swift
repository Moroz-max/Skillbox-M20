//
//  Countries.swift
//  Skillbox-M20
//
//  Created by Максим Морозов on 28.12.2023.
//

import Foundation

struct Countries {
    
    var countries: [String] = {
        var arrayOfCountries: [String] = []

        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            arrayOfCountries.append(name)
        }

        return arrayOfCountries
    }()
}
