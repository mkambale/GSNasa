//
//  DiskCacheManager.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import Foundation
import SwiftlyCache

/**
    This class's reponsibilities include -
 - Instantiates Disk cache of goven size.
 - Allows app to add/remove files from disk cache.
 - Provides API to get all cached files
*/
class DiskCacheManager {

    let diskCache = DiskCache<Media>(path: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] + "GSNasaDiskCache")
    
    init(size:UInt) {
        diskCache.maxCountLimit = size
    }
    
    func addToDiskCache(data:Media) -> Bool {
        if data.image.fileName == nil {
            return false
        }
        
        return diskCache.set(forKey: data.details.date, value: data)
    }
    
    func isExistInDiskCache(forDate:String) -> Bool {
        return diskCache.isExistsObjectForKey(forKey: forDate)
    }
    
    func removeFromDiskCache(forDate: String) {
        diskCache.removeObject(forKey: forDate) //detail
    }
    
    func getFromDiskCache(forDate:String) -> Media? {
        if isExistInDiskCache(forDate: forDate){
            return diskCache.object(forKey: forDate)
        }
        return nil
    }
    
    func getAllMediaFromDisk() -> [Media] {
        var list = [Media]()
        for (_,object) in diskCache {
            list.append(object)
        }
        return list
    }
}

