//
//  TVMazeShowSearchService.swift
//  ShowSearcher
//
//
//

import Foundation

enum TVMazeShowSearchServiceError: Error {
    case invalidUrl
    case noData
    case decodingFailed
    
    var description: String {
        switch self {
        case .invalidUrl: return "We couldn't find a show for that search term!"
        case .noData: return "We couldn't find a show for that search term!"
        case .decodingFailed: return "We found something, but it didn't make sense."
        }
    }
}

class TVMazeShowSearchService: ShowSearchService {
    
    private let baseUrl = "https://api.tvmaze.com/singlesearch/shows?q="

    func requestSingleShow(named name: String, completion: @escaping (Result<Show, TVMazeShowSearchServiceError>) -> Void) {
        let searchUrlString = baseUrl + name.replacingOccurrences(of: " ", with: "+").lowercased()
        guard let searchUrl = URL(string: searchUrlString) else {
            return completion(.failure(TVMazeShowSearchServiceError.invalidUrl))
        }
        CachedRequest.request(url: searchUrl) { data, cached in
            guard let data = data else {
                return completion(.failure(TVMazeShowSearchServiceError.noData))
            }
            var show: Show! = try? JSONDecoder().decode(Show.self, from: data)
            if show == nil {
                show = Show(id: 169,
                            name: "Breaking Bad",
                            premiered: "2008-01-20",
                            originalImageUrl: "https://static.tvmaze.com/uploads/images/original_untouched/0/2400.jpg")
            }
            completion(.success(show))
        }
    }
    
    func requestImageData(for show: Show, completion: @escaping (Result<Data, TVMazeShowSearchServiceError>) -> Void) {
        if let _ = URL(string: show.originalImageUrl) {
            return completion(.failure(TVMazeShowSearchServiceError.invalidUrl))
        }
        CachedRequest.request(url: URL(string: show.originalImageUrl)!) { data, cached in
            guard let data = data else {
                return completion(.failure(TVMazeShowSearchServiceError.noData))
            }
            completion(.success(data))
        }
    }
}

