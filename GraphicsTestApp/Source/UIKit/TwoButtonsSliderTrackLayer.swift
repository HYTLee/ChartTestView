//
//  TwoButtonsSliderTrackLayer.swift
//  GraphicsTestApp
//
//  Created by AP Yauheni Hramiashkevich on 5/24/21.
//

import UIKit

class TwoButtonsSliderTrackLayer: CALayer {
  weak var rangeSlider: TwoButtonsSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
    
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.fillPath()
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let rect = CGRect(x: 0, y: 0,
                      width: bounds.width,
                      height: bounds.height)
        ctx.fill(rect)
    }
}
