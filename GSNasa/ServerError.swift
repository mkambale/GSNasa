//
//  ServerError.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 03/10/21.
//

import Foundation

struct ServerError {
    
    var error:Error
    var errorCode: Int
    var errorMessage: String
    
    init(afError:URLError) {
        switch afError.code {
        case .timedOut:
            self.error = afError
            self.errorCode = TIMEOUT_ERROR_CODE
            self.errorMessage = serverErrorMessage
        default:
            self.error = afError
            self.errorCode = DEFAULT_ERROR_CODE
            self.errorMessage = serverErrorMessage
        }
    }
    
    init(serverError:Error, customErrorMessage: String? = nil) {
        self.error = serverError
        self.errorCode = DEFAULT_ERROR_CODE
        self.errorMessage = serverErrorMessage
    }
    
    init(customErrorMessage:String) {
        self.error = NSError(domain: customErrorMessage, code: 1, userInfo: nil)
        self.errorCode = DEFAULT_ERROR_CODE
        self.errorMessage = customErrorMessage
    }
    
    init(errorCode:Int) {
        //These are exclusively for handling login failre
        self.errorCode = errorCode
        self.errorMessage = ""
        self.error = NSError(domain: "", code: errorCode, userInfo: nil)
    }
    
    mutating func setUserMessage() {
        
        switch self.errorCode {
            
            case DEFAULT_ERROR_CODE:
                self.errorMessage = serverErrorMessage
                 break
            case PARSE_ERROR_CODE:
                self.errorMessage = serverErrorMessage
                 break
//             case 400:
//                self.errorMessage = error.description
//                 break
             default:
                 self.errorMessage = serverErrorMessage
                 break
            
//        case 0:
//            self.errorMessage = NSLocalizedString("PARSE_ERROR", comment: "")
//            break
//        case 1:
//            self.errorMessage = NSLocalizedString("ENCODING_ERROR", comment: "")
//            break
//        case -1009:
//            self.errorMessage = NSLocalizedString("NO_INTERNET", comment: "")
//            break
//        case 401, 403: //from salesforce - "some : "The operation couldn’t be completed."
//            self.errorMessage = NSLocalizedString("SALESFORCE_FETCH_FAIL", comment: "")
//            break
//        case 400, 402:
//            self.errorMessage = NSLocalizedString("BACKEND_FAILED", comment: "")
//            break
//        case let errorCode where errorCode > 403 && errorCode <= 499:
//            self.errorMessage = NSLocalizedString("BACKEND_FAILED", comment: "")
//            break
//        case let errorCode where errorCode > 499 && errorCode <= 599:
//            self.errorMessage = NSLocalizedString("INTERNAL_ERROR", comment: "")
//            break
//        case 1000:
//            self.errorMessage = NSLocalizedString("OPCO_INFO_MISSING_ERROR", comment: "")
//            break
//        default:
//            self.errorMessage = NSLocalizedString("BACKEND_FAILED", comment: "")
//            break
        }
    }
}
