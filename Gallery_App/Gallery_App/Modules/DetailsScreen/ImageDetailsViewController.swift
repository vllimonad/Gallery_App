//
//  ImageDetailsViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    var viewModel: ImageDetailsViewModelProtocol!
    private var imageView: UIImageView!
    private let imageLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchImage()
        setupImageView()
        setupImageLabel()
        setupGestures()
        setupHeartButton()
    }
        
    private func setupImageView() {
        imageView = UIImageView()
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
}

extension ImageDetailsViewController: ImageDetailsViewModelDelegate {
    func updateImage(_ data: Data) {
        imageView.image = UIImage(data: data)
    }
    
    func updateImageDescription(_ description: String) {
        imageLabel.text = description
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
    func updateImage(_ data: Data)
    func updateImageDescription(_ description: String)
    func markAsFavourite()
    func removeFavouriteMark()
    func showAlert(_ error: Error)
}
