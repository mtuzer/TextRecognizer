//
//  TextExtractor.swift
//  TextRecognizerApp
//
//  Created by Mert Tuzer on 23.08.2019.
//  Copyright © 2019 Mert Tuzer. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct TextBlock {
    var text: String
    var frame: CGRect
}

struct TextExtractor {
    var image: UIImage
    var viewFrame: CGRect
    private let vision = Vision.vision()
    fileprivate let imageProcessQueue = DispatchQueue(label: "com.miniLabs.TextRecognizerApp", qos: .background, attributes: [], autoreleaseFrequency: .inherit, target: .global())
    func extractTextBlocks( completion: @escaping (_ blocks: [TextBlock]) -> Void ) {

        imageProcessQueue.async {
            var extracted = [TextBlock]()
            var texts = [String]()
            var frames = [CGRect]()
            let textRecognizer = self.vision.onDeviceTextRecognizer()
            let visionImage = VisionImage(image: self.image)
            textRecognizer.process(visionImage) { (result, error) in
                if let error = error {
                    print("An error with recognizing:", error)
                    return
                }
                guard let recognizedBlocks = result?.blocks else { return }
                DispatchQueue.main.async {
                    recognizedBlocks.forEach({ (block) in
                        var blockTexts = [String]()
                        block.lines.forEach({ (line) in
                            blockTexts.append(line.text + "\n")
                        })
                        // create the text of the block considering lines in it
                        let theLinedText = blockTexts.reduce("", +)
                        // calculate the frame with respect to view to be shown
                        let blockFrame = self.findBlockFrame(blockFrame: block.frame)
                        texts.append(theLinedText)
                        frames.append(blockFrame)
                    })
                    for (item, text) in texts.enumerated() {
                        extracted.append(TextBlock(text: text, frame: frames[item]))
                    }
                    completion(extracted)
                }
            }
        }
    }
    fileprivate func findBlockFrame(blockFrame: CGRect) -> CGRect {
        let imageHeight = self.image.size.height
        let imageWidth = self.image.size.width
        let xPos = self.viewFrame.width * blockFrame.origin.x / imageWidth
        let height = self.viewFrame.height * blockFrame.height / imageHeight
        let width = self.viewFrame.width * blockFrame.width / imageWidth
        let yPos = self.viewFrame.minY + self.viewFrame.height / imageHeight * blockFrame.origin.y
        return CGRect(x: xPos, y: yPos, width: width, height: height)
    }
}
