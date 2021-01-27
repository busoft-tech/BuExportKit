//
//  MediaType.swift
//  Busoft
//
//  Created by Hamza Öztürk on 27.01.2021.
//  Copyright © 2021 Busoft Teknoloji A.Ş. All rights reserved.
//

import Foundation
import MobileCoreServices

public enum MediaType: Equatable, CustomStringConvertible {
    
    case video
    
    init?(utType: String) {
        let kUTType = utType as CFString
        switch kUTType {
        case kUTTypeMovie:
            self = .video
        default:
            return nil
        }
    }
    
    public var description: String {
        switch self {
        case .video:
            return "VIDEO"
        }
    }
    
    public var utType: String {
        switch self {
        case .video:
            return kUTTypeMovie as String
        }
    }
    
    public var isVideo: Bool {
        return self == .video
    }
}
