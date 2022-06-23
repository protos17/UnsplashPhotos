//
//  RandomPhotoModel.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 21.06.2022.
//

import Foundation

struct PhotoModel: Codable {
    let id: String?
    let createdAt: String?
    let urls: UrlModel
    let user: User
    let downloads: Int?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, urls, user, downloads
    }
}

struct UrlModel: Codable {
    let small: String?
}

struct User: Codable {
    let name: String?
    let location: String?
}

struct SearchPhotoModel: Codable {
    let results: PhotoArray
}

typealias PhotoArray = [PhotoModel]
