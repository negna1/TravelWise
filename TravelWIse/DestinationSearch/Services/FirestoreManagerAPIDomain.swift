//
//  FirestoreManagerAPIDomain.swift
//  TravelWIse
//
//  Created by Nato Egnatashvili on 22.09.22.
//

import Foundation
import FirebaseFirestore

public struct Destinations: Codable, Equatable  {
    public init(data: [Destination]?) {
        self.data = data
    }
    
    let data: [Destination]?
    
}

public struct Destination: Codable, Equatable, Hashable {
    let id: Int
    let title: String?
    let imageURL: String?
}

extension Destinations {
    public init(params: [String: Any]) {
        let newParams = params["data"] as? [String: Any]
        let destinatinos = newParams?.compactMap { (key, value) -> Destination? in
            if let val = value as? [String: Any] {
                return Destination(id: val["id"] as? Int ?? 0,
                                   title: val["title"] as? String,
                                   imageURL: val["imageURL"] as? String)
            }
            return nil
        }
        self.init(data: destinatinos)
    }
}
