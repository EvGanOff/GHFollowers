//
//  DateExtentions.swift
//  GHFollowers
//
//  Created by Евгений Ганусенко on 4/27/22.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
