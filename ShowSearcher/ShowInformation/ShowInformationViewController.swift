//
//  ShowInformationViewController.swift
//  ShowSearcher
//
//
//

import UIKit

class ShowInformationViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var imageView: UIImageView!
        
    var dataSource: ShowInformationDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultSearchTerm = "Breaking Bad"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchBar.text = defaultSearchTerm
        dataSource?.update(searchText: defaultSearchTerm)
        dataSource?.updateShowImage = updateShowImage(_:)
        searchBarSearchButtonClicked(navigationItem.searchController!.searchBar)
        definesPresentationContext = true
        label.text = ""
        label2.text = ""
        label3.text = ""
    }
    
    private func updateShowImage(_ image: UIImage?) {
        imageView.isHidden = false
        imageView.image = image
    }
}

// MARK: UISearchResultsUpdating

extension ShowInformationViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        dataSource?.update(searchText: searchText)
    }
}

// MARK: - UISearchBarDelegate

extension ShowInformationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataSource?.searchForShow { [weak self] succeeded in
            guard let self = self else { return }
            succeeded ? self.updatesOnSuccessfulSearch() : self.updatesOnFailedSearch()
        }
    }
}

// MARK: - Searching

extension ShowInformationViewController {
    
    private func updatesOnSuccessfulSearch() {
        label.text = ""
        label2.text = dataSource?.showName
        label3.text = dataSource?.daysSincePremier
    }
    
    private func updatesOnFailedSearch() {
        label.text = dataSource?.searchErrorMessage
        label.center = CGPoint(x: view.frame.width/2, y: view.safeAreaInsets.top+100)
        view.bringSubviewToFront(label)
        print(label.frame)
        label2.text = ""
        label3.text = ""
    }
}
