//
//  Directory.swift
//  Project10_12
//
//  Created by Domagoj Sutalo on 10.08.2021..
//

import UIKit

class Directory: NSObject {
    static func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
