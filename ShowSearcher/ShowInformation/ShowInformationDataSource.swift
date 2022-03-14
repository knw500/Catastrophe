//
//  ShowInformationDataSource.swift
//  ShowSearcher
//
//
//

import UIKit

protocol ShowSearchService {
    func requestSingleShow(named name: String, completion: @escaping (Result<Show, TVMazeShowSearchServiceError>) -> Void)
    func requestImageData(for show: Show, completion: @escaping (Result<Data, TVMazeShowSearchServiceError>) -> Void)
}

class ShowInformationDataSource {
    
    let service: ShowSearchService
    var lastSearchedText: String = ""
    var show: Show?
    var error: Error?
    
    var updateShowImage: ((UIImage?) -> Void)?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.weekday]
        formatter.includesApproximationPhrase = true
        formatter.includesTimeRemainingPhrase = true
        return formatter
    }()
    
    init(service: ShowSearchService) {
        self.service = service
    }
    
    var showName: String {
        "\(show?.id ?? -1)"
    }
    
    var daysSincePremier: String {
        guard let premiered = show?.premiered,
              let date = dateFormatter.date(from: premiered),
              let daysSincePremier = dateComponentsFormatter.string(from: date.timeIntervalSinceNow)
        else { return "" }
        return "Premiered \(daysSincePremier) ago."
    }
    
    var searchErrorMessage: String {
        error == nil ? "" : "We couldn't find a show for that search term!"
    }
}

// MARK: - Searching

extension ShowInformationDataSource {
    
    var searchControllerPlaceholder: String {
        "Search TV Shows"
    }
    
    func update(searchText: String) {
        lastSearchedText = searchText
    }
    
    func searchForShow(completion: @escaping (Bool) -> Void) {
        requestSingleShow(completion: completion)
    }
}

// MARK: - Service

extension ShowInformationDataSource {
    
    private func requestSingleShow(completion: @escaping (Bool) -> Void) {
        service.requestSingleShow(named: lastSearchedText) { result in
            switch result {
            case .success(let show):
                self.show = show
                self.requestImage(for: show)
                completion(true)
            case .failure(let error):
                self.show = nil
                self.error = error
                self.updateShowImage?(UIImage(systemName: "exclamationmark.icloud.fill"))
                completion(false)
            }
        }
    }
    
    private func requestImage(for show: Show) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.service.requestImageData(for: show) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    self.updateShowImage!(image)
                case .failure(let error):
                    self.error = error
                    self.updateShowImage!(UIImage(systemName: "exclamationmark.icloud.fill"))
                }
            }
        }
    }
}
