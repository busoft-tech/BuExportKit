//
//  BuExportError.swift
//  Busoft
//
//  Created by Hamza Öztürk on 27.01.2021.
//  Copyright © 2021 Busoft Teknoloji A.Ş. All rights reserved.
//

import Foundation

public enum BuExportError: Error {
    
    case invalidMediaType
    case invalidInfo
    case invalidURL
    case invalidData
    case invalidDataUTI
    case invalidVideo
    case invalidExportPreset
    case invalidExportSession
    case unsupportedFileType
    case fileWriteFailed
    case exportFailed
    case exportCanceled
    
    case cannotFindInLocal
    
    case saveVideoFailed
}
