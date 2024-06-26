//
//  Extensions.swift
//  BookStoreTestAppVers
//
//  Created by Boris Yarpovetsky on 21.06.2024.
//

import UIKit

extension UITextField {
    func setupLeftView(imageViewNamed: String) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(systemName: imageViewNamed)
        let imageViewContrainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageViewContrainerView.addSubview(imageView)
        leftView = imageViewContrainerView
        leftViewMode = .always
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

