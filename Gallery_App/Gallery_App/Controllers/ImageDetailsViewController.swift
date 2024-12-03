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
        viewModel.updateImage = {
            self.imageView.image = UIImage(data: self.viewModel.imageData)
        }
        setupImageView()
        setupGestures()
        view.backgroundColor = .black
    }
        
    func setupImageView() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right: viewModel.swipedRight()
        case .left: viewModel.swipedLeft()
        default: break
        }
    }
}
