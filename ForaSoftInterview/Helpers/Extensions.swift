//
//  Extensions.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 25.10.2021.
//

import UIKit

//MARK: - UIColor extension
extension UIColor {
    /// Color of TabBar
    static var tabAndNavBarColor: UIColor = #colorLiteral(red: 0.9249589443, green: 0.9249589443, blue: 0.9249589443, alpha: 1)
}

//MARK: - Extension UIFont
extension UIFont {
    static let avenir20 = UIFont(name: "avenir", size: 17)
}

//MARK: - Extension UIView
extension UIView {
    /**
     Setting  Sides Ratio of UIView.
     - returns:
     Ratio in NSLayoutConstraint
     - parameters:
     - ratio: Ratio of height and width.
     */
    func aspectRation(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
}

//MARK: - Extension UIImageView
extension UIImageView {
    
    /**
     Downloading image async.
     - returns: Void.
     - parameters:
     - url: Path to image.
     - throws: NSError: When can not convet string path to url.
     */
    func fetchImageFromURL(url: String?, completion: ((_ data: Data) -> Void)? = nil) throws {
        /// Check can we convert string to url.If no throw exception
        guard let url = URL(string: url ?? "") else {
            throw NSError(domain: String(describing: self.self), code: 1, userInfo: ["DetailMessage":"\(#function) from \(String(describing: self.self)) can not convert String to URL"])
        }
        
        // creating downloading job in global queue
        DispatchQueue.global(qos: .default).async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                //Send donwaloded image in main queue and appropriate it
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    
                    if completion != nil {
                        completion!(data)
                    }
                }
            }
            
        }
    }
}

//MARK: - Extension UITableView
extension UITableView {
    
    /// init tableView with fram and custom cell from Nib
    convenience init(withNib cell: UITableViewCell.Type, frame: CGRect) {
        self.init(frame: frame)
        let nib = UINib(nibName: String(describing: cell), bundle: nil)
        self.register(nib, forCellReuseIdentifier: String(describing: cell))
        self.backgroundColor = .white
    }
    
    /// init tableView with fram and custom cell
    convenience init(frame: CGRect, cell: UITableViewCell.Type) {
        self.init(frame: frame)
        self.register(cell, forCellReuseIdentifier: String(describing: cell))
        self.backgroundColor = .white
    }
}

