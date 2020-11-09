//
//  CheckInSession.swift
//  SIS App
//
//  Created by Wang Yunze on 8/11/20.
//

import Foundation

struct Day: Identifiable {
    var id = UUID()
    var date: Date
    var sessions: [CheckInSession]
    
    var formattedDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM y"
            
            return formatter.string(from: date)
        }
    }
}

struct CheckInSession {
    var checkedIn: Date
    var checkedOut: Date
    var room: Room
    
    var formattedTiming: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            
            let formatted = "\(formatter.string(from: checkedIn)) - \(formatter.string(from: checkedOut))"
        
            return formatted
        }
    }
}

extension CheckInSession: Identifiable {
    var id: String { room.id }
}