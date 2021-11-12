//
//  MediaDetail.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import Foundation
import UIKit

enum MediaType {
    case IMAGE, VIDEO, NONE
}

struct MediaDetail: Codable {
    var copyright: String?
    var date: String
    var explanation: String
    var hdurl: String?
    var media_type: String
    var service_version: String
    var title: String
    var url: String
    var media:MediaType {
        get {
            return media_type == "image" ? .IMAGE : .VIDEO  //may not be enough, get back mk
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation
        case hdurl, media_type, service_version, title, url
    }
}

//Move to new file
struct Image: Codable {
    var fileName: String?
    var image: Data?
    
    init(fileData:Data, name:String) {
        self.image = fileData
        self.fileName = name
    }
    
    enum CodingKeys: String, CodingKey {
        case fileName, image
    }
}

struct Media: Codable {
    var details: MediaDetail
    var image: Image
    var isFavorite: Bool = false
    
    init(details:MediaDetail, fileData:Data) {
        self.details = details
        if let url = details.hdurl {
            self.image = Image(fileData: fileData, name: url)
        } else {
            self.image = Image(fileData: fileData, name: details.url)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case details, image, isFavorite
    }
}
