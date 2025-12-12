//
//  DateFormattingService.swift
//  GuardianNewsApp
//
//  Created by Interexy on 9.12.25.
//

import UIKit

struct DateFormattingService {    
    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    static func formatISOToDisplay(_ isoString: String) -> String? {
        guard let date = isoFormatter.date(from: isoString) else {
            return nil
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy"
        return displayFormatter.string(from: date)
    }
}

