//
//  ContentObservables.swift
//  StockMarketNetwokUtility
//
//  Created by Mohammad Murtuza on 03/08/23.
//

import Foundation
import Combine

//MARK: - Product model
struct Product:Codable,Identifiable {
    var id:Int
    var title:String
    var description:String
    var price:Int
    var discountPercentage:Double
    var thumbnail:URL?
}

struct Products:Codable {
    var products:[Product]
}

//MARK: - Content Observables
final class ContentObservables:ObservableObject {
    @Published var products:[Product] = []
    
    var anyCancellables = Set<AnyCancellable>()

    let requestManager:RequestHandler = RequestHandler()
    
    func getProducts(){
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        let urlRequest = URLRequest(url: url)
        requestManager.fetchData(type: Products.self, urlRequest: urlRequest)
            .print()
            .sink(receiveCompletion: self.requestManager.apiErrorLogger.completionErrorHandler(completion:)) { products in
                self.products += products.products
            }
            .store(in: &anyCancellables)
    }
}
