//
//  FileService.swift
//  DrawKit
//
//  Created by Matthew Schmulen on 7/29/20
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

class FileService {
    
    private let diskStoragePrefix = "DrawKitPrefix"
    private let systemName = "FileService"
    
    private let fileManager: FileManager
    private let cacheFilePath: URL
    
    enum ServiceError:Error {
        case unknown
        case fileDoesNotExist
    }
    
    init(
        fileManager: FileManager = FileManager.default
    ) {

        self.fileManager = fileManager
        
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let firstPath = paths.first!
        cacheFilePath = firstPath.appendingPathComponent("\(diskStoragePrefix)")
        
        try! fileManager.createDirectory(
            atPath: cacheFilePath.path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}

extension FileService {
    
    func allFilesInFolder() -> [String] {
        do {
            let a = try fileManager.contentsOfDirectory(atPath: cacheFilePath.path)
            return a
        } catch ( let error ) {
            print( "FileService.allFilesInFolder error \(error)")
            return []
        }
    }
    
}
// MARK:  File storage read and writes
extension FileService {
    
    public func writeToFileStorage(shortFileName: String, data:DrawingData ) -> Result<Bool, Error> {
        let fullDestinationFileURL = cacheFilePath.appendingPathComponent("/\(shortFileName)")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(data)
            if fileManager.fileExists(atPath: fullDestinationFileURL.path) {
                try FileManager.default.removeItem(at: fullDestinationFileURL)
            }
            fileManager.createFile(atPath: fullDestinationFileURL.path, contents: data, attributes: nil)
            return .success( true )
        } catch {
            //fatalError(error.localizedDescription)
            return .failure( ServiceError.unknown )
        }
        //return .success( false )
    }
    
    public func readFromFileStorage(shortFileName: String) -> Result<DrawingData?, Error>  {
        
        let fullDestinationFileURL = cacheFilePath.appendingPathComponent("/\(shortFileName)")
        print( "readFromFileStorage fullDestinationFilePath \(fullDestinationFileURL.path)")
        if !fileManager.fileExists(atPath: fullDestinationFileURL.path) {
            return .failure( ServiceError.fileDoesNotExist )
        }
        
        // use a JSON decoder
        if let data = fileManager.contents(atPath: fullDestinationFileURL.path) {
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(DrawingData.self, from: data)
                return .success( model )
            } catch {
                return .failure( ServiceError.unknown )
                //fatalError(error.localizedDescription)
            }
        } else {
            return .failure( ServiceError.unknown )
        }
        //return .failure( ServiceError.unknown )
    }
    
    public func removeAllFromFolder() -> Result<Bool, Error> {
        do {
            try fileManager.removeItem(atPath: cacheFilePath.path)
            return .success(true)
        }
        catch let error {
            print("error: \(error)")
            return .failure(error)
        }
    }
    
    public func delete( shortFileName: String) -> Result<Bool, Error> {
        let fullDestinationFileURL = cacheFilePath.appendingPathComponent("/\(shortFileName)")
        do {
             try fileManager.removeItem(atPath: fullDestinationFileURL.path)
            return .success(true)
        }
        catch let error {
            print("error: \(error)")
            return .failure(error)
        }
    }
}

//final class FileStoreContainer: ObservableObject {
//    
//    public let objectWillChange = PassthroughSubject<Void,Never>()
//    
//    let fileService: FileService
//    
//    @Published
//    public private(set) var files: [String] = [String]() {
//        didSet {
//            update()
//        }
//    }
//    
//    init(fileService: FileService) {
//        self.fileService = fileService
//    }
//    
//    func update() {
//        //DispatchQueue.main.async {
//        self.objectWillChange.send()
//        //}
//    }
//}


