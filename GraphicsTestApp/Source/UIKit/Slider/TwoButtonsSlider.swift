//
//  TwoButtonsSlider.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/20/21.
//

import Foundation
import UIKit

class TwoButtonsSlider: UIControl {
      override var frame: CGRect {
        didSet {
          updateLayerFrames()
        }
      }
      
      var minimumValue: CGFloat = 0 {
        didSet {
          updateLayerFrames()
        }
      }
      
      var maximumValue: CGFloat = 1 {
        didSet {
          updateLayerFrames()
        }
      }
      
      var lowerValue: CGFloat = 0 {
        didSet {
          updateLayerFrames()
        }
      }
      
      var upperValue: CGFloat = 1 {
        didSet {
          updateLayerFrames()
        }
      }
      
      var trackTintColor = UIColor(white: 0.9, alpha: 1)
      var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1)
      
      var thumbImage = UIImage(named: "Oval") {
        didSet {
          upperThumbImageView.image = thumbImage
          lowerThumbImageView.image = thumbImage
          updateLayerFrames()
        }
      }
      
      var highlightedThumbImage = UIImage(named: "Oval") {
        didSet {
          upperThumbImageView.highlightedImage = highlightedThumbImage
          lowerThumbImageView.highlightedImage = highlightedThumbImage
          updateLayerFrames()
        }
      }
      
      
      private let lowerThumbImageView = UIImageView()
      private let upperThumbImageView = UIImageView()
      private var previousLocation = CGPoint()
      
      override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        lowerThumbImageView.image = thumbImage
        addSubview(lowerThumbImageView)
        
        upperThumbImageView.image = thumbImage
        addSubview(upperThumbImageView)
      }

      
      required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }
      
      private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)


        lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue),
                                           size: thumbImage!.size)
        upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue),
                                           size: thumbImage!.size)
        CATransaction.commit()
      }
    
      func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
      }
    
      private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - (thumbImage!.size.width) / 2.0
        return CGPoint(x: x, y: (bounds.height - thumbImage!.size.height) / 2.0)
      }
    }

    extension TwoButtonsSlider {
      override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbImageView.frame.contains(previousLocation) {
          lowerThumbImageView.isHighlighted = true
        } else if upperThumbImageView.frame.contains(previousLocation) {
          upperThumbImageView.isHighlighted = true
        }
        
        return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
      }
      
      override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        previousLocation = location
        
        if lowerThumbImageView.isHighlighted {
          lowerValue += deltaValue
          lowerValue = boundValue(lowerValue, toLowerValue: minimumValue,
                                  upperValue: upperValue)
        } else if upperThumbImageView.isHighlighted {
          upperValue += deltaValue
          upperValue = boundValue(upperValue, toLowerValue: lowerValue,
                                  upperValue: maximumValue)
        }
        sendActions(for: .valueChanged)
        return true
      }
      
      override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbImageView.isHighlighted = false
        upperThumbImageView.isHighlighted = false
      }
      
      private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
      }
}
