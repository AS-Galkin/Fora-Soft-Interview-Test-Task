//
//  TrackTableHeaderView.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 27.10.2021.
//

import UIKit

class TrackTableHeaderView: UIView {
    //MARK: - Variables
    /// StackView for all views
    private var headerStackView: UIStackView?
    /// ContainerView for StackView
    private let containerStackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    /// Container for imageView. For makig shadow.
    private var containerImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.aspectRation(1.0/1.0).isActive = true
        view.layer.shadowRadius = 3.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.clipsToBounds = false
        return view
    }()
    /// View to display album image
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.image = #imageLiteral(resourceName: "history")
        return imageView
    }()
    /// Label to display album name
    private var albumLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    /// Label to display artist name
    private var artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    ///
    private var albumName: String?
    ///
    private var artistName: String?
    
    // MARK: - Object lifecycle
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
    
    //MARK: - Methods
    /**
     Preapre elements for dsiplaying
     */
    private func setupView(imageUrl: String, albumName: String, artistName: String) {
        /// Downloading album image
        do {
            try imageView.fetchImageFromURL(url: imageUrl)
        } catch let error as NSError {
            print("Error \(error.userInfo["DetailMessage"])")
        }
        albumLabel.text = albumName
        artistLabel.text = artistName
        
        /// Setup  StackView
        headerStackView = UIStackView(arrangedSubviews: [
            containerImageView,
            albumLabel,
            artistLabel
        ])
        headerStackView?.spacing = 5
        headerStackView?.backgroundColor = .white
        headerStackView?.axis = .vertical
        headerStackView?.alignment = .fill
        headerStackView?.translatesAutoresizingMaskIntoConstraints = false
        
        /// Cover ImageView and StackView into ContainerView
        containerStackView.addSubview(headerStackView!)
        containerImageView.addSubview(imageView)
        addSubview(containerStackView)
        
        setupConstraints()
    }
    
    /**
     Setup constraint for autolayout.
     */
    private func setupConstraints() {
        guard let stack = headerStackView else { return }
        
        NSLayoutConstraint.activate([
            /// Position imageView
            imageView.topAnchor.constraint(equalTo: containerImageView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerImageView.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerImageView.leadingAnchor),
            /// Position ContainerStackView
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            /// PositionStack
            stack.topAnchor.constraint(equalTo: containerStackView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 60),
            stack.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor, constant: -60),
            stack.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: -10)
        ])
    }
}
