//
//  ShowInformationDataSourceTests.swift
//  ShowSearcherTests
//
//
//

import XCTest
@testable import ShowSearcher

class ShowInformationDataSourceTests: XCTestCase {

    private let gameOfThrones = Show(id: 0, name: "Game of Thrones", premiered: "2011-04-11", originalImageUrl: "www.path/to/resource")
    private let rectangle = UIImage(systemName: "rectangle.fill")!
    private let timeout: TimeInterval = 2.0

    let service = MockShowSearchService()
    lazy private var sut: ShowInformationDataSource = {
        return ShowInformationDataSource(service: service)
    }()
    
    func test_searchSucceess() {
        // Given
        service.requestSingleShowSuccessResponse = gameOfThrones
        service.requestImageDataSuccessResponse = rectangle.pngData()!
        let exp = expectation(description: "search should succeed with valid response")
        
        // When
        sut.searchForShow { succeeded in
            // Then
            XCTAssertTrue(succeeded)
            XCTAssertTrue(self.service.requestSingleShowCalled)
            XCTAssertTrue(self.service.requestImageDataCalled)
            
            XCTAssertEqual(self.sut.showName, self.gameOfThrones.name)
            XCTAssertEqual(self.sut.daysSincePremier, "Premiered 3,544 days ago.")
            XCTAssertEqual(self.sut.searchErrorMessage, "")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_searchFailsWithError() {
        service.shouldReturnError = true
        let exp = expectation(description: "search should fail with valid error")
        
        // When
        sut.searchForShow { succeeded in
            // Then
            XCTAssertFalse(succeeded)
            XCTAssertTrue(self.service.requestSingleShowCalled)
            XCTAssertFalse(self.service.requestImageDataCalled)
            
            XCTAssertEqual(self.sut.showName, "")
            XCTAssertEqual(self.sut.daysSincePremier, "")
            XCTAssertEqual(self.sut.searchErrorMessage, "We couldn't find a show for that search term!")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_updateShowImage_clearsImageOnSearch() {
        let exp = expectation(description: "update show image should clear image on new search")
        
        sut.updateShowImage = { image in
            // Then
            XCTAssertFalse(self.service.requestImageDataCalled)
            XCTAssertNil(image)
            exp.fulfill()
        }
        
        // When
        sut.searchForShow { _ in }
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_updateShowImage_updatesImageCorrectlyOnSuccessfulSearch() {
        let imageData = rectangle.pngData()!
        service.requestSingleShowSuccessResponse = gameOfThrones
        service.requestImageDataSuccessResponse = imageData
        let exp = expectation(description: "update show image should update succesfully")
        
        sut.updateShowImage = { image in
            // Then
            guard self.service.requestImageDataCalled else { return }
            XCTAssertNotNil(image)
            exp.fulfill()
        }
        
        // When
        sut.searchForShow { _ in }
        
        waitForExpectations(timeout: timeout)
    }

    func test_searchControllerPlaceholder() {
        XCTAssertEqual(sut.searchControllerPlaceholder, "Search TV Shows")
    }
}
