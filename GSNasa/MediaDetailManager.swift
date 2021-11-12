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
    
    var favoriteMedia = [Media]()
    var isLoading = false
    
    private init() {
    }
    
    func getMediaForDate(date:String, completion:@escaping((MediaDetail?, Data?, RESULT) -> Void)) -> Void {
        //check in local cache
        if let resultModel = localCacheManager.getFromLocalCache(forDate: date) {
            completion(resultModel.details, resultModel.image.image, .SUCCESS)
        } else if let resultModel = diskCacheManager.getFromDiskCache(forDate: date) {
            completion(resultModel.details, resultModel.image.image, .SUCCESS)
        } else {
            let request = createGetMediaRequest(date: date)
            MediaDetailStore.shared.fetchMediaDetail(urlRequest: request) {
                dataModel, error, result in
                
                if result == .SUCCESS, let response = dataModel {
                    //TODO - when considering video
                    var url = ""
                    if let hdurl = response.hdurl {
                        url = hdurl
                    } else {
                        url = response.url
                    }
                    if response.media == .VIDEO {
                        completion(nil, nil, .MEDIA_ISSUE)
                    } else {
                        if !url.isEmpty && response.media == .IMAGE {
                            
                            MediaDetailStore.shared.executeDownloadRequest(url: url, fileName: "image.png") {
                                fileData, error, result in
                                
                                if result == .SUCCESS, let file = fileData {
                                    
                                    _ = self.diskCacheManager.addToDiskCache(data: Media(details: response, fileData: file))
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
                    }
                } else {
                    completion(nil, nil, .FAILED)
                }
            }
        }
    }
    
    func getAllMedia() -> [Media] {
        //Get all from disk
        return localCacheManager.getAllMediaFromLocal()
        //return favoriteMedia
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
        _ = localCacheManager.addToLocalCache(data: media)
        _ = diskCacheManager.addToDiskCache(data: media)
        return true
    }
    
    func removeFromFavorites(media: Media) {
        diskCacheManager.removeFromDiskCache(forDate: media.details.date)
        localCacheManager.removeFromLocalCache(forDate: media.details.date)
        //favoriteMedia.append(media)
    }
    
    func loadAllFavoritesFromDisk(completion:@escaping (Bool)->Void) {
        let concurrentQueue = DispatchQueue(label: "GSNasa", attributes: .concurrent)
        concurrentQueue.async { [weak self] in
            
            guard let self = self else {
                return
            }
            
            let mediaFromDisk = self.diskCacheManager.getAllMediaFromDisk()
            
            for item in mediaFromDisk {
                let _ = self.localCacheManager.addToLocalCache(data: item)
            }
            
            self.favoriteMedia = mediaFromDisk
            completion(true)
        }
    }
}

