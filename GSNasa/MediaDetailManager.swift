//
//  MediaDetailManager.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import Foundation
import UIKit

final class MediaDetailManager {
    static let shared = MediaDetailManager()
    
    private var localCacheManager = LocalCacheManager(size: CACHE_SIZE)
    private var diskCacheManager = DiskCacheManager(size: CACHE_SIZE)
    
    private init() {
        
    }
    
    func getMediaForDate(date:String, completion:@escaping((MediaDetail?, Data?, RESULT) -> Void)) -> Void {
        //check in local cache
        if let resultModel = localCacheManager.getFromLocalCache(forDate: date) {
            completion(resultModel.details, resultModel.image.image, .SUCCESS)
        }
        
        let request = createGetMediaRequest(date: date)
        MediaDetailStore.shared.fetchMediaDetail(urlRequest: request) {
            dataModel, error, result in
            
            if result == .SUCCESS, let response = dataModel {
                //TODO - when considering video
                if !response.hdurl.isEmpty && response.media == .IMAGE {

                    MediaDetailStore.shared.executeDownloadRequest(url: response.hdurl, fileName: "image.png") {
                        fileData, error, result in
                        
                        if result == .SUCCESS, let file = fileData {
                            if self.localCacheManager.addToLocalCache(data: Media(details: response, fileData: file)) {
                                completion(response, file, .SUCCESS)
                            } else {
                                completion(nil, nil, .FAILED)
                            }
                        } else {
                            completion(nil, nil, .FAILED)
                        }
                    }
                } else {
                    completion(nil, nil, .FAILED)
                }
            } else {
                completion(nil, nil, .FAILED)
            }
        }
    }
    
    func getAllMedia() -> [Media] {
        //Get all from disk
        return localCacheManager.getAllMediaFromLocal()
    }
    
    func createGetMediaRequest(date:String) -> URLRequest {
        //https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2021-01-01
        
        let url = URL(string: GET_MEDIA_DETAILS)
        let path = APOD_PATH

        let params = ["api_key":API_KEY, "date":date]
        let queryParams = params.map { pair  in
            return URLQueryItem(name: pair.key, value: String(describing: pair.value))
        }
        var components = URLComponents(string:url!.appendingPathComponent(path).absoluteString)
        components?.queryItems = queryParams
        //TODO - handle failre here
        return URLRequest(url: (components?.url)!)
    }
    
    func saveToFavorites(media: Media) -> Bool {
        return diskCacheManager.addToDiskCache(data: media)
    }
    
    func removeFromFavorites(media: Media) {
        diskCacheManager.removeFromDiskCache(forDate: media.details.date)
        localCacheManager.removeFromLocalCache(forDate: media.details.date)
    }
    
    func loadAllFavoritesToLocalCache() {
        let concurrentQueue = DispatchQueue(label: "GSNasa", attributes: .concurrent)
        concurrentQueue.async {
            let mediaFromDisk = self.diskCacheManager.getAllMediaFromDisk()
            
            for item in mediaFromDisk {
                let _ = self.localCacheManager.addToLocalCache(data: item)
            }
        }
        //concurrentQueue.setTarget(queue: <#T##DispatchQueue?#>)
    }
}

