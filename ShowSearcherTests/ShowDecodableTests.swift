//
//  ShowDecodableTests.swift
//  ShowSearcherTests
//
//
//

import XCTest
@testable import ShowSearcher

class ShowDecodableTests: XCTestCase {

    func test_decodeSucceeds_withValidCharacterJson() {
        let data = loadJson(named: "show_valid")!
        let show = try! JSONDecoder().decode(Show.self, from: data)
        XCTAssertNotNil(show)
        XCTAssertEqual(show.id, 169)
        XCTAssertEqual(show.name, "Breaking Bad")
        XCTAssertEqual(show.premiered, "2008-01-20")
        XCTAssertEqual(show.originalImageUrl, "http://static.tvmaze.com/uploads/images/original_untouched/0/2400.jpg")
    }
    
    func test_decodeFails_withIncorrectlyTypedMember() {
        let data = loadJson(named: "show_invalid")!
        let show = try? JSONDecoder().decode(Show.self, from: data)
        XCTAssertNil(show)
    }
}

extension XCTestCase {
    func loadJson(named name: String) -> Data? {
        guard let url = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json") else { return nil }
        return try? Data(contentsOf: url)
    }
}
