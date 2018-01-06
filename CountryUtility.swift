//
//  ColorUtility.swift
//  Surprix
//
//  Created by Administrator on 02/01/2018.
//  Copyright © 2018 Luca Giorgetti. All rights reserved.
//

import UIKit

func getCountryNameByCode(code: String) -> String {
    if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: code) {
        return name
    } else if code == "eur" {
        return "Europa"
    } else {
        return code
    }
}
