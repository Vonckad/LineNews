//
//  Utils.swift
//  LineNews
//
//  Created by Vlad Ralovich on 20.02.2023.
//

import Foundation

class Utils {
    
    static func getFormattedDate(_ string: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "RUS")
        dateFormatterPrint.dateFormat = "dd MMMM"

        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!)
    }
}
