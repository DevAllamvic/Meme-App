//
//  MemeCollectionViewController.swift
//  Meme_ImagePractice
//
//  Created by OSAMA ALLAM on 05/26/19.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let cellIdentifier = "MemeCell"
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let width = (self.view.frame.size.width - (2 * space)) / 3.0
        let height = (self.view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionViewCell
        let selectedMeme = memes[indexPath.row]
        
        cell.memeImageView?.image = selectedMeme.memedImage
        cell.memeText?.text = selectedMeme.topText + "   " + selectedMeme.bottomText
        cell.memeImageView.contentMode = .scaleAspectFit
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
}
