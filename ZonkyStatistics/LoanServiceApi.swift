//
//  LoanServiceApi.swift
//  ZonkyStatistics
//
//  Created by Sadi on 12/01/2019.
//  Copyright © 2019 Sadi. All rights reserved.
//

import Foundation
import Alamofire

struct LoanServiceApi {
    
    var baseUrl = "https://api.zonky.cz"
    
    enum Resources{
        case Marketplace
        case Loan(id:Int)
        case Investing
    }
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return decoder
    }()
    
    func getResourceURL(_ resource:Resources)-> String {
        return baseUrl + "/loans/marketplace"
    }
    
    func call<T: Decodable>(resource:Resources,
                            queryParams:Parameters? = nil,
                            headers:HTTPHeaders? = nil,
                            completionHandler: @escaping (DataResponse<T>) -> Void){
        AF.request(getResourceURL(resource),
                   method:.get,
                   parameters:queryParams,
                   headers:headers).responseDecodable(decoder: jsonDecoder,
                                                      completionHandler:completionHandler)
    }
    
    func getMarketplaceLoans(from:Date, to:Date, completionHandler: @escaping (Result<[Loan]>) -> Void){
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let fromStr = df.string(from:from)
        let toStr = df.string(from:to)
        
        let qParam: Parameters = [
            "fields": "datePublished,covered",
            "datePublished__gte": fromStr,
            "datePublished__lte": toStr
        ]
        let hdr: HTTPHeaders = [
            "x-page": "0",
            "x-size": "1000000",
            "x-order": "datePublished"
        ]
        call(resource: .Marketplace,
             queryParams: qParam,
             headers: hdr){ (response: DataResponse<[Loan]>) in
                if let loans = response.result.value {
                    completionHandler(Result.success(loans))
                }
                else if let err = response.result.error{
                    completionHandler(Result.failure(err))
                }
        }
    }
}

