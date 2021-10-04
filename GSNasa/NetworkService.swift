//
//  NetworkService.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 03/10/21.
//

import Foundation
import Alamofire

final class NetworkService {
    
    private var _session: Session?
    static let shared = NetworkService()
    
    private var almofireSession: Session {
        get {
            if let actSession = _session {
                return actSession
            } else {
                _session = Session()
                return _session!
            }
        }
    }
    
    private init() {
//
//        let serverTrustPolicy = ServerTrustManager(
//            allHostsMustBeEvaluated: true,
//            evaluators: certificates
//        )
//
        _session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.timeoutIntervalForRequest = 120
            
//            if TestSetupManager.shared.testMode {
//                configuration = URLSessionConfiguration.ephemeral
//                configuration.protocolClasses = [CTCAMockURLProtocol.self]
//            }
//            return Alamofire.Session(configuration: configuration, serverTrustManager: serverTrustPolicy)
            return Alamofire.Session(configuration: configuration, serverTrustManager: nil)
        }()
    }
    
    //TODO
    func executeRequest(urlRequest:URLRequest, completion: @escaping(MediaDetail?, ServerError?, RESULT) -> Void) {
        almofireSession.request(urlRequest)
            .validate(statusCode: 200 ... 299)
            .responseDecodable {
                (response: AFDataResponse<MediaDetail>) in  //This needs to be made generic

                //cleanup
                if let data = response.data {
                    print("response in executeRequestForGenerics before parsing :\(String(decoding: (data), as: UTF8.self))")
                }
                
                switch response.result {
                case .success(let result):
                    completion(result, nil, .SUCCESS)
                case .failure(let error):
                    var sError = ServerError(serverError: error)
                    if let underlyingError = error.underlyingError,
                       let urlError = underlyingError as? URLError {
                        sError = ServerError(afError: urlError)
                    }
                    print("Error in executeRequestForGenerics : \(response)")
                    completion(nil, sError, .FAILED)
                }
            }
    }
    
    func executeDownloadRequest(urlRequest:URLRequest, fileName: String, completionHandler:@escaping(String?, ServerError?, RESULT)->()) {
        
        let destinationPath: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
            let fileURL = documentsURL.appendingPathComponent("\(fileName)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //almofireSession.download(urlRequest, to: destinationPath)
        almofireSession.download(urlRequest)
            .downloadProgress { progress in }
            .validate(statusCode: 200 ... 299)
            .responseData { response in
                print("response: \(response)")
                switch response.result {
                case .success:
                    if response.fileURL != nil, let filePath = response.fileURL?.absoluteString {
                        print("executeDownlodRequest: filePath: \(filePath)")
                        completionHandler(filePath, nil, .SUCCESS)
                    }
                    break
                case .failure(let error):
                    var sError = ServerError(serverError: error)
                    if let underlyingError = error.underlyingError,
                       let urlError = underlyingError as? URLError {
                        sError = ServerError(afError: urlError)
                    }
                    completionHandler(nil, sError, .FAILED)
                    break
                }
                
            }
    }
    
    func downloadFile(urlString:String, completionHandler:@escaping(Data?, ServerError?, RESULT)->()) {
        almofireSession.request(urlString).responseData(completionHandler: {
            
            response in

            switch response.result {
            case .success(let result):
                completionHandler(result, nil, .SUCCESS)
            case .failure(let error):
                //TODO error handling
                completionHandler(nil, ServerError(errorCode: DEFAULT_ERROR_CODE), .FAILED)
            }
        })
    }
}
