
//  WebServicemanager.swift
//  chinmayframework
//
//  Created by Chinmay Patel on 20/11/18.
//  Copyright © 2018 Chinmay Patel . All rights reserved.

import UIKit
import MobileCoreServices

//typealias webCompletionHandler = (_ data : Data) -> ();
typealias webCompletionHandler = (_ data : NSMutableDictionary) -> ();
typealias webFailuerHandler = (_ error : NSError,_ isCustomError : Bool) -> ();

let failureStatusCode = 0;
let successStatusCode = 1;

var webServiceLog = false

class WebServiceManager :NSObject
{
//    static var webService = WebServiceManager()
    
    override init()
    {
        
    }
    
    func setRequiredHeadersForRequest(_ urlRequest:NSMutableURLRequest)
    {
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
    
    /*func setRequiredHeadersForDeleteRequest(_ urlRequest:NSMutableURLRequest)
    {
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }*/
    
    
    func createRequest (_ param : NSDictionary , strURL : String , method : String ) -> URLRequest
    {
        let boundary = generateBoundaryString()
        
        let url = URL(string: strURL)
        let request = NSMutableURLRequest(url: url!)
        
        self.setRequiredHeadersForRequest(request);
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        request.httpBody = createBodyWithParameters(param, boundary: boundary)
        return request as URLRequest
    }
    
    func createNewRequest (_ param : NSDictionary , strURL : String , method : String ) -> URLRequest
    {
        let boundary = generateBoundaryString()
   
        let url = URL(string: strURL)
        let request = NSMutableURLRequest(url: url!)
        
      //  self.setRequiredHeadersForRequest(request);
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
       // request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
       // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(param, boundary:boundary )
        return request as URLRequest
    }
    
    func createNewRequestForDashboard (_ param : NSDictionary , strURL : String , method : String ) -> URLRequest
    {
        let boundary = generateBoundaryString()
        
        let url = URL(string: strURL)
        let request = NSMutableURLRequest(url: url!)
        
        //  self.setRequiredHeadersForRequest(request);
        
        //
//        request.setValue("application/x-www-form-urlencoded; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
         request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyWithParameters(param, boundary:boundary )
        return request as URLRequest
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBodyWithParameters(_ parameters: NSDictionary?,boundary: String) -> Data
    {
        var body = Data()
        if parameters != nil
        {
            for (key, value) in parameters!
            {
                if(value is String || value is NSString)
                {
                    body.append(Data("--\(boundary)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                    body.append(Data("\(value)\r\n".utf8))
                }
                else if(value is NSNumber)
                {
                    body.append(Data("--\(boundary)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                    body.append(Data("\(value)\r\n".utf8))
                }
                
//                else if(value is NSMutableArray)
//                {
//                    let array = value as! NSMutableArray
//                    for (i, _) in array.enumerated()
//                    {
//                        if let img = array.object(at: i) as? UIImage
//                        {
//                            let filename = "image.jpg"
//                            let data = UIImageJPEGRepresentation(img as! UIImage,0.1);
//                            let mimetype = mimeTypeForPath(filename)
//
//                            body.append(Data("--\(boundary)\r\n".utf8))
//                            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".utf8))
//                            body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
//                            body.append(Data(data!))
//                            body.append(Data("\r\n".utf8))
//                        }else{
//                            body.append(Data("--\(boundary)\r\n".utf8))
//                            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
//                            body.append(Data("\(array.object(at: i))\r\n".utf8))
//                        }
//                    }
//                }
                else if(value is UIImage)
                {
                    let filename = "image.jpg"
                    let data = UIImageJPEGRepresentation(value as! UIImage,0.1);
                    let mimetype = mimeTypeForPath(filename)

                    body.append(Data("--\(boundary)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".utf8))
                    body.append(Data("Content-Type: \(mimetype)\r\n\r\n".utf8))
                    body.append(Data(data!))
                    body.append(Data("\r\n".utf8))
                }

            }
        }
        body.append(Data("--\(boundary)\r\n".utf8))
        print(body)
        return body as Data
    }
    
    func mimeTypeForPath(_ path: String) -> String
    {
        let str : NSString = path as NSString;
        let pathExtension = str.pathExtension
        var stringMimeType = "application/octet-stream";
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                stringMimeType = mimetype as NSString as String
            }
        }
        return stringMimeType;
    }
    
    /*func createRequestForDelete (_ param : NSDictionary , strURL : String , method : String ) -> URLRequest
    {
        let url = URL(string: strURL)
        let request = NSMutableURLRequest(url: url!)
        self.setRequiredHeadersForDeleteRequest(request);
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        //  request.httpBody = createBodyWithParameters(param, boundary: boundary)
        request.httpBody = WebServiceManager.dataFromDictionary(param as! NSMutableDictionary)
        return request as URLRequest
    }*/
    
    // MARK: - Post Method
    func callPostWebService(methodURL :String, methodType : String, param:NSDictionary, completionHandler:@escaping webCompletionHandler, failureHandler: @escaping webFailuerHandler)
    {
        
        if (service.isInternetHasConnectivity() == false ) {
            let myError = NSError(domain: "Internet is not available", code: 1001, userInfo: nil)
            
            failureHandler(myError, true);
        }
        
        let request = self.createRequest(param, strURL: methodURL, method: methodType)
        
        if webServiceLog == true {
            print("URL \(String(describing: request.url))");
            print("Header \(String(describing: request.allHTTPHeaderFields))");
            WebServiceManager.printRequestDictionary(param)
        }
        
        let serviceTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                
                guard let dataResponse = data, error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    failureHandler(error! as NSError, false);
                    return
                }
                
                do
                {
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                   print("jsonResponse====\(jsonResponse)") //Response result

                    let responseDict = NSMutableDictionary()
                    responseDict.setValue(jsonResponse, forKey: "result")
                    completionHandler(responseDict)
                }
                catch let parsingError
                {
                    print("Error", parsingError)
                    let msg = "Something went wrong"
                    let error = NSError(domain: msg, code: Int(0), userInfo: nil);
//                    DispatchQueue.main.async{
//                        appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
//                    }
                    failureHandler(error, true);
                }
                
                /*if(error != nil)
                {
                    self.showErrorPopUpForError(error! as NSError, false)
                    failureHandler(error! as NSError, false);
                }
                else
                {
                    let response = WebServiceManager.parseData(data!)
                    print("response===>>.>>\(String(describing: response))")
                    
                    if response != nil{
                        completionHandler(data!)
                    }else{
                        let msg = "Something went wrong"
                        let error = NSError(domain: msg, code: Int(0), userInfo: nil);
//                        DispatchQueue.main.async{
//                            appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
//                        }
                        failureHandler(error, true);
                    }
                }*/
            })
        })
        serviceTask.resume();
    }
    
    // MARK: - Post Method
    func callPostWebServiceDashboard(methodURL :String, methodType : String, param:NSDictionary, completionHandler:@escaping webCompletionHandler, failureHandler: @escaping webFailuerHandler)
    {
        let request = self.createNewRequestForDashboard(param, strURL: methodURL, method: methodType)
        
        if webServiceLog == true {
            print("URL \(String(describing: request.url))");
            print("Header \(String(describing: request.allHTTPHeaderFields))");
            WebServiceManager.printRequestDictionary(param)
        }
        
        let serviceTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                
                guard let dataResponse = data, error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    failureHandler(error! as NSError, false);
                    return
                }
                
                do
                {
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                    print("jsonResponse====\(jsonResponse)") //Response result
                    
                    let responseDict = NSMutableDictionary()
                    responseDict.setValue(jsonResponse, forKey: "result")
                    completionHandler(responseDict)
                }
                catch let parsingError
                {
                    print("Error", parsingError)
                    let msg = "Something went wrong"
                    let error = NSError(domain: msg, code: Int(0), userInfo: nil);
                    //                    DispatchQueue.main.async{
                    //                        appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
                    //                    }
                    failureHandler(error, true);
                }
                
                /*if(error != nil)
                 {
                 self.showErrorPopUpForError(error! as NSError, false)
                 failureHandler(error! as NSError, false);
                 }
                 else
                 {
                 let response = WebServiceManager.parseData(data!)
                 print("response===>>.>>\(String(describing: response))")
                 
                 if response != nil{
                 completionHandler(data!)
                 }else{
                 let msg = "Something went wrong"
                 let error = NSError(domain: msg, code: Int(0), userInfo: nil);
                 //                        DispatchQueue.main.async{
                 //                            appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
                 //                        }
                 failureHandler(error, true);
                 }
                 }*/
            })
        })
        serviceTask.resume();
    }
    
    
    func callNewPostWebService(methodURL :String, methodType : String, param:NSDictionary, completionHandler:@escaping webCompletionHandler, failureHandler: @escaping webFailuerHandler)
    {
        let request = self.createNewRequest(param, strURL: methodURL, method: methodType)
        
        if webServiceLog == true {
            print("URL \(String(describing: request.url))");
            print("Header \(String(describing: request.allHTTPHeaderFields))");
            WebServiceManager.printRequestDictionary(param)
        }
        
        let serviceTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                
                guard let dataResponse = data, error == nil else
                {
                    print(error?.localizedDescription ?? "Response Error")
                    failureHandler(error! as NSError, false);
                    return
                }
                
                do
                {
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options:   JSONSerialization.ReadingOptions.allowFragments)
                    print("jsonResponse====\(jsonResponse)") //Response result
                    
                    let responseDict = NSMutableDictionary()
                    responseDict.setValue(jsonResponse, forKey: "result")
                    completionHandler(responseDict)
                }
                catch let parsingError
                {
                    print("Error", parsingError)
                    let msg = "Something went wrong"
                    let error = NSError(domain: msg, code: Int(0), userInfo: nil);
                    //                    DispatchQueue.main.async{
                    //                        appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
                    //                    }
                    failureHandler(error, true);
                }
                
                /*if(error != nil)
                 {
                 self.showErrorPopUpForError(error! as NSError, false)
                 failureHandler(error! as NSError, false);
                 }
                 else
                 {
                 let response = WebServiceManager.parseData(data!)
                 print("response===>>.>>\(String(describing: response))")
                 
                 if response != nil{
                 completionHandler(data!)
                 }else{
                 let msg = "Something went wrong"
                 let error = NSError(domain: msg, code: Int(0), userInfo: nil);
                 //                        DispatchQueue.main.async{
                 //                            appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
                 //                        }
                 failureHandler(error, true);
                 }
                 }*/
            })
        })
        serviceTask.resume();
    }
    
    
    // MARK: - Get Method
    func callGetWebService(methodURL :String, completionHandler:@escaping webCompletionHandler, failureHandler: @escaping webFailuerHandler)
    {
        let url: URL = URL(string: methodURL)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        
        self.setRequiredHeadersForRequest(request);
        
        if webServiceLog == true {
            print("URL \(String(describing: request.url))");
            print("Header \(String(describing: request.allHTTPHeaderFields))");
        }
        
        request.httpMethod = "GET";
        
        let urlsession = URLSession.shared.dataTask(with: request as URLRequest) { (data, resposne, error) in
            
            guard let dataResponse = data, error == nil else
            {
                print(error?.localizedDescription ?? "Response Error")
                failureHandler(error! as NSError, false);
                return
            }
            
            do
            {
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
//                print("jsonResponse====\(jsonResponse)") //Response result

                let responseDict = NSMutableDictionary()
                responseDict.setValue(jsonResponse, forKey: "result")
                completionHandler(responseDict)
            }
            catch let parsingError
            {
                print("Error", parsingError)
                let msg = "Something went wrong"
                let error = NSError(domain: msg, code: Int(0), userInfo: nil);
//                DispatchQueue.main.async{
//                    appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
//                }
                failureHandler(error, true);
            }
            
           /* if(error != nil)
            {
                let myError = NSError(domain: (error! as NSError).description, code: (error! as NSError).code, userInfo: nil)
                self.showErrorPopUpForError(error! as NSError, false)
                failureHandler( myError ,false);
            }
            else
            {
                let response = WebServiceManager.parseData(data!)
                if response != nil
                {
                    completionHandler(data!)
                }
                else
                {
                    let msg = "Something went wrong"
                    let error = NSError(domain: msg, code: Int(0), userInfo: nil);
//                    DispatchQueue.main.async{
//                        appDelegate.ShowErrorPopUpWithErrorCode(strError:msg)
//                    }
                    failureHandler(error, true);
                }
            }*/
        }
        
        urlsession.resume()
    }
    
    // MARK: -  Show Error PopUp Method
    func showErrorPopUpForError(_ error: NSError, _ isCustomError: Bool)
    {
        print("error==============================>>>\(error)")
        let myError = NSError(domain: (error as NSError).localizedDescription, code: (error as NSError).code, userInfo: nil)
        print("myError.localizedDescription==========\(myError.domain)")
        
//        DispatchQueue.main.async{
//            appDelegate.ShowErrorPopUpWithErrorCode(strError: myError.domain)
//        }
    }
    
    // MARK: -  Helper Method
    /*func dataFromDictionary(_ dic:NSMutableDictionary)->Data
    {
        let strFormData = WebServiceManager.queryStringFromDictionary(dic);
        let formData : Data = strFormData.data(using: String.Encoding.utf8, allowLossyConversion: false)!;
        return formData;
    }*/
    
    /*func queryStringFromDictionary (_ dic:NSMutableDictionary)->String
    {
        var strFormData : String = "";
        var i = 0;
        
        for (key,value) in dic {
            
            if (i == 0){
                strFormData += "\(key)=\(value)";
            }else{
                strFormData += "&\(key)=\(value)";
            }
            i += 1;
        }
        return strFormData;
    }*/
    
    class func dataFromDictionary(_ dic:NSMutableDictionary)->Data
    {
        let strFormData = WebServiceManager.queryStringFromDictionary(dic);
        let formData : Data = strFormData.data(using: String.Encoding.utf8, allowLossyConversion: false)!;
        return formData;
    }
    
    class func queryStringFromDictionary (_ dic:NSMutableDictionary)->String
    {
        var strFormData : String = "";
        var i = 0;
        
        for (key,value) in dic {
            
            if (i == 0){
                strFormData += "\(key)=\(value)";
            }else{
                strFormData += "&\(key)=\(value)";
            }
            i += 1;
        }
        return strFormData;
    }
    
    /*class func parseData(_ jsonData:Data) -> NSMutableDictionary?
    {
        var mutableDict:NSMutableDictionary?
        do{
            mutableDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary;
        }catch{
            print("Error in parsing \n Please check this Response DATA \n\n  \(NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!)");
        }
        return mutableDict;
    }*/
    
    class func printRequestDictionary(_ dic : NSDictionary)
    {
        print("Request \n\n\n")
        for (key, value) in dic {
            print("\(key):\(value)")
        }
    }
}
