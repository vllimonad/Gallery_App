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
        setupActions()
        view.backgroundColor = .black
    }
    
    private func setupHeartButton() {
        let image = UIImage(systemName: "heart")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(heartButtonPressed))
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
    
    @objc func heartButtonPressed(){
        viewModel.heartButtonPressed()
    }
            
    private func setupActions() {
        viewModel.markAsFavourite = {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
        viewModel.removeFavouriteMark = {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
    }
}
