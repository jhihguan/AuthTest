//
//  NetworkProvider.swift
//  AuthTest
//
//  Created by Wane Wang on 4/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

class NetworkProvider {
    
    private let networkSession: URLSession
    private var userSession: UserSession? = nil
    private let userDefaults: UserDefaults
    
    init(networkSession: URLSession, userDefaults: UserDefaults) {
        self.networkSession = networkSession
        self.userDefaults = userDefaults
        if let sessionDictionary = userDefaults.get(type: .session) as? [String: Any] {
            userSession = UserSession.init(sessionDictionary)
        }
    }
    
    func isUserLogin() -> Bool {
        return userSession != nil
    }
    
    func isSessionTimeout() -> Bool {
        return userSession!.expTime < Date()
    }
    
    func logout() {
        userDefaults.set(nil, type: .account)
        userDefaults.set(nil, type: .password)
        userDefaults.set(nil, type: .session)
        userSession = nil
    }
    
    func login(account: String, password: String, complete: @escaping (NetworkError?) -> Void) {
        guard let url = URL(string: "http://52.197.192.141:3443") else {
            complete(.url)
            return
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: ["name": account, "pwd": password], options: .init(rawValue: 0))
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.request(request, complete: { [weak self] (responseDictionary, error) in
                if let error = error {
                    complete(error)
                    return
                }
                guard let dict = responseDictionary?["token"] as? [String: Any],
                    let session = UserSession.init(dict) else {
                        complete(.response)
                        return
                }
                self?.userDefaults.set(account, type: .account)
                self?.userDefaults.set(password, type: .password)
                self?.userDefaults.set(dict, type: .session)
                self?.userSession = session
                complete(nil)
            })
        } catch {
            complete(.parameter)
        }
    }
    
    func getMembers(complete: @escaping ([Member], NetworkError?) -> Void) {
        var result: [Member] = []
        if isSessionTimeout() {
            nenewToken(complete: { [weak self] (error) in
                if let error = error {
                    complete(result, error)
                } else {
                    self?.getMembers(complete: complete)
                }
            })
            return
        }
        guard let url = URL(string: "http://52.197.192.141:3443/member") else {
            complete(result, .url)
            return
        }
        guard let token = userSession?.token else {
            complete(result, .token)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.request(request) { (responseDictionary, error) in
            if let error = error {
                complete(result, error)
                return
            }
            guard let dict = responseDictionary?["data"] as? [[String: Any]] else {
                complete(result, .response)
                return
            }
            result = dict.flatMap { Member($0) }
            complete(result, nil)
        }
    }
    
    func createMember(username: String, complete: @escaping (NetworkError?) -> Void) {
        if isSessionTimeout() {
            nenewToken(complete: { [weak self] (error) in
                if let error = error {
                    complete(error)
                } else {
                    self?.createMember(username: username, complete: complete)
                }
            })
            return
        }
        guard let url = URL(string: "http://52.197.192.141:3443/member") else {
            complete(.url)
            return
        }
        guard let token = userSession?.token else {
            complete(.token)
            return
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: ["name": username], options: .init(rawValue: 0))
            request.addValue(token, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.request(request, complete: { (responseDictionary, error) in
                if let error = error {
                    complete(error)
                    return
                }
                guard let code = responseDictionary?["code"] as? String,
                    code == "success" else {
                        complete(.custom(message: "創建失敗"))
                        return
                }
                complete(nil)
            })
        } catch {
            complete(.parameter)
        }
    }
    
    private func nenewToken(complete: @escaping (NetworkError?) -> Void) {
        let defaults = UserDefaults.standard
        guard let account = defaults.string(type: .account),
            let password = defaults.string(type: .password) else {
                complete(.token)
                return
        }
        login(account: account, password: password) { (error) in
            complete(error)
        }
    }
    
    private func request(_ urlRequest: URLRequest, complete: @escaping ([String: Any]?, NetworkError?) -> Void) {
        networkSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return complete(nil, .server)
            }
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            guard 200 ..< 300 ~= statusCode else {
                return complete(nil, .status(status: statusCode))
            }
            guard let data = data else {
                return complete(nil, .response)
            }
            do {
                guard let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return complete(nil, .response)
                }
                DispatchQueue.main.async {
                    complete(responseDictionary, nil)
                }
            } catch {
                complete(nil, .response)
            }
        }).resume()
    }
    
}
