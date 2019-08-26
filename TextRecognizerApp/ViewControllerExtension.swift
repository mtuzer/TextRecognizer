//
//  ViewControllerExtension.swift
//  TextRecognizerApp
//
//  Created by Mert Tuzer on 24.08.2019.
//  Copyright © 2019 Mert Tuzer. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    func setupLayout() {
        // setup layouts
        navigationItem.title = "Text Extractor"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectImage))
        navigationItem.setRightBarButton(rightButton, animated: true)
        view.addSubview(textView)
        NSLayoutConstraint.activate([textView.heightAnchor.constraint(equalToConstant: 100),
                                     textView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                                     textView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        view.addSubview(imageView)
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: textView.topAnchor),
                                     imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
    @objc func selectImage() {
        // remove buttons from the view and remove the elements from the button and recognized text arrays
        buttons.forEach { (button) in
            button.removeFromSuperview()
        }
        self.buttons.removeAll()
        self.texts.removeAll()
        // get imageView empty
        imageView.image = nil
        textView.text = ""
        self.present(imagePicker, animated: true, completion: nil)
    }
}
