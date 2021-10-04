//
//  Helper.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import Foundation
import UIKit
import AVKit

class Helper {
            
    static func convertToStringFromDate(date:Date?, outputFormat:DateFormat) -> String {
        if let inputDate = date, outputFormat.rawValue != "" && outputFormat.rawValue != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = outputFormat.rawValue
            dateFormatter.timeZone = .current
            let outDateStr = dateFormatter.string(from: inputDate)
            return outDateStr
        }
        return ""
    }
    
    //https://stackoverflow.com/questions/40675640/creating-a-thumbnail-from-uiimage-using-cgimagesourcecreatethumbnailatindex
    static func getThumbnail(image:UIImage) -> UIImage? {

        guard let imageData = image.pngData() else { return nil }

        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary

        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        guard let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }

        return UIImage(cgImage: imageReference)

      }
    
    //https://www.swiftdevcenter.com/get-thumbnail-from-video-url-in-background-swift/
    static func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    static func showError(forView: UIViewController) {
        showAlert(withtitle: "Error", andMessage: serverErrorMessage, onView: forView)
    }
    
    static func showAlert(withtitle:String, andMessage :String, onView:UIViewController,
                   okaction: UIAlertAction? = nil, otheraction:UIAlertAction? = nil) {
        
        let alertController = UIAlertController(title: withtitle,
                                                message: andMessage,
                                                preferredStyle:.alert)
        
        if(okaction != nil) {
            alertController.addAction(okaction!)
        } else {
            let okAction = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            alertController.addAction(okAction)
        }
        
        if (otheraction != nil) {
            alertController.addAction(otheraction!)
        }
                
        alertController.preferredAction = okaction
        DispatchQueue.main.async {
            alertController.view.tintColor = UIColor.gray
            onView.present(alertController,
                           animated: true,
                           completion: nil)
        }
    }
}
