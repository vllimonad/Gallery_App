//
//  ImageDetailsViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

final class ImageDetailsViewController: UIViewController {
    var viewModel: ImageDetailsViewModelProtocol?
    private var imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let imageLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchImage()
        setupLayout()
        setupGestures()
        setupHeartButton()
    }
    
    private func setupLayout() {
        imageView.frame = view.bounds
        view.addSubview(imageView)
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
            case .right: viewModel?.swipedRight()
            case .left: viewModel?.swipedLeft()
            default: break
        }
        viewModel?.fetchImage()
    }
    
    @objc private func heartButtonPressed(){
        viewModel?.heartButtonPressed()
    }
}

extension ImageDetailsViewController: ImageDetailsViewModelDelegate {
    func updateImageDetails(with imageData: Data, and imageDescription: String) {
        imageView.image = UIImage(data: imageData)
        imageLabel.text = imageDescription
    }
    
    func markAsFavourite() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
    }
    
    func removeFavouriteMark() {
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
    }
    
    func showAlert(_ error: any Error) {
        let ac = UIAlertController(title: "Image loading error", message: error.localizedDescription, preferredStyle: .alert)
        let action2 = UIAlertAction(title: "Return", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        ac.addAction(action2)
        self.present(ac, animated: true)
    }
}

protocol ImageDetailsViewModelDelegate: AnyObject {
    func updateImageDetails(with imageData: Data, and imageDescription: String)
    func markAsFavourite()
    func removeFavouriteMark()
    func showAlert(_ error: Error)
}
