//
//  SOYoutubeAPI.swift
//  SOYoutube
//
//  Created by Hitesh on 11/7/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import Alamofire

let API_KEY = "<API_KEY>"

class SOYoutubeAPI: NSObject {
    
    var strNextPageToken = ""
    
    //MARK: - Search Top 50 Videos
    func getTopVideos(nextPageToken : String, showLoader : Bool, completion:(videosArray : Array<Dictionary<NSObject, AnyObject>>, succses : Bool, nextpageToken : String)-> Void){
        
        
        //load Indicator
        if #available(iOS 9.0, *) {
            Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (response) in
                response.forEach { $0.cancel() }
            }
        } else {
            // Fallback on earlier versions
            Alamofire.Manager.sharedInstance.session.getTasksWithCompletionHandler({ (dataTasks, uploadTasks, downloadTasks) in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            })
        }
        
        let contryCode = self.getCountryCode()
        var arrVideo: Array<Dictionary<NSObject, AnyObject>> = []
        var strURL = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&chart=mostPopular&maxResults=50&regionCode=\(contryCode)&key=\(API_KEY)"
        
        
        strURL = strURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.GET, NSURL(string: strURL)!, parameters: nil, encoding: .URL, headers: nil).responseJSON(completionHandler: { (responseData) -> Void in
            
            
            let isSuccess = responseData.result.isSuccess
            if isSuccess {
                
                let resultsDict = responseData.result.value as! Dictionary<NSObject, AnyObject>
                
                let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                
                for i in 0..<items.count {
                    
                    let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
                    if !snippetDict["title"]! .isEqualToString("Private video") && !snippetDict["title"]! .isEqualToString("Deleted video"){
                        let statisticsDict = items[i]["statistics"] as! Dictionary<NSObject, AnyObject>
                        
                        var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                        videoDetailsDict["videoTitle"] = snippetDict["title"]
                        videoDetailsDict["videoSubTitle"] = snippetDict["channelTitle"]
                        videoDetailsDict["channelId"] = snippetDict["channelId"]
                        videoDetailsDict["imageUrl"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["high"] as! Dictionary<NSObject, AnyObject>)["url"]
                        videoDetailsDict["videoId"] = items[i]["id"] as! String//PVideoViewCount
                        videoDetailsDict["viewCount"] = statisticsDict["viewCount"]
                        arrVideo.append(videoDetailsDict)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(videosArray: arrVideo, succses: true,nextpageToken: self.strNextPageToken)
                })
            } else {
                
            }
        })
    }
    
    
    //MARK: -Search Video with text
    func getVideoWithTextSearch (searchText:String, nextPageToken:String, completion:(videosArray : Array<Dictionary<NSObject, AnyObject>>,succses:Bool,nextpageToken:String)-> Void){
        
        
        if #available(iOS 9.0, *) {
            Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (response) in
                response.forEach { $0.cancel() }
            }
        } else {
            // Fallback on earlier versions
            Alamofire.Manager.sharedInstance.session.getTasksWithCompletionHandler({ (dataTasks, uploadTasks, downloadTasks) in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            })
        }
        
        let contryCode = self.getCountryCode()
        var arrVideo: Array<Dictionary<NSObject, AnyObject>> = []
        var arrVideoFinal: Array<Dictionary<NSObject, AnyObject>> = []
        
        var strURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&order=Relevance&q=\(searchText)&regionCode=\(contryCode)&type=video&key=\(API_KEY)"
        
        strURL = strURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        Alamofire.request(.GET, NSURL(string: strURL)!, parameters: nil, encoding: .URL, headers: nil).responseJSON(completionHandler: { (responseData) -> Void in
            
            let isSuccess = responseData.result.isSuccess
            if isSuccess {
                let resultsDict = responseData.result.value as! Dictionary<NSObject, AnyObject>
                
                let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                
                let arrayViewCount = NSMutableArray()
                for i in 0..<items.count {
                    
                    let snippetDict = items[i]["snippet"] as! Dictionary<NSObject, AnyObject>
                    
                    if !snippetDict["title"]! .isEqualToString("Private video") && !snippetDict["title"]! .isEqualToString("Deleted video") && items[i]["id"]!["videoId"]! != nil{
                        var videoDetailsDict = Dictionary<NSObject, AnyObject>()
                        arrayViewCount.addObject(items[i]["id"]!["videoId"]! as! String)
                        
                        videoDetailsDict["videoTitle"] = snippetDict["title"]
                        videoDetailsDict["videoSubTitle"] = snippetDict["channelTitle"]
                        videoDetailsDict["channelId"] = snippetDict["channelId"]
                        videoDetailsDict["imageUrl"] = ((snippetDict["thumbnails"] as! Dictionary<NSObject, AnyObject>)["high"] as! Dictionary<NSObject, AnyObject>)["url"]
                        videoDetailsDict["videoId"] = items[i]["id"]!["videoId"]! as! String
                        arrVideo.append(videoDetailsDict)
                    }
                }
                
                //Get video count
                
                if arrayViewCount.count > 0{
                    let videoUrlString = "https://www.googleapis.com/youtube/v3/videos?part=statistics&id=\(arrayViewCount.componentsJoinedByString(","))&key=\(API_KEY)"
                    
                    
                    Alamofire.request(.GET, NSURL(string: videoUrlString)!, parameters: nil, encoding: .URL, headers: nil).responseJSON(completionHandler: { (responseData) -> Void in
                        
                        let isSuccess = responseData.result.isSuccess//JSON(responseData.result.isSuccess)
                        if isSuccess {
                            let resultsDict = responseData.result.value as! Dictionary<NSObject, AnyObject>
                            let items: Array<Dictionary<NSObject, AnyObject>> = resultsDict["items"] as! Array<Dictionary<NSObject, AnyObject>>
                            
                            for i in 0..<items.count {
                                
                                var videoDetailsDict = arrVideo[i]
                                let statisticsDict = items[i]["statistics"] as! Dictionary<NSObject, AnyObject>
                                videoDetailsDict["viewCount"] = statisticsDict["viewCount"]
                                arrVideoFinal.append(videoDetailsDict)
                            }
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(videosArray: arrVideoFinal, succses: true,nextpageToken: self.strNextPageToken)
                            })
                        }else{
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(videosArray: arrVideoFinal, succses: false,nextpageToken: self.strNextPageToken)
                            })
                        }
                    })
                }else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(videosArray: arrVideoFinal, succses: false,nextpageToken: self.strNextPageToken)
                    })
                }
            } else {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(videosArray: arrVideoFinal, succses: false,nextpageToken: self.strNextPageToken)
                })
            }
        })
    }
    
    
    
    //MARK: Get Country code
    func getCountryCode() -> String {
        let local:NSLocale = NSLocale.currentLocale()
        return local.objectForKey(NSLocaleCountryCode) as! String
    }
}
