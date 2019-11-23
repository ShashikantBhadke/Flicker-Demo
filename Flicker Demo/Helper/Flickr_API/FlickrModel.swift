//
//  FlickrModel.swift
//  Flicker Demo
//
//  Created by Shashikant Bhadke on 16/11/19.
//  Copyright © 2019 Shashikant Bhadke. All rights reserved.
//

import Foundation

// MARK: - FlickrModel
struct FlickrModel: Codable {
    let photos: FlickrPhotosList?
    let stat: String?
}

// MARK: - FlickrPhotosList
struct FlickrPhotosList: Codable {
    let page, pages, perpage: Int?
    let total: String?
    let photo: [FlickrPhoto]?
}

// MARK: - FlickrPhoto
struct FlickrPhoto: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
    let urlM: String?
    let heightM, widthM: Int?
    var isNew = false
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily
        case urlM = "url_m"
        case heightM = "height_m"
        case widthM = "width_m"
    }
}

// MARK :- Extensio For -
extension FlickrPhoto: Equatable {
    static func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        return lhs.id == rhs.id
    }
} //extension
