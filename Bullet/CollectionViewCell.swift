//
//  CollectionViewCell.swift
//  Bullet
//
//  Created by Jordan Lu on 3/27/16.
//  Copyright © 2016 Jordan Lu. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var heartPopup: UIImageView!
    
    func showHeart(gesture: UIGestureRecognizer) {
//        UIView.animateWithDuration(0.3, animations: {
//                self.heartPopup.transform = CGAffineTransformMakeScale(1.3, 1.3)
//                self.heartPopup.alpha = 1.0
//            }, completion: {
//                (value: Bool) in
//                UIView.animateWithDuration(0.1, animations: {
//                    self.heartPopup.transform = CGAffineTransformMakeScale(1.0, 1.0)
//                    }, completion: {
//                        (value: Bool) in
//                        UIView.animateWithDuration(0.3, animations: {
//                            self.heartPopup.transform = CGAffineTransformMakeScale(1.3, 1.3)
//                            self.heartPopup.alpha = 0.0
//                            }, completion: {
//                                (value: Bool) in
//                                self.heartPopup.transform = CGAffineTransformMakeScale(1.0, 1.0)
//                        })
//                })
//            })
    }
    
}
