//
//  StoreCollectionViewCell.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import UIKit
import SDWebImage

class StoreCollectionViewCell: UICollectionViewCell {
    
    var price: [String] = ["10₽"]
    let coverImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let titleBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let priceBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        clipsToBounds = true
        layer.cornerRadius = 20
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [coverImage,titleBook,priceBook].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.bottomAnchor.constraint(equalTo: contentView.centerYAnchor,constant: 40),
            
            titleBook.topAnchor.constraint(equalTo: coverImage.bottomAnchor,constant: 10),
            titleBook.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            titleBook.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleBook.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            
            priceBook.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            priceBook.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10)
        ])
    }
    
    func setupCell(book: AllBook, price: Int) {
        titleBook.text = book.title
        priceBook.text = "\(price)₽"
        guard let id = book.cover_id else { return }
        let url = URL(string: "https://covers.openlibrary.org/b/id/\(id)-L.jpg")
        coverImage.sd_setImage(with: url, placeholderImage: UIImage(named: "whiteBook"), options: [.continueInBackground, .progressiveLoad])
    }
}
