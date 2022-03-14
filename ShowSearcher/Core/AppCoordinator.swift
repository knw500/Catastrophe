//
//  AppCoordinator.swift
//  ShowSearcher
//
//
//

import UIKit

class AppCoordinator: Coordinator {
    
    var window: UIWindow
    
    // MARK: - Initialisation
    
    required init(with window: UIWindow) {
        self.window = window
        self.window.rootViewController = UINavigationController()
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Public API
    
    func start() {
        resetFlow()
    }
    
    // MARK: - Private API
    
    private func showInformation(reset: Bool = false) {
        if let infoController = Storyboard.showInformation.instantiate(viewController: ShowInformationViewController.self) {
            infoController.title = "Show Searcher"
            infoController.dataSource = ShowInformationDataSource(service: TVMazeShowSearchService())
            reset ? set(viewControllers: [infoController]) : display(viewController: infoController)
        }
    }
    
    private func resetFlow() {
        showInformation(reset: true)
    }
}
