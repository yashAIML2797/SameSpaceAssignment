//
//  Double_Ext.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import Foundation

extension Double {
    var formattedString: String? {
        let timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        
        return timeformatter.string(from: NSNumber(value: self))
    }
}
