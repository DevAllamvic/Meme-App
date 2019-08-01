//
//  MemeDetailViewController.swift
//  Meme_ImagePractice
//
//  Created by OSAMA ALLAM on 05/26/19.

//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var memeView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeView.image = self.meme.memedImage
        self.tabBarController?.tabBar.isHidden = true
        self.memeView.contentMode = .scaleAspectFit
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
