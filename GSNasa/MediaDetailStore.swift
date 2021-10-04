//
//  MediaDetailStore.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 03/10/21.
//

import Foundation

final class MediaDetailStore {
    
    static let shared = MediaDetailStore()
    
    private init() {
    }
        
    func fetchMediaDetail(urlRequest:URLRequest, completion: @escaping(MediaDetail?, ServerError?, RESULT) -> Void) {
        NetworkService.shared.executeRequest(urlRequest: urlRequest) {
            data, error, result  in
            
            if result == .SUCCESS, let response = data {
                completion(response, nil, .SUCCESS)
            } else {
                completion(nil, ServerError(errorCode: error?.errorCode ?? DEFAULT_ERROR_CODE), .FAILED)
            }
        }
    }
    
    func executeDownloadRequest(url:String, fileName: String, completionHandler:@escaping(Data?, ServerError?, RESULT)->()) {
        NetworkService.shared.downloadFile(urlString: url) {
            fileData, error, result in
            
            completionHandler(fileData, error, result)
        }
    }
}
