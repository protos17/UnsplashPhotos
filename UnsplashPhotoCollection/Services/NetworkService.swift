//
//  NetworkService.swift
//  UnsplashPhotoCollection
//
//  Created by Данил Чапаров on 21.06.2022.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkService {
    func getRandomPhotoArray() -> Observable<PhotoArray>? {
        guard let url = URL(string: Constants.unsplashURL + Constants.randomPhotoPath) else { return nil }
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw Error.invalidResponse(result.response)
                }
                return result.data
            }
            .map { data in
                do {
                    let photoArray = try JSONDecoder().decode(
                        PhotoArray.self, from: data
                    )
                    return photoArray
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
    
    func getSearchPhoto(text: String) -> Observable<SearchPhotoModel>? {
        guard let url = URL(string: Constants.unsplashURL + Constants.searchedPhotoPath + text) else { return nil }
        var request = URLRequest(url: url)
        request.addValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.rx.response(request: request)
            .map { result -> Data in
                guard result.response.statusCode == 200 else {
                    throw Error.invalidResponse(result.response)
                }
                return result.data
            }
            .map { data in
                do {
                    let searchPhotoArray = try JSONDecoder().decode(
                        SearchPhotoModel.self, from: data
                    )
                    return searchPhotoArray
                } catch let error {
                    throw Error.invalidJSON(error)
                }
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
    }
    
    private enum Error: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }
}
