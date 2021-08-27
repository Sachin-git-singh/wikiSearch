//
//  searchUIViewController.swift
//  wikipediasearch
//
//  Created by sachin singh on 08/08/21.
//

import UIKit

class searchUIViewController: UIViewController {

    var txt:String?
    @IBOutlet var label2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label2.text = txt
    }
    

   

}
