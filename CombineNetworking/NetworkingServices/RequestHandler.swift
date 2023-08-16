//
//  RequestHandler.swift
//  StockMarketNetwokUtility
//
//  Created by Mohammad Murtuza on 02/08/23.
//

import Foundation
import Combine
import UIKit

//MARK: Main class responsible to execute the requests
final class RequestHandler {
    var requestExecuter:RequestExecutable
    var apiErrorLogger:APIErrorLogger
    
    //MARK: - init with default request executer and json decoder.
    init(requestExecuter: RequestExecutable = ReqeustExecuter(dataDecodable: DataDecoder(decoder: JSONDecoder())), apiErrorHandler:APIErrorLogger = APIErrorHandler()) {
        self.apiErrorLogger = apiErrorHandler
        self.requestExecuter = requestExecuter
    }
    
    func fetchData<T:Codable>(type:T.Type, urlRequest:URLRequest) -> AnyPublisher<T, Error> {
        return self.requestExecuter.executeRequest(type: T.self, urlRequest: urlRequest) { output in
            try self.apiErrorLogger.handleResponseError(output: output)
        }
    }
}


