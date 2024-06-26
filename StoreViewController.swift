//
//  StoreViewController.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import UIKit

class StoreViewController: UIViewController, StoreViewObserver {
    
    let viewModel: StoreViewModel
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: "StoreCollectionViewCell")
        collection.delegate = self
        collection.dataSource = self
        collection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return collection
    }()
    
    let spinner: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = .black
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    init(viewModel: StoreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        
        setupNavigation()
    }
    
    func setupNavigation() {
        viewModel.searchController.delegate = self
        viewModel.searchController.searchBar.delegate = self
        navigationItem.searchController = viewModel.searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.isEnabled = false
        
        let sortWithDateDownAction = UIAction(title: "первая публикация", image: UIImage(systemName: "arrowshape.down.fill")) { _ in
            self.viewModel.filteredBooks.sort { bookOne, bookTwo in
                return bookOne.first_publish_year ?? 0 < bookTwo.first_publish_year ?? 0
            }
            self.dataModelChanged()
        }
        
        let sortWithDateUpAction = UIAction(title: "первая публикация", image: UIImage(systemName: "arrowshape.up.fill")) { _ in
            self.viewModel.filteredBooks.sort { bookOne, bookTwo in
                return bookOne.first_publish_year ?? 0 > bookTwo.first_publish_year ?? 0
            }
            self.dataModelChanged()
        }
        
        let sortPriceDownAction = UIAction(title: "цена", image: UIImage(systemName: "arrowshape.down.fill")) { _ in
            self.viewModel.filteredBooks.sort { bookOne, bookTwo in
                return bookOne.price ?? 0 < bookTwo.price ?? 0
            }
            self.dataModelChanged()
        }
        
        let sortPriceUpAction = UIAction(title: "цена", image: UIImage(systemName: "arrowshape.up.fill")) { _ in
            self.viewModel.filteredBooks.sort { bookOne, bookTwo in
                return bookOne.price ?? 0 > bookTwo.price ?? 0
            }
            self.dataModelChanged()
        }
        
        let menu = UIMenu(children: [sortPriceUpAction,sortPriceDownAction,sortWithDateUpAction,sortWithDateDownAction])
        let item = UIBarButtonItem(title: "сортировать", image: UIImage(systemName: "line.3.horizontal.decrease"), menu: menu)
        
        navigationItem.rightBarButtonItem = item
        navigationItem.rightBarButtonItem?.style = .plain
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        setupView()
    }
    
    private func setupView() {
        viewModel.observers.append(self)
        viewModel.spinnerStart ? spinner.startAnimating() : spinner.stopAnimating()
        layout()
    }
    
    func dataModelChanged() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.searchController?.searchBar.isEnabled = true
            self.viewModel.spinnerStart ? self.spinner.startAnimating() : self.spinner.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    private func layout() {
        [collectionView,spinner].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filteredBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCollectionViewCell", for: indexPath) as! StoreCollectionViewCell
        cell.setupCell(book: viewModel.filteredBooks[indexPath.item], price: viewModel.filteredBooks[indexPath.item].price ?? 0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = viewModel.filteredBooks[indexPath.item]
        let price = viewModel.filteredBooks[indexPath.item].price ?? 0
        let viewModel = BookViewModel(book: book,price: price)
        navigationController?.pushViewController(BookViewController(viewModel: viewModel), animated: true)
    }
}

extension StoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 20, height: 200)
    }
}

extension StoreViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filteredBooks = viewModel.books
        } else {
            viewModel.filteredBooks = viewModel.books
            viewModel.filteredBooks = viewModel.books.filter { book -> Bool in
                return book.title.contains(searchText)
            }
        }
        dataModelChanged()
    }
}

