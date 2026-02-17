//
//  Extensions.swift
//  Utilities
//
//  Created by Ihor Myronishyn on 15.02.2026.
//

import CryptoKit
import Foundation

public extension String {
    /// Converts an ISO8601 string to Date
    func iso8601Date() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }
}

// MARK: - Date

public extension Date {
    /// Converts a Date to a relative string (e.g., "4h", "1d", "Feb 6", "Dec 29, 2025")
    var relativeString: String {
        let now = Date()
        let seconds = Int(now.timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        
        switch seconds {
        case 0..<minute:
            return "\(seconds)s"
        case minute..<hour:
            return "\(seconds / minute)m"
        case hour..<day:
            return "\(seconds / hour)h"
        case day..<(2 * day):
            return "1d"
        case (2 * day)..<(7 * day):
            return "\(seconds / day)d"
        default:
            return self.formattedDate
        }
    }
    
    /// Formats a Date as "MMM d" if current year, else "MMM d, yyyy"
    var formattedDate: String {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let year = calendar.component(.year, from: self)
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = (year == currentYear) ? "MMM d" : "MMM d, yyyy"
        
        return formatter.string(from: self)
    }
}

// MARK: - URL

public extension URL {
    func downloadData() async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: self)
        return data
    }
    
    func localFileURL(in directory: URL) -> URL {
        let hash = SHA256.hash(data: Data(absoluteString.utf8))
            .prefix(8)
            .compactMap({ String(format: "%02x", $0) })
            .joined()
        
        return directory
            .appendingPathComponent(hash, isDirectory: true)
            .appendingPathComponent(lastPathComponent)
    }
}
