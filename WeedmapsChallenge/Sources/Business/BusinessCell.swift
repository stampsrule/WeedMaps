//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit


class BusinessCell: UICollectionViewCell {
    public var business: Business? {
        didSet {
            guard let data = business else { return }
            text.text = data.name
            
            text.translatesAutoresizingMaskIntoConstraints = false
            text.sizeToFit()
            
            if let imageLocation = data.imageURL {
                imageView.loadImage(from: imageLocation)
            }
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellWidth.constant = UIScreen.main.bounds.width - 24
    }
}
