//
//  BookViewController.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import UIKit

class BookViewController: UIViewController, BookViewObserver {

    let viewModel: BookViewModel
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let titleBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    let authorBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let firstPublicationBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(buyBook), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    let spinner: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = .black
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    let titleSpinner: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.text = "Загрузка превью"
        label.numberOfLines = 0
        return label
    }()
    
    let previewText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(viewModel: BookViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView(model: viewModel)
    }
    
    private func setupView() {
        viewModel.observers.append(self)
        viewModel.spinnerStart ? spinner.startAnimating() : spinner.stopAnimating()
        layout()
    }
    
    func dataModelChanged() {
        DispatchQueue.main.async {
            self.viewModel.info.forEach { details in
                self.previewText.text = details.first_sentence?.first ?? "Отсутствует"
                self.titleSpinner.text = "Превью:"
            }
            self.viewModel.spinnerStart ? self.spinner.startAnimating() : self.spinner.stopAnimating()
        }
    }
    
    @objc private func buyBook() {
        let viewModel = BuyViewModel(price: viewModel.price, book: viewModel.book, count: viewModel.count ?? 0)
        let viewController = BuyViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func layout() {
        [image,titleBook,authorBook,firstPublicationBook,buyButton,countLabel,spinner,titleSpinner,previewText].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -140),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            titleBook.topAnchor.constraint(equalTo: image.bottomAnchor,constant: 20),
            titleBook.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            titleBook.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            
            authorBook.topAnchor.constraint(equalTo: titleBook.bottomAnchor,constant: 5),
            authorBook.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            authorBook.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            
            firstPublicationBook.topAnchor.constraint(equalTo: authorBook.bottomAnchor, constant: 5),
            firstPublicationBook.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            firstPublicationBook.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10),
            buyButton.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -40),
            buyButton.heightAnchor.constraint(equalToConstant: 60),
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            countLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor,constant: -20),
            countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            
            spinner.topAnchor.constraint(equalTo: firstPublicationBook.bottomAnchor,constant: 10),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleSpinner.topAnchor.constraint(equalTo: spinner.bottomAnchor),
            titleSpinner.centerXAnchor.constraint(equalTo: spinner.centerXAnchor),
            
            previewText.topAnchor.constraint(equalTo: titleSpinner.bottomAnchor, constant: 5),
            previewText.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            previewText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupView(model: BookViewModel) {
        titleBook.text = model.book.title
        countLabel.text = "В наличии: \(model.count ?? 0) шт."
        if let year = model.book.first_publish_year {
            firstPublicationBook.text = "Первая публикация: \(year)"
        } else {
            firstPublicationBook.text = ""
        }
        guard let authors = model.book.authors else { return }
        authors.forEach { author in
            authorBook.text = author.name
        }
        buyButton.setTitle("Купить за \(model.price)₽", for: .normal)
        guard let id = model.book.cover_id else { return }
        let url = URL(string: "https://covers.openlibrary.org/b/id/\(id)-L.jpg")
        image.sd_setImage(with: url, placeholderImage: UIImage(named: "whiteBook"), options: [.continueInBackground, .progressiveLoad])
    }
}

