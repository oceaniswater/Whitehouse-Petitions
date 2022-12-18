//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Марк Голубев on 16.12.2022.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
