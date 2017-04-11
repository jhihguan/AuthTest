//
//  NetworkRequestable.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

protocol NetworkRequestable {
    func request(_ request: URLRequest, complete: @escaping ([String: Any]?, NetworkError?) -> Void)
}

extension NetworkRequestable where Self: UIViewController {
    
    func request(_ request: URLRequest, complete: @escaping ([String: Any]?, NetworkError?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return complete(nil, .serverError)
            }
            let httpResponse = response as! HTTPURLResponse
            guard 200 ..< 300 ~= httpResponse.statusCode else {
                return complete(nil, .serverError)
            }
            guard let data = data else {
                return complete(nil, .responseError)
            }
            do {
                guard let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return complete(nil, .responseError)
                }
                DispatchQueue.main.async {
                    complete(responseDictionary, nil)
                }
            } catch {
                complete(nil, .responseError)
            }
        }).resume()
    }
}
