//
//  PresentViewController.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import UIKit

class PresentViewController: UIViewController {
    
    var heightStackContraint: NSLayoutConstraint?
    var heightButtonContraint: NSLayoutConstraint?
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.setTitle("Выбрать категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(loveButton)
        stackView.addArrangedSubview(fantasticButton)
        stackView.addArrangedSubview(detectiveButton)
        stackView.addArrangedSubview(actionButton)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.layer.opacity = 0
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var loveButton = getButton(title: "Романы", tag: 0)
    lazy var fantasticButton = getButton(title: "Фантастика", tag: 1)
    lazy var detectiveButton = getButton(title: "Детективы", tag: 2)
    lazy var actionButton = getButton(title: "Экшены", tag: 3)
    
    func getButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }
    
    @objc private func action(sender: UIButton) {
        switch sender.tag {
        case 0:
            let viewModel = StoreViewModel(title: "Романы")
            let viewController = StoreViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewModel = StoreViewModel(title: "Фантастика")
            let viewController = StoreViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewModel = StoreViewModel(title: "Детективы")
            let viewController = StoreViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)
        case 3:
            let viewModel = StoreViewModel(title: "Экшены")
            let viewController = StoreViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Книгомир"
        navigationController?.navigationBar.prefersLargeTitles = true
        layout()
    }
    
    @objc private func selectCategory() {
        UIView.animate(withDuration: 0.5) {
            self.button.layer.opacity = 0
            self.stackView.layer.opacity = 1
            self.heightButtonContraint?.constant = 10
            self.heightStackContraint?.constant = 300
            self.view.layoutIfNeeded()
        }
    }
    
    private func layout() {
        [button,stackView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 200),
        ])
        heightButtonContraint = button.heightAnchor.constraint(equalToConstant: 60)
        heightStackContraint = stackView.heightAnchor.constraint(equalToConstant: 20)
        heightButtonContraint?.isActive = true
        heightStackContraint?.isActive = true
    }
}

