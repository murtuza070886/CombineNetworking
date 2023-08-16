//
//  ReqeustExecuter.swift
//  CombineNetworking
//
//  Created by Mohammad Murtuza on 16/08/23.
//

import Foundation
import Combine

// MARK: Nessary method to execute the request.
protocol RequestExecutable {
    var jsonDecoder:JSONDecoder {set get}
    func executeRequest<T:Codable>(type:T.Type, urlRequest:URLRequest,errorHandler:@escaping (URLSession.DataTaskPublisher.Output) throws -> Data) -> AnyPublisher<T, Error>
}

final class ReqeustExecuter: RequestExecutable {
    //MARK: Json decoder reference if any key decoding strategy required, Similar for date decoding
    var jsonDecoder:JSONDecoder
    
    //MARK: init with default JSONDecoder
    init(dataDecodable:DataCoadble = DataDecoder(decoder: JSONDecoder())) {
        self.jsonDecoder = JSONDecoder()
    }
    
    //MARK: executeRequest will execute the request and return the desire decodable result
    func executeRequest<T:Codable>(type:T.Type, urlRequest: URLRequest,errorHandler:@escaping (URLSession.DataTaskPublisher.Output) throws -> Data) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap({ try errorHandler($0) })
            .decode(type: type, decoder: self.jsonDecoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
