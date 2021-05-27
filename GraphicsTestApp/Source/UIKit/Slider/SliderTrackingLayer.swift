//
//  SliderTrackingLayer.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/27/21.
//

import UIKit

class SliderTrackLayer: CALayer {
  weak var rangeSlider: TwoButtonsSlider?
  
  override func draw(in ctx: CGContext) {
    guard let slider = rangeSlider else {
      return
    }
    
    let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    ctx.addPath(path.cgPath)
    
    ctx.setFillColor(slider.trackTintColor.cgColor)
    
    ctx.setFillColor(UIColor.gray.withAlphaComponent(0.3).cgColor)
    let lowerValuePosition = slider.positionForValue(slider.lowerValue)
    let upperValuePosition = slider.positionForValue(slider.upperValue)
    let rect1 = CGRect(x: 0, y: 0,
                      width: lowerValuePosition,
                      height: bounds.height)
    ctx.fill(rect1)
    
    let rect2 = CGRect(x: upperValuePosition, y: 0,
                       width: bounds.width - upperValuePosition,
                      height: bounds.height)
    ctx.fill(rect2)
  }
}
