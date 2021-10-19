//
//  Picture.swift
//  Project10_12
//
//  Created by Domagoj Sutalo on 10.08.2021..
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
