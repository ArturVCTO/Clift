//
//  WeddingProfileProduct.swift
//  clift_iOS
//
//  Created by David Mar on 2/7/21.
//  Copyright © 2021 Clift. All rights reserved.
//

import Foundation

struct WeddingProfileProducts {
    
    static var products = [
        WeddingProfileProduct(name: "Cocina", imageName: "Image1"),
        WeddingProfileProduct(name: "Mesa", imageName: "Image2"),
        WeddingProfileProduct(name: "Blancos", imageName: "Image3"),
        WeddingProfileProduct(name: "Muebles", imageName: "Image4"),
        WeddingProfileProduct(name: "Hogar", imageName: "Image5"),
        WeddingProfileProduct(name: "Experiencias", imageName: "Image6")
    ]
    
}

struct WeddingProfileProduct {
    var name: String
    var imageName: String
}
