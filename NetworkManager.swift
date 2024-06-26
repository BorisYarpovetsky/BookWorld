//
//  NetworkManager.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    
    private init() {}
    
    func getBooks(category: String,completion: ((_ books: [AllBook]) -> Void)?) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: URL(string: "https://openlibrary.org/subjects/\(category).json?details=true?ebooks=true")!) { data, responce, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let data else {
                print("Error reading file data")
                return
            }
            do {
                let books = try JSONDecoder().decode(Store.self, from: data)
                completion?(books.works)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getBook(title: String,completion: ((_ book: [DetailsBook]) -> Void)?) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: URL(string: "https://openlibrary.org/search.json?q=\(title)")!) { data, responce, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let data else {
                print("Error reading file data")
                return
            }
            do {
                let book = try JSONDecoder().decode(Book.self, from: data)
                completion?(book.docs ?? [DetailsBook(author_name: [String](), first_sentence: [String]())])
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
