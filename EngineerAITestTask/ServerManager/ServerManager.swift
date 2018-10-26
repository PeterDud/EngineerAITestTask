//
//  ServerManager.swift
//  EngineerAITestTask
//
//  Created by Peter Dudar  on 26/10/2018.
//  Copyright © 2018 CHI. All rights reserved.
//

import Foundation

class ServerManager {
    
    static var shared = ServerManager()
    
    private init() {
    }
    
    let session = URLSession.shared
    typealias FailureResponseBlock = (( _ error: Error) -> Void)

    func dataTask<S: BaseResponseModel>(requestModel: BaseRequestModel, successBlock: (( _ responseModel: S?) -> Void)?, failureBlock: FailureResponseBlock?)  {
        let request = requestModel.createRequest()
        session.dataTask(with: request.createRequest()) { [weak self](data, response, error) in
            
            guard let responseError = self?.verifyResponse(response: response, data: data, defaultText: "Unknown error") else {
                let responseModel = self?.handle(data: data, type: S.self)
                guard let model = responseModel as? S else {
                    if S.self == BaseResponseModel.self {
                        successBlock?(nil)
                        return
                    }
                    failureBlock?(NSError(domain: "Empty Response Model", code: 500, userInfo: nil))
                    return
                }
                successBlock?(model)
                return
            }
            
            failureBlock?(responseError)
            
            }.resume()
    }

    fileprivate func handle<R: Decodable>(data: Data?, type: R.Type) -> Decodable?{
        guard let responseData = data else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let responseModel = try decoder.decode(type, from: responseData)
            return responseModel
        } catch let err as NSError {
            print(err.localizedDescription)
            return nil
        }
    }

    fileprivate  func verifyResponse(response: URLResponse?, data: Data?, defaultText: String) -> NSError? {
        
        guard let http = response as? HTTPURLResponse else {
            return NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:defaultText])
        }
        
        if http.statusCode < 200 || http.statusCode >= 400 {
            var info = [String:Any]()
            if let d = data {
                let errorStr = String(data: d, encoding: .utf8)
                info[NSLocalizedDescriptionKey] = errorStr ?? defaultText
            }
            let error: NSError = NSError(domain: "", code: http.statusCode, userInfo: info)
            return error
        }
        return nil
    }


}










