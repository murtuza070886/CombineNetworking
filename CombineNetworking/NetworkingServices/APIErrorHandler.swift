//
//  APIErrorHandler.swift
//  CombineNetworking
//
//  Created by Mohammad Murtuza on 16/08/23.
//

import Foundation
import Combine

protocol APIErrorLogger {
    func handleResponseError(output: URLSession.DataTaskPublisher.Output) throws -> Data
    func completionErrorHandler(completion:Subscribers.Completion<Error>)
}

final class APIErrorHandler:APIErrorLogger {
    
    func handleResponseError(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let httpURLResponse = output.response as? HTTPURLResponse else {
            throw HTTPRequestError.urlError(URLError.init(URLError.badServerResponse))
        }
        if (200..<300).contains(httpURLResponse.statusCode) {
            if httpURLResponse.statusCode == 200 {
                print(output.response.debugDescription)
                return output.data
            }
            else {
                throw HTTPRequestError.jsonResponse(output.response.debugDescription)
            }
        }
        else {
            throw HTTPRequestError.urlError(URLError(URLError.Code(rawValue: httpURLResponse.statusCode)))
        }
    }
    
    func completionErrorHandler(completion:Subscribers.Completion<Error>) {
        switch(completion) {
        case .finished: break
        case .failure(let error):
            print("Error while processing request ----> \n \(error.localizedDescription)")
        }
    }
}

enum HTTPRequestError:LocalizedError {
    case urlError(URLError)
    case decodeError(DecodingError)
    case jsonResponse(String)
    case genericError
    
    var localizeDescription:String {
        switch (self) {
        case .urlError(let error):
            return error.localizedDescription
        case .decodeError(let error):
            return error.localizedDescription
        case .jsonResponse(let response):
            return "Some unwanted response recived : \(response)"
        case .genericError:
            return "Unknown error occured"
        }
    }
}
