//
//  Utility.swift
//  ZonkyStatistics
//
//  Created by Sadi on 13/01/2019.
//  Copyright © 2019 Sadi. All rights reserved.
//

import Foundation
import Charts

public class MonthValueFormatter: NSObject, IAxisValueFormatter {
    override init() {
        super.init()
    }
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let d = Date(milliseconds: value)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM"
        return df.string(from:d)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()
}
