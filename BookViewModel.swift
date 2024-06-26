//
//  BookViewModel.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import Foundation

protocol BookViewObserver {
    func dataModelChanged()
}

class BookViewModel {
    var book: AllBook
    var info = [DetailsBook]()
    var price: Int
    var count = [3,5,2,6,9,4].randomElement()
    
    var observers = [BookViewObserver]()
    var spinnerStart: Bool = true
    
    init(book: AllBook, price: Int) {
        self.book = book
        self.price = price
        
        getInfoBook(title: book.title)
    }
    
    private func didChange() {
        for observer in observers {
            observer.dataModelChanged()
        }
    }
    
    func getInfoBook(title: String) {
        NetworkManager.shared.getBook(title: title) { [weak self] book in
            guard let self else { return }
            self.info = book
            self.spinnerStart = false
            self.didChange()
        }
    }
}
