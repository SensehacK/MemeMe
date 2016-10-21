//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Sensehack on 20/10/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var memeDetailImageView: UIImageView!
    
    @IBOutlet weak var memeDetailTitleLabel: UILabel!
    
    var memeDetail : Meme!
    
    // MARK: Properties
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        memeDetailTitleLabel.text = memeDetail.topText
        memeDetailImageView.image = memeDetail.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

}
