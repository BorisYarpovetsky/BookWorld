//
//  BuyViewController.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import UIKit

class BuyViewController: UIViewController {

    let viewModel: BuyViewModel
    
    var selectCount: Int? {
        didSet {
            print("Меняем значение в кнопке")
            guard let selectCount else { return }
            DispatchQueue.main.async {
                self.buyButton.setTitle("Купить за \(self.viewModel.price * selectCount)₽", for: .normal)
            }
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(secondNameTextfield)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(phoneTextField)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var nameTextField = getTextField(title: "Имя")
    lazy var secondNameTextfield = getTextField(title: "Фамилия")
    lazy var emailTextField = getTextField(title: "Почта")
    lazy var phoneTextField = getTextField(title: "Телефон")
    
    func getTextField(title: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = title
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.setLeftPaddingPoints(15)
        textField.backgroundColor = .systemGray6
        return textField
    }
    
    let countPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 12
        picker.tintColor = .clear
        return picker
    }()
    
    let titleForCountBook: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выберите кол-во книг:"
        return label
    }()
    
    lazy var buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Купить за \(viewModel.price)₽", for: .normal)
        button.backgroundColor = .systemGreen
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    init(viewModel: BuyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        countPicker.delegate = self
        countPicker.dataSource = self
        layout()
        setupDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let id = viewModel.book.cover_id else { return }
        let url = URL(string: "https://covers.openlibrary.org/b/id/\(id)-L.jpg")
        image.sd_setImage(with: url, placeholderImage: UIImage(named: "whiteBook"), options: [.continueInBackground, .progressiveLoad])
    }
    
    private func setupDelegate() {
        nameTextField.delegate = self
        secondNameTextfield.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        addGesture()
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapDissmiss))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
    }
    
    @objc func tapDissmiss() {
        view.endEditing(true)
    }
    
    private func layout() {
        [stackView,image,countPicker,titleForCountBook,buyButton].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -60),
            stackView.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: -5),
            stackView.heightAnchor.constraint(equalToConstant: 250),
            
            image.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant: 5),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            
            countPicker.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            countPicker.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            countPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            countPicker.heightAnchor.constraint(equalToConstant: 80),
            
            titleForCountBook.centerYAnchor.constraint(equalTo: countPicker.centerYAnchor),
            titleForCountBook.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            
            buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10),
            buyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            buyButton.heightAnchor.constraint(equalToConstant: 60),
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension BuyViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



extension BuyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(viewModel.countBook[row])"
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.countBook.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCount = viewModel.countBook[row]
        print("Выбрано: \(selectCount ?? 0) шт.")
    }
}



