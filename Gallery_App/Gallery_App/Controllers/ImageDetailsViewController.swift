//
//  ImageDetailsViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    var viewModel: ImageDetailsViewModel!
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updateView = {
            self.imageView.image = UIImage(data: self.viewModel.imageData)
        }
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}
