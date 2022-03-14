//
//  Coordinator.swift
//  expression
//
//
//

import UIKit

protocol Coordinator {
    var window: UIWindow { get set }
    
    init(with window: UIWindow)
    
    func start()
    func display(viewController: UIViewController)
    func set(viewControllers: [UIViewController])
}

extension Coordinator {
    func display(viewController: UIViewController) {
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else if let presentController = window.rootViewController {
            presentController.present(viewController, animated: true)
        }
    }
    
    func set(viewControllers: [UIViewController]) {
        if let navigationController = window.rootViewController as? UINavigationController {
            navigationController.setViewControllers(viewControllers, animated: true)
        }
    }
}
