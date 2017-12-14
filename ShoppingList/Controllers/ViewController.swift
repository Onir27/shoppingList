//
//  ViewController.swift
//  ShoppingList
//
//  Created by Nirmalya Mahanti on 14/12/17.
//  Copyright © 2017 Nirmalya Mahanti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var shoppingTableView: UITableView!
    @IBOutlet weak var groupButton: UIBarButtonItem!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var shoppingItemList = [ShoppingItem]()
    var groupedShoppingItemList = [String : [ShoppingItem]]()
    var groupNames : [String] {
        var keys = [String]()
        for key in groupedShoppingItemList.keys {
            keys.append(key)
        }
        return keys
    }
    
    var isGrouped = false
    var reverseOrder = false
    var isSearching = false
    
    var shoppingItemSearchResults = [ShoppingItem]()
    var groupedShoppingItemSearchResults = [String : [ShoppingItem]]()
    var searchResultGroupNames : [String] {
        var keys = [String]()
        for key in groupedShoppingItemSearchResults.keys {
            keys.append(key)
        }
        return keys
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let shoppingList = ShoppingItemJSONManager().readFromJsonFile() else {
            return
        }
        self.shoppingItemList = shoppingList
        searchBar.delegate = self
        sort()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func groupList(_ sender: UIBarButtonItem) {
        isGrouped = true
        groupButton.isEnabled = false
        groupShoppingList()
        if isSearching {
            groupSearchResults()
        }
        self.shoppingTableView.reloadData()
    }
    

    @IBAction func sortList(_ sender: UIBarButtonItem) {
        self.reverseOrder = !reverseOrder
        self.sortButton.title = reverseOrder ? "Sort↓" : "Sort↑"
        sort()
        self.shoppingTableView.reloadData()
    }
    
    func groupShoppingList() {
        self.groupedShoppingItemList = groupItemArray(self.shoppingItemList)
    }
    
    func groupSearchResults() {
        self.groupedShoppingItemSearchResults = groupItemArray(self.shoppingItemSearchResults)
    }
    
    func groupItemArray(_ itemArray:[ShoppingItem]) -> [String : [ShoppingItem]] {
        return  itemArray.groupBy(){ $0.category }
    }
    
    func sort(_ itemArray:[ShoppingItem], in order: Bool) -> [ShoppingItem] {
        return itemArray.sorted(by: { (item1, item2) -> Bool in
            return order ? item1.name > item2.name : item1.name < item2.name
        })
    }
    
    func sortGroupedItems(_ groupedItems:[String : [ShoppingItem]], in order: Bool) -> [String : [ShoppingItem]]{
        var sortedGroupedItems = groupedItems
        for key in groupedItems.keys {
            if let itemsArray = sortedGroupedItems[key]{
                sortedGroupedItems[key] = sort(itemsArray, in: order)
            }
        }
        return sortedGroupedItems
    }

    func sort() {
        if isGrouped {
            if isSearching {
                self.groupedShoppingItemSearchResults = sortGroupedItems(groupedShoppingItemSearchResults, in: self.reverseOrder)
            } else {
                self.groupedShoppingItemList = sortGroupedItems(groupedShoppingItemList, in: reverseOrder)
            }
            
        } else {
            if isSearching {
                self.shoppingItemSearchResults = sort(shoppingItemSearchResults, in: reverseOrder)
            } else {
                self.shoppingItemList = sort(shoppingItemList, in: reverseOrder)
            }
            
        }
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = true
        self.shoppingItemSearchResults = searchText.isEmpty ? self.shoppingItemList : self.shoppingItemList.filter({ (item) -> Bool in
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        if isGrouped {
            groupSearchResults()
        }
        shoppingTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" ,
            let nextScene = segue.destination as? ItemDetailsViewController ,
            let indexPath = self.shoppingTableView.indexPathForSelectedRow {
            if isGrouped {
                if isSearching {
                    if let array = self.groupedShoppingItemSearchResults[self.searchResultGroupNames[indexPath.section]] {
                        nextScene.selectedItem = array[indexPath.row]
                    }
                } else {
                    if let array = self.groupedShoppingItemList[self.groupNames[indexPath.section]] {
                        nextScene.selectedItem = array[indexPath.row]
                    }
                }
            } else {
                if isSearching {
                    nextScene.selectedItem = shoppingItemSearchResults[indexPath.row]
                } else {
                    nextScene.selectedItem = shoppingItemList[indexPath.row]
                }
                
            }
            
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isGrouped {
            if isSearching {
                return self.groupedShoppingItemSearchResults.keys.count
            } else {
                return self.groupedShoppingItemList.keys.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isGrouped {
            if isSearching {
                if let array = self.groupedShoppingItemSearchResults[self.searchResultGroupNames[section]] {
                    return array.count
                }
            } else {
                if let array = self.groupedShoppingItemList[self.groupNames[section]] {
                    return array.count
                }
            }
        } else {
            if isSearching {
                return self.shoppingItemSearchResults.count
            } else {
                return self.shoppingItemList.count
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ShoppingListViewCell
        if isGrouped {
            if isSearching {
                if let array = self.groupedShoppingItemSearchResults[self.searchResultGroupNames[indexPath.section]] {
                    cell.setupWithItemData(array[indexPath.row])
                }
            } else {
                if let array = self.groupedShoppingItemList[self.groupNames[indexPath.section]] {
                    cell.setupWithItemData(array[indexPath.row])
                }
            }
        } else {
            if isSearching {
                cell.setupWithItemData(shoppingItemSearchResults[indexPath.row])
            } else {
                cell.setupWithItemData(shoppingItemList[indexPath.row])
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isGrouped {
            if isSearching {
                return self.searchResultGroupNames[section]
            } else {
                return self.groupNames[section]
            }
        }
        return ""
    }
}

