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
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMemeCellIdentifier", for: indexPath)as! SentMemeCollectionViewController
        
        
        let meme = memes[indexPath.row]
        
        cell.topLabelCollection.text = meme.topText
        cell.bottomLabelCollection.text = meme.bottomText
        cell.collectionImageView.image = meme.memedImage
        
        //error with cell return expression convert
        return cell
        
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let object: AnyObject = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController")
        let detailVC = object as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailVC.memeDetail  = self.memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
 
    
    
    
    
    
    
    
}
