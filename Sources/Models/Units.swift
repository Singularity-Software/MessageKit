//
//  Units.swift
//  MessageKit
//
//  Created by kelvin lee wei sern on 10/07/2020.
//  Copyright © 2020 MessageKit. All rights reserved.
//

import Foundation

public struct Units {
    
    public let bytes: Int
    
    public var kilobytes: Double {
        return Double(bytes) / 1_024
    }
    
    public var megabytes: Double {
        return kilobytes / 1_024
    }
    
    public var gigabytes: Double {
        return megabytes / 1_024
    }
    
    public init(bytes: Int) {
        self.bytes = bytes
    }
    
    public func getReadableUnit() -> String {
        
        switch bytes {
            case 0..<1_024:
                return "\(bytes) bytes"
            case 1_024..<(1_024 * 1_024):
                return "\(String(format: "%.2f", kilobytes)) kb"
            case 1_024..<(1_024 * 1_024 * 1_024):
                return "\(String(format: "%.2f", megabytes)) mb"
            case (1_024 * 1_024 * 1_024)...Int.max:
                return "\(String(format: "%.2f", gigabytes)) gb"
            default:
                return "\(bytes) bytes"
        }
    }
}
