//
//  StoreViewModel.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import UIKit

protocol StoreViewObserver {
    func dataModelChanged()
}

class StoreViewModel {
    var books = [AllBook]()
    var filteredBooks: [AllBook] = []
    var observers = [StoreViewObserver]()
    var spinnerStart: Bool = true
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var title: String
    
    init(title: String) {
        self.title = title
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Найти книгу"
        
        switch title {
        case "Романы":
            getBooks(category: "love")
        case "Фантастика":
            getBooks(category: "fantastic")
        case "Детективы":
            getBooks(category: "detectives")
        case "Экшены":
            getBooks(category: "actions")
        default:
            break
        }
    }
    
    private func didChange() {
        for observer in observers {
            observer.dataModelChanged()
        }
    }
    
    func getBooks(category: String) {
        NetworkManager.shared.getBooks(category: category) { [weak self] books in
            guard let self = self else { return }
            self.books = books
            self.filteredBooks = books
            self.spinnerStart = false
            self.didChange()
        }
    }
}

