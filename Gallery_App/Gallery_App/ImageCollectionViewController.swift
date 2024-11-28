//
//  ViewController.swift
//  Gallery_App
//
//  Created by Vlad Klunduk on 28/11/2024.
//

import UIKit

class ImageCollectionViewController: UIViewController {
    var viewModel: ImageCollectionViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ImageCollectionViewModel()
        viewModel.fetchImages()
    }


}

