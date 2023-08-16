//
//  DataDecoder.swift
//  CombineNetworking
//
//  Created by Mohammad Murtuza on 16/08/23.
//

import Foundation

// MARK: - Data decoding helper protocol.
protocol DataCoadble {
    var codingKeysStretegy:JSONDecoder.KeyDecodingStrategy? { get set}
    var dateDecodingStretegy:JSONDecoder.DateDecodingStrategy? { get set}
    var jsonDecoder:JSONDecoder { get set}
}

// MARK: - User can inject coding keys using init or property.
final class DataDecoder: DataCoadble {
    var codingKeysStretegy: JSONDecoder.KeyDecodingStrategy?
    var dateDecodingStretegy: JSONDecoder.DateDecodingStrategy?
    var jsonDecoder: JSONDecoder
    
    init(decoder:JSONDecoder,codingKeysStretegy: JSONDecoder.KeyDecodingStrategy? = nil, dateDecodingStretegy: JSONDecoder.DateDecodingStrategy? = nil) {
        self.jsonDecoder = decoder
        self.codingKeysStretegy = codingKeysStretegy
        self.dateDecodingStretegy = dateDecodingStretegy
    }
}

