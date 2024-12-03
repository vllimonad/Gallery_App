//
//  ImageViewCell.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    private var contentImageView = UIImageView()
    private var heartImageView = {
        let heart = UIImageView()
        heart.image = UIImage(systemName: "heart.fill")
        heart.tintColor = .white
        heart.layer.opacity = 0
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
        heartImageView.layer.opacity = 1
    }
    
    func removeFromFavourite() {
        heartImageView.layer.opacity = 1
    }
}

extension ImageViewCell {
    func loadImage(with urlString: String) {
        NetworkService.shared.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.contentImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
