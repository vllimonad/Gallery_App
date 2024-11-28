//
//  ViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    var viewModel: ImageCollectionViewModel!
    var collectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ImageCollectionViewModel()
        viewModel.updateView = {
            self.collectionView.reloadData()
        }
        viewModel.fetchImages()
        setupLayout()
        setupCollectionView()
    }
    
    func setupLayout() {
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width/3 - 2, height: view.frame.width/3 - 2)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view = collectionView
    }
}

extension ImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageViewCell
        let imageUrlString = viewModel.images[indexPath.item].urls.regular
        cell.loadImage(with: imageUrlString)
        return cell
    }
}
