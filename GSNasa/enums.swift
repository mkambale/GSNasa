//
//  enums.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import Foundation

enum PageType: Int {
    case NONE = -1
    case TODAYS = 0
    case SEARCH = 1
    case FAVORITES = 2
}

enum DateFormat: String {
    case fullMonthForm = "MMMM dd, yyyy"
    case usStandardForm = "yyyy-MM-dd"
    case usStandardWithTimeForm2 = "yyyy-MM-dd'T'HH:mm:ss"
}

enum RESULT : Int {
    case FAILED = 0
    case SUCCESS
    case MEDIA_ISSUE
}
