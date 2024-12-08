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
}

extension ImageViewCell {
    private func setupLayout() {
        addSubview(contentImageView)
        addSubview(heartImageView)
        contentImageView.frame = contentView.bounds
        NSLayoutConstraint.activate([
            heartImageView.leadingAnchor.constraint(equalTo: contentImageView.leadingAnchor, constant: 10),
            heartImageView.bottomAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: -10)
        ])
    }
    
    func loadImage(with urlString: String) {
        NetworkManager.shared.fetchData(with: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.contentImageView.contentMode = .scaleToFill
                    self.contentImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.contentImageView.backgroundColor = .black
                    self.contentImageView.tintColor = .white
                    self.contentImageView.contentMode = .center
                    self.contentImageView.image = UIImage(systemName: "arrow.counterclockwise")
                }
            }
        }
    }
    
    func markAsFavourite() {
        heartImageView.isHidden = false
    }
    
    func removeFavouriteMark() {
        heartImageView.isHidden = true
    }
}
