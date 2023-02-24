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
    
    static func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}
