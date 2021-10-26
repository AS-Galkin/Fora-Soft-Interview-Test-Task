//
//  AlbumCollectionViewCell.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 26.10.2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = String(describing: AlbumCollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: AlbumCollectionViewCell.self), bundle: nil)
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        
        albumImageView.layer.cornerRadius = 4
        albumImageView.layer.masksToBounds = true
        albumNameLabel.font = .avenir20
        artistNameLabel.textColor = #colorLiteral(red: 0.6321875453, green: 0.636367023, blue: 0.6536904573, alpha: 1)
    }
}
