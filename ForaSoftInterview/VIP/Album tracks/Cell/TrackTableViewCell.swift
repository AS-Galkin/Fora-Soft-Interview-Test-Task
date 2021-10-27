//
//  TrackTableViewCell.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 27.10.2021.
//

import UIKit

class TrackTableViewCell: UITableViewCell {
    
    static let reuseId = String(describing: TrackTableViewCell.self)
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
