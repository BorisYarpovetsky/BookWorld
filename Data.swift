//
//  Data.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import Foundation

struct Store: Decodable {
    var works: [AllBook]
}

struct AllBook: Decodable {
    var title: String
    var key: String?
    var authors: [Author]?
    var first_publish_year: Int?
    var cover_id: Int?
    var price: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case key
        case authors
        case first_publish_year
        case cover_id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.key = try container.decodeIfPresent(String.self, forKey: .key)
        self.authors = try container.decodeIfPresent([Author].self, forKey: .authors)
        self.first_publish_year = try container.decodeIfPresent(Int.self, forKey: .first_publish_year)
        self.cover_id = try container.decodeIfPresent(Int.self, forKey: .cover_id)
        
        self.price = [5, 15, 12, 10, 7, 5, 6, 10, 2, 4, 5, 9, 7, 10, 4, 5, 6, 6, 4, 3].randomElement()
    }
}


struct Author: Decodable {
    var key: String
    var name: String
}

struct Book: Decodable {
    var docs: [DetailsBook]?
}

struct DetailsBook: Decodable {
    var author_name: [String]?
    var first_sentence: [String]?
}
