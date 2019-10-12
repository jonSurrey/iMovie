//
//  RequestManager.swift
//  Movies
//
//  Created by Jonathan Martins on 09/10/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Alamofire
import Foundation

/// The expected data type of the requests, so we can check for erros
enum RequestResult<T:Codable>{
    case success(T)
    case failure(String)
    case noInternetConection
}

class RequestManager<T:Codable>{
    
    /// Checks if there is active internet connection
    private static var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
  
    /// Performs the GET requests
    static func get(to endpoint: Endpoint, parameters:Parameters? = nil, callback:@escaping(RequestResult<T>)->()){
        if !isConnectedToInternet{
            callback(.noInternetConection)
            return
        }
        
        printAccess(to: endpoint.address, parameters)
        Alamofire.request(endpoint.address, method: .get, parameters: setParameters(parameters), headers: nil).responseJSON { (response) in
            self.printResult(response)
            callback(self.resultBlock(response))
        }
    }
    
    /// Performs the GET requests
    static func get(to endpoint: String, parameters:Parameters? = nil, callback:@escaping(RequestResult<T>)->()){
        if !isConnectedToInternet{
            callback(.noInternetConection)
            return
        }
        
        printAccess(to: endpoint, parameters)
        Alamofire.request(endpoint, method: .get, parameters: setParameters(parameters), headers: nil).responseJSON { (response) in
            self.printResult(response)
            callback(self.resultBlock(response))
        }
    }
    
    /// Configures the parameters of the requests
    private static func setParameters(_ parameters:Parameters?)->Parameters{
        var parameters:Parameters = parameters ?? Parameters()
        parameters["api_key"] = Endpoint.apiKey.value
        return parameters
    }
    
    /// Handles the request response traying to parse the result into a 'T' given type or returning an error
    private static func resultBlock(_ response: DataResponse<Any>)->RequestResult<T>{
        guard let _ = response.response?.statusCode else {
            return .failure("Unknown Error")
        }
        guard let data = response.data else {
            return .failure(response.error?.localizedDescription ?? "Unknown Error")
        }
        
           let result = decodeResult(from: data)
        if let object = result.object {
            return .success(object)
        }
        else {
            return .failure(result.message)
        }
    }

    /// Decodes the response object data to a given class type
    private static func decodeResult(from data:Data)->(object:T?, message:String ){
        do{
            let object = try JSONDecoder().decode(T.self, from: data)
            return (object, "")
        }
        catch{
            return (nil, error.localizedDescription)
        }
    }
    
    // Prints the request
    private static func printAccess(to url:String, _ parameters: Parameters?){
        #if Release
            return
        #endif
        
        if let param = parameters, let theJSONData = try? JSONSerialization.data( withJSONObject: param, options: []) {
            let theJSONText = String(data: theJSONData, encoding: .ascii)
            print("\n ======== URL SENDO ACESSADA ======== \n\n - URL:\n \(url) \n\n - PARAMETROS:\n \(theJSONText ?? "Erro!")\n\n ==================================== \n")
        } else {
            print("\n ======== URL SENDO ACESSADA ======== \n\n - URL:\n \(url) \n\n - PARAMETROS:\n -\n\n ==================================== \n")
        }
    }
    
    /// Prints the result
    private static func printResult(_ result:DataResponse<Any>?){
        #if Release
            return
        #endif
        
        var message:String = ""
        if let result = result {
            let code  = result.response?.statusCode != nil ? "Status: \(result.response!.statusCode)":""
            let value = result.value ?? ""
            message = "\(code)\n\(value)"
        }
        print("\n ======== RESPOSTA DO REQUEST ======== \n\n \(message) \n\n ==================================== \n")
    }
}
