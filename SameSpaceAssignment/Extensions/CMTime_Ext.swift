//
//  CMTime_Ext.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import AVFoundation

extension CMTime {
    var minStr: String? {
        let minutes = self.seconds / 60
        return minutes.formattedString
    }
    
    var secStr: String? {
        let seconds = self.seconds.truncatingRemainder(dividingBy: 60)
        return seconds.formattedString
    }
}
