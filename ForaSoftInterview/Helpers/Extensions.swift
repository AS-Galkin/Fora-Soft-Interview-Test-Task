//
//  Extensions.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import UIKit

//MARK: - UIColor extension
extension UIColor {
    static var tabAndNavBarColor: UIColor = #colorLiteral(red: 0.9249589443, green: 0.9249589443, blue: 0.9249589443, alpha: 1)
}

//MARK: - Extension UIFont
extension UIFont {
    static let avenir20 = UIFont(name: "avenir", size: 17)
}

extension UIView {
    func aspectRation(_ ratio: CGFloat) -> NSLayoutConstraint {

        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}

extension UIImageView {
    func fetchImageFromURL(url: String?) throws {
        guard let url = URL(string: url ?? "") else {
            throw NSError(domain: String(describing: self.self), code: 1, userInfo: ["DetailMessage":"\(#function) from \(String(describing: self.self)) can not convert String to URL"])
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            }
                
        }
    }
}

//
extension UITableView {
    convenience init(withNib cell: UITableViewCell.Type, frame: CGRect) {
        self.init(frame: frame)
        let nib = UINib(nibName: String(describing: cell), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: cell))
        self.backgroundColor = .white
    }
    
    convenience init(frame: CGRect, cell: UITableViewCell.Type) {
        self.init(frame: frame)
        self.register(cell, forCellReuseIdentifier: String(describing: cell))
        self.backgroundColor = .white
    }
}

