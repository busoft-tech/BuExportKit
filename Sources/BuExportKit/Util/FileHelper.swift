//
//  FileHelper.swift
//  Busoft
//
//  Created by Hamza Öztürk on 27.01.2021.
//  Copyright © 2021 Busoft Teknoloji A.Ş. All rights reserved.
//

import Foundation
import MobileCoreServices

struct FileHelper {
    
    static func fileExtension(from dataUTI: CFString) -> String {
        guard
            let declaration = UTTypeCopyDeclaration(dataUTI)?.takeRetainedValue() as? [CFString: Any],
            let tagSpecification = declaration[kUTTypeTagSpecificationKey] as? [CFString: Any] else {
                return "jpg"
        }
        if let fileExtension = tagSpecification[kUTTagClassFilenameExtension] as? String {
            return fileExtension
        }
        return (tagSpecification[kUTTagClassFilenameExtension] as? [String])?.first ?? "jpg"
    }
    
    static func createDirectory(at path: String) {
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                _print(error.localizedDescription)
            }
        }
    }
}

extension FileHelper {
    
    static func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss-SSS"
        return formatter.string(from: Date())
    }
    
    static func temporaryDirectory(for type: MediaType) -> String {
        let systemTemp = NSTemporaryDirectory()
        return systemTemp.appending("ExportTool/Video/")
    }
    
    static func getTemporaryUrl(by type: MediaType, fileType: FileType) -> URL {
        return getTemporaryUrl(by: type, utType: fileType.utType)
    }
    
    static func getTemporaryUrl(by type: MediaType, utType: CFString) -> URL {
        let tmpPath = temporaryDirectory(for: type)
        let dateStr = dateString()
        let filePath = tmpPath.appending("\(dateStr).\(fileExtension(from: utType))")
        createDirectory(at: tmpPath)
        return URL(fileURLWithPath: filePath)
    }
}
