//
//  String + Ext.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/27/22.
//

import Foundation

extension String {

    func converToDate() -> Date? {
        let dateFormattor = DateFormatter()
        dateFormattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormattor.locale = Locale(identifier: "en_US_POSIX")
        dateFormattor.timeZone = .current


        return dateFormattor.date(from: self)
    }

    func convertToDisplayFormat() -> String {
        guard let date = self.converToDate() else { return "N/A" }

        return date.convertToMonthYearFormat()
    }
}
