//
//  ItemDetailsViewController.swift
//  ShoppingList
//
//  Created by Nirmalya Mahanti on 14/12/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemcategory: UILabel!
    @IBOutlet weak var unitPrice: UILabel!
    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    
    var selectedItem: ShoppingItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.image = UIImage(named: (selectedItem?.imageName)!)
        itemName.text = selectedItem?.name
        itemcategory.text = selectedItem?.category
        unitPrice.text = selectedItem?.unitPrice
        unit.text = selectedItem?.units
        itemDescription.text = selectedItem?.description
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
