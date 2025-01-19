//
//  ImageViewCell.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

final class ImageViewCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    var viewModel: ImageViewCellViewModelProtocol?
    
    private var contentImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var heartImageView = {
        let heart = UIImageView()
        heart.image = UIImage(systemName: "heart.fill")
        heart.tintColor = .white
        heart.layer.isHidden = true
        heart.translatesAutoresizingMaskIntoConstraints = false
        return heart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(contentImageView)
        addSubview(heartImageView)
        contentImageView.frame = contentView.bounds
        NSLayoutConstraint.activate([
            heartImageView.leadingAnchor.constraint(equalTo: contentImageView.leadingAnchor, constant: 10),
            heartImageView.bottomAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: -10)
        ])
    }
    
    func markAsFavourite() {
        heartImageView.isHidden = false
    }
    
    func removeFavouriteMark() {
        heartImageView.isHidden = true
    }
}

extension ImageViewCell: ImageViewCellViewModelDelegate {
    func showImage(_ data: Data) {
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.image = UIImage(data: data)
    }
    
    func showError() {
        contentImageView.contentMode = .center
        contentImageView.image = UIImage(systemName: "arrow.counterclockwise")
    }
}

protocol ImageViewCellViewModelDelegate: AnyObject {
    func showImage(_ data: Data)
    func showError()
}
