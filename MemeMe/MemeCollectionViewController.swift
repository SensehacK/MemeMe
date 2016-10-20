//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Sensehack on 19/10/16.
//  Copyright © 2016 Sensehack. All rights reserved.
//

import Foundation
import  UIKit

class MemeCollectionViewController : UICollectionViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    @IBOutlet weak var collectionImageView: UIImageView!
    var memes2 : [Meme]!
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath)as! MemeCollectionViewController
        
        
        let meme = memes[indexPath.item]
        
        
        //cell.setText(meme.top, bottomString: meme.bottom)
        
        
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        
        cell.collectionImageView?.image = meme.memedImage
        
        return cell
        
        
    }
    
    
    
    
    
    
    
}
