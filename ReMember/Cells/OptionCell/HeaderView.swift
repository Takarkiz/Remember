//
//  AddTableViewCell.swift
//  ReMember
//
//  Created by k15046kk on 2019/06/16.
//  Copyright © 2019 澤田昂明. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class HeaderView: UIView {
    
    @IBOutlet var addPersonButton: MDCButton!
    @IBOutlet var shareMemoryButton: MDCButton!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }
    
    func loadNib(){
        let view = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addPersonButton.setElevation(ShadowElevation(rawValue: 6.0), for: .normal)
        shareMemoryButton.setElevation(ShadowElevation(rawValue: 6.0), for: .normal)
        
        addPersonButton.setImage(UIImage(named: "input_button"), for: .normal)
        shareMemoryButton.setImage(UIImage(named: "share_button"), for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        let selfheight:CGFloat = 143
        let selfwidth:CGFloat = 301
        
        self.frame.size.height = selfheight
        self.frame.size.width = selfwidth
        
        
        let superScreen:CGRect = (self.window?.screen.bounds)!
        
    }
        
    private func globalScheme(color: UIColor) -> MDCContainerScheme {
        let containerScheme = MDCContainerScheme()
        containerScheme.shapeScheme = MDCShapeScheme()
        containerScheme.colorScheme.primaryColor = color
        // Customize containerScheme here...
        return containerScheme
    }
    
}
