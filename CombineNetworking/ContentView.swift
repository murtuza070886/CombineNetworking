//
//  ContentView.swift
//  CombineNetworking
//
//  Created by Mohammad Murtuza on 16/08/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentObserver = ContentObservables()
    var body: some View {
        List {
            ForEach(contentObserver.products) { product in
                ProductLisView(product: product)
            }
            .listRowSeparator(.automatic)
        }
        .task {
            self.contentObserver.getProducts()
        }
    }
}

struct ProductLisView:View {
    var product:Product
    var body: some View {
        VStack {
            HStack {
                ProductImageView(imageURL: product.thumbnail?.absoluteString ?? "")
                    .frame(width: 60 , height: 60)
                    .clipShape(Circle())
                VStack(alignment:.leading) {
                    Text(product.title)
                        .font(.title3)
                    Text(product.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(product.discountPercentage)")
                        .font(.headline)
                }
            }
        }
        .foregroundColor(.green)
    }
}

struct ProductImageView: View {
    @StateObject var imageObserver = ImageObserver()
    var imageURL:String
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    
    var body: some View {
        Image(uiImage: imageObserver.image)
            .resizable()
            .onAppear {
                self.imageObserver.fetchImageData(imageURL: imageURL)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
