//
//  LocalCacheManager.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import Foundation
import SwiftlyCache

class LocalCacheManager {
    let localCache = MemoryCache<Media>()
    
    init(size:UInt) {
        localCache.totalCountLimit = size
    }
    
    func addToLocalCache(data:Media) -> Bool {
        if data.image.fileName == nil {
            return false
        }
        
        return localCache.set(forKey: data.details.date, value: data)
    }
    
    func isExistInLocalCache(forDate:String) -> Bool {
        return localCache.isExistsObjectForKey(forKey: forDate)
    }
    
    func removeFromLocalCache(forDate: String) {
        localCache.removeObject(forKey: forDate) //detail
    }
    
    func getFromLocalCache(forDate:String) -> Media? {
        if isExistInLocalCache(forDate: forDate){
            return localCache.object(forKey: forDate)
        }
        return nil
    }
    
    func getAllMediaFromLocal() -> [Media] {
        var list = [Media]()
        for (_,object) in localCache {
            list.append(object)
        }
        return list
    }
}

