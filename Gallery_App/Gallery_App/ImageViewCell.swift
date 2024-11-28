//
//  ImageViewCell.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
