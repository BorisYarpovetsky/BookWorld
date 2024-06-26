//
//  BuyViewModel.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import Foundation

class BuyViewModel {
    
    var price: Int
    var book: AllBook
    var count: Int
    
    var countBook =  [Int]()
    
    init(price: Int, book: AllBook, count: Int) {
        self.price = price
        self.book = book
        self.count = count
        
        countBook = Array(1...count)
    }
    
    
}
