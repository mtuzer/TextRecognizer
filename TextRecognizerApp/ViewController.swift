//
//  ViewController.swift
//  TextRecognizerApp
//
//  Created by Mert Tuzer on 23.08.2019.
//  Copyright © 2019 Mert Tuzer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imageView: UIImageView = {
        let anImageView = UIImageView()
        anImageView.contentMode = UIImageView.ContentMode.scaleToFill
        anImageView.translatesAutoresizingMaskIntoConstraints = false
        return anImageView
    }()
    
    let textView: UITextView = {
        let aTextView = UITextView()
        aTextView.translatesAutoresizingMaskIntoConstraints = false
        aTextView.font = UIFont.boldSystemFont(ofSize: 16)
        aTextView.backgroundColor = .lightGray
        aTextView.textColor = .white
        aTextView.textAlignment = .center
        aTextView.isEditable = false
        return aTextView
    }()
    
    let imagePicker: UIImagePickerController = {
        let aPickerController = UIImagePickerController()
        aPickerController.allowsEditing = false
        aPickerController.sourceType = .photoLibrary
        return aPickerController
    }()
    
    var theImage = UIImage()
    var texts = [String]()
    var buttons = [UIButton]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the view shown
        setupLayout()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.theImage = pickedImage.fixedOrientation()
            self.imageView.image = pickedImage.fixedOrientation()
            self.extractText()
        } else {
            // an error..
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        textView.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    private func extractText() {
        // start to extract texts on the image
        let extractor = TextExtractor(image: self.theImage, viewFrame: imageView.frame)
        extractor.extractTextBlocks { (textblocks) in
            print(textblocks.count)
            print(textblocks)
            var counter = 0
            textblocks.forEach({ (block) in
                self.createButtonsAndTexts(blockFrame: block.frame, blockText: block.text, buttonTag: counter)
                counter += 1
            })
        }
    }
    
    private func createButtonsAndTexts(blockFrame: CGRect, blockText: String, buttonTag: Int) {
        // add block texts to show on textView
        self.texts.append(blockText)
        // create button properties for each block
        let aButton = UIButton()
        aButton.alpha = 0.2
        aButton.backgroundColor = .red
        aButton.tag = buttonTag
        aButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        buttons.append(aButton)
        
        // add buttons the main view
        DispatchQueue.main.async {
            self.view.addSubview(aButton)
            aButton.frame = blockFrame
        }
    }
    
    @objc fileprivate func buttonTapped(sender: UIButton) {
        // let the background color of the selected frame be green and others red
        print(self.texts)
        self.buttons.forEach { (button) in
            button.backgroundColor = .red
        }
        sender.backgroundColor = .green
        
        // show the text on the textView
        self.textView.text = self.texts[sender.tag]
    }


}

