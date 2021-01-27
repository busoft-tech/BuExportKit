//
//  ExportTool+VideoURL.swift
//  Busoft
//
//  Created by Hamza Öztürk on 27.01.2021.
//  Copyright © 2021 Busoft Teknoloji A.Ş. All rights reserved.
//

import AVFoundation

public typealias VideoURLExportProgressHandler = (Double) -> Void

public struct VideoURLFetchOptions {
    
    public let isNetworkAccessAllowed: Bool
    public let preferredOutputPath: String
    public let exportPreset: VideoExportPreset
    public let exportProgressHandler: VideoURLExportProgressHandler?
    
    public init(isNetworkAccessAllowed: Bool = true,
                preferredOutputPath: String? = nil,
                exportPreset: VideoExportPreset = .h264_1280x720,
                exportProgressHandler: VideoURLExportProgressHandler? = nil) {
        self.isNetworkAccessAllowed = isNetworkAccessAllowed
        if let preferredOutputPath = preferredOutputPath {
            self.preferredOutputPath = preferredOutputPath
        } else {
            self.preferredOutputPath = FileHelper.temporaryDirectory(for: .video)
        }
        self.exportPreset = exportPreset
        self.exportProgressHandler = exportProgressHandler
    }
}

public struct VideoURLFetchResponse {
    
    public let url: URL
}

public typealias VideoURLFetchCompletion = (Result<VideoURLFetchResponse, BuExportError>) -> Void


extension ExportTool {
    
    @discardableResult
    public static func compressVideo(_ url: URL, options: VideoURLFetchOptions = .init(), completion: @escaping VideoURLFetchCompletion) -> AVAssetExportSession? {
        let supportPresets = AVAssetExportSession.allExportPresets()
        guard supportPresets.contains(options.exportPreset.rawValue) else {
            completion(.failure(.invalidExportPreset))
            return nil
        }
        
        let avAsset = AVURLAsset(url: url, options: nil)
        
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: options.exportPreset.rawValue) else {
            completion(.failure(.invalidExportSession))
            
            return nil
        }
        
        ExportTool.exportVideoData(for: exportSession, options: options) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return exportSession
    }
    
    private static func exportVideoData(for exportSession: AVAssetExportSession, options: VideoURLFetchOptions, completion: @escaping (Result<VideoURLFetchResponse, BuExportError>) -> Void) {
        // Check Path
        FileHelper.createDirectory(at: options.preferredOutputPath)
        // Check File Type
        let supportedFileTypes = exportSession.supportedFileTypes
        guard supportedFileTypes.contains(.mp4) else {
            completion(.failure(.unsupportedFileType))
            return
        }
        // Prepare Output URL
        let dateString = FileHelper.dateString()
        let outputPath = options.preferredOutputPath.appending("VIDEO-\(dateString).mp4")
        let outputURL = URL(fileURLWithPath: outputPath)
        // Setup Export Session
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.outputFileType = .mp4
        exportSession.outputURL = outputURL
        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                switch exportSession.status {
                case .unknown:
                    break
                case .waiting:
                    break
                case .exporting:
                    break
                case .completed:
                    completion(.success(VideoURLFetchResponse(url: outputURL)))
                case .failed:
                    completion(.failure(.exportFailed))
                case .cancelled:
                    completion(.failure(.exportCanceled))
                @unknown default:
                    break
                }
            }
        }
        // Setup Export Progress
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                switch exportSession.status {
                case .unknown, .waiting, .exporting:
                    options.exportProgressHandler?(Double(exportSession.progress))
                case .completed, .failed, .cancelled:
                    timer.invalidate()
                @unknown default:
                    break
                }
            }
        }
    }
}
