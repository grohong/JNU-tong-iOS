//
//  ServerRepository.swift
//  JUN-tong
//
//  Created by Seong ho Hong on 2017. 10. 7..
//  Copyright © 2017년 Seong ho Hong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerRepository {
    
    static func getCityBusData(completion: @escaping([CityBus]) -> Void) {
        var cityBusList:[CityBus] = []
        
        guard let url = URL(string: baseURL + "getDepartureSoonBusList") else {
            print("URL is nil")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10
        
        Alamofire.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                print("Response get store error: \(response.result.error!)")
                return
            }
            
            guard let value = response.result.value else { return }
            let swiftyJson = JSON(value)
            
            
            for busJson in swiftyJson {
                var busInfo:[String : JSON] = [:]
                var remainInfo:[String : JSON] = [:]
                
                busInfo = (busJson.1.dictionaryValue["busLineInfo"]?.dictionaryValue)!
                remainInfo = (busJson.1.dictionaryValue["remainTime"]?.dictionaryValue)!
            
                if let lineNo = busInfo["detailLineNo"]?.string,
                    let description = busInfo["description"]?.string,
                    let lineId = busInfo["lineId"]?.string,
                    let firstBusTime = remainInfo["first"]?.int {
                    
                    //secondBus의 nil 값
                    if let secondBusTime = remainInfo["second"]?.int {
                        let cityBus = CityBus(lineNo: lineNo, description: description, lineId: lineId, firstBusTime: firstBusTime, secondBusTime: secondBusTime)
                        cityBusList.append(cityBus)
                    } else {
                        let cityBus = CityBus(lineNo: lineNo, description: description, lineId: lineId, firstBusTime: firstBusTime, secondBusTime: nil)
                        cityBusList.append(cityBus)
                    }
                }
            }
            completion(cityBusList)
        }
    }
    
    
    static func getCityBusLineData(lineId: String, completion: @escaping([String]) -> Void) {
        var cityBusLineList:[String] = []
        
        guard let url = URL(string: baseURL + "getBusStationListByLineId/" + lineId) else {
            print("URL is nil")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10
        
        Alamofire.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                print("Response get store error: \(response.result.error!)")
                return
            }
            
            guard let value = response.result.value else { return }
            let swiftyJson = JSON(value)
            
            for busLineJson in swiftyJson {
                if let stationName = busLineJson.1["stationName"].string {
                    cityBusLineList.append(stationName)
                }
            }
            completion(cityBusLineList)
        }
    }
    
    static func getCityBusTimeData(lineId: String, completion: @escaping([String], [Int]) -> Void) {
        
        guard let url = URL(string: baseURL + "getBusScheduleListByLineId/" + lineId) else {
            print("URL is nil")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10
        
        Alamofire.request(urlRequest).responseJSON { response in
            guard response.result.isSuccess else {
                print("Response get store error: \(response.result.error!)")
                return
            }
            
            guard let value = response.result.value else { return }
            let swiftyJson = JSON(value)
            
            var timeInfo:[JSON] = []
            timeInfo = swiftyJson["busScheduleList"].arrayValue
            
            var departTimeList:[String] = []
            var remainTimeList:[Int] = []
            for busTimeJson in timeInfo {
                if let departTime = busTimeJson["departureTime"].string,
                    let remainTime = busTimeJson["remainTime"].int {
                    departTimeList.append(departTime)
                    remainTimeList.append(remainTime)
                }
            }
            completion(departTimeList, remainTimeList)
        }
    }
    
    
}
