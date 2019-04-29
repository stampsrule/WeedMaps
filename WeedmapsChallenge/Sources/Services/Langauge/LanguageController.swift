//
//  LanguageController.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/27/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

struct LanguageController {
    static var localizationIdenifier: String? {
        
        let current = Locale.current
        var loaclID = Locale.preferredLanguages.first?.replacingOccurrences(of: "-", with: "_")
        
        if let language = current.languageCode,
            let region = current.regionCode {
            loaclID = language + "_" + region
        }
        
        return loaclID
    }
}
