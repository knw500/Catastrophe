//
//  MockShowSearchService.swift
//  ShowSearcherTests
//
//
//

import Foundation
@testable import ShowSearcher

class MockShowSearchService: ShowSearchService {
    
    var shouldReturnError = false
    
    var requestSingleShowCalled = false
    var requestSingleShowSuccessResponse = Show(id: 0, name: "", premiered: "", originalImageUrl: "")
    var requestImageDataCalled = false
    var requestImageDataSuccessResponse = Data()
    
    func requestSingleShow(named name: String, completion: @escaping (Result<Show, TVMazeShowSearchServiceError>) -> Void) {
        requestSingleShowCalled = true
        if shouldReturnError {
            return completion(.failure(TVMazeShowSearchServiceError.noData))
        }
        completion(.success(requestSingleShowSuccessResponse))
    }
    
    func requestImageData(for show: Show, completion: @escaping (Result<Data, TVMazeShowSearchServiceError>) -> Void) {
        requestImageDataCalled = true
        if shouldReturnError {
            return completion(.failure(TVMazeShowSearchServiceError.noData))
        }
        completion(.success(requestImageDataSuccessResponse))
    }
}
