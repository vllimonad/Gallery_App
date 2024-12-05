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
    private let imageLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUpdateImage()
        setupUpdateImageDescription()
        setupImageView()
        setupImageLabel()
        setupGestures()
        setupHeartButton()
        setupUpdateHeartButtonImage()
        setupShowAlert()
    }
        
    private func setupImageView() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        view.addSubview(imageView)
    }
    
    private func setupImageLabel() {
        view.addSubview(imageLabel)
        NSLayoutConstraint.activate([
            imageLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
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
    
    private func setupUpdateImageDescription() {
        viewModel.updateImageDescription = { description in
            self.imageLabel.text = description
        }
    }
    
    private func setupUpdateHeartButtonImage() {
        viewModel.markAsFavourite = {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
        viewModel.removeFavouriteMark = {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
    }
    
    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    private func setupShowAlert() {
        viewModel.showAlert = { error in
            let ac = UIAlertController(title: "Image loading error", message: error.localizedDescription, preferredStyle: .alert)
            let action2 = UIAlertAction(title: "Return", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            ac.addAction(action2)
            self.present(ac, animated: true)
        }
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
}
