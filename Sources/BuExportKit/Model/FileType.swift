//
//  FileType.swift
//  Busoft
//
//  Created by Hamza Öztürk on 27.01.2021.
//  Copyright © 2021 Busoft Teknoloji A.Ş. All rights reserved.
//

import Foundation
import MobileCoreServices

enum FileType: Equatable {
    
    case mp4
    
    var fileExtension: String {
        switch self {
        case .mp4:
            return ".mp4"
        }
    }
    
    var utType: CFString {
        switch self {
        case .mp4:
            return kUTTypeMPEG4
        }
    }
}
