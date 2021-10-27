//
//  TrackTableHeaderView.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 27.10.2021.
//

import UIKit

class TrackTableHeaderView: UIView {
    
    private var headerStackView: UIStackView?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.aspectRation(1.0/1.0).isActive = true
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.clipsToBounds = false
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.image = #imageLiteral(resourceName: "history")
        return imageView
    }()
    
    var albumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    var artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    private var albumName: String?
    
    private var artistName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(imageUrl: String?, albumName: String?, artistName: String?) {
        self.init(frame: .zero)
        setupView(imageUrl: imageUrl ?? "", albumName: albumName ?? "No album name", artistName: artistName ?? "No artist name")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(imageUrl: String, albumName: String, artistName: String) {
        if let url = URL(string: imageUrl),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            imageView.image = image
        }
        
        albumLabel.text = albumName
        artistLabel.text = artistName
        
        headerStackView = UIStackView(arrangedSubviews: [
            imageContainerView,
            albumLabel,
            artistLabel
        ])
        headerStackView?.spacing = 5
        headerStackView?.backgroundColor = .white
        headerStackView?.axis = .vertical
        headerStackView?.alignment = .fill
        headerStackView?.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(headerStackView!)
        imageContainerView.addSubview(imageView)
        addSubview(containerView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        guard let stack = headerStackView else { return }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: containerView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 60),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -60),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
}
