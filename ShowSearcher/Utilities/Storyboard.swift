//
//  Storyboard.swift
//

import UIKit

enum Storyboard: String {
    case showInformation = "ShowInformation"
    
    /// Provides a convenient & robust API for the instantiation of storyboard view controllers.
    /// This API requires the view controllers name & storyboard identifier to match, otherwise returns nil
    func instantiate<T: UIViewController>(viewController type: T.Type) -> T? {
        let identifier = String(describing: type)
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T
    }
}
