//
//  GradientView.swift
//  StepSense_V1
//
//  Created by Ajit Ravisaravanan on 11/23/19.
//  Copyright © 2019 Ajit Ravisaravanan. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {

    @IBInspectable var firstColor : UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor : UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var start : CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var end : CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        layer.startPoint = start
        layer.endPoint = end
    }

}
