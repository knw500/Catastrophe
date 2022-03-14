//
//  CachedRequest.swift
//

import Foundation

class CachedRequest {
    
    private static let memoryCapacity = 40 * 1024 * 1024
    private static let diskCapacity = 512 * 1024 * 1024
    private static let diskPath = "urlCache"
    private static let urlCache = URLCache(memoryCapacity: memoryCapacity,
                                           diskCapacity: diskCapacity,
                                           diskPath: diskPath)
    
    private static let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = urlCache
        return URLSession(configuration: configuration)
    }()
    
    @discardableResult
    static func request(url: URL, completion: @escaping (Data?, Bool) -> Void) -> URLSessionTask? {
        let request = createRequest(for: url)
        // TODO: check for cached response
        
        let task = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let response = response, let data = data {
                let cacheResponse = CachedURLResponse(response: response, data: data)
                urlCache.storeCachedResponse(cacheResponse, for: request)
            }
            completion(data, false)
        })
        DispatchQueue.global(qos: .background).async {
            task.resume()
        }
        return task
    }
    
    private static func createRequest(for url: URL) -> URLRequest {
        URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 100)
    }
}
