//
//  ImageDetailsViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    var viewModel: ImageDetailsViewModel!
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUpdateImage()
        setupImageView()
        setupGestures()
        setupHeartButton()
        view.backgroundColor = .black
    }
    
    @objc func heartButtonPressed(_ button: UIBarButtonItem){
        if viewModel.heartButtonPressed() {
            button.image = UIImage(systemName: "heart")
        } else {
            button.image = UIImage(systemName: "heart.fill")
        }
    }
    
    private func setupHeartButton() {
        let image = UIImage(systemName: "heart")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(heartButtonPressed(_:)))
    }
    
    private func setupUpdateImage() {
        viewModel.updateImage = {
            self.imageView.image = UIImage(data: self.viewModel.imageData)
        }
    }
        
    private func setupImageView() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right: viewModel.swipedRight()
        case .left: viewModel.swipedLeft()
        default: break
        }
    }
}
