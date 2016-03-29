//
//  MemeTableViewController.swift
//  ImagePicker
//
//  Created by Nathaniel PiSierra on 3/28/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        table.reloadData()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemeStorage.instance.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCellWithIdentifier("MemeCell")!
        let thisMeme = MemeStorage.instance.at(indexPath.row)
        
        cell.textLabel?.text = thisMeme.text
        cell.imageView?.image = thisMeme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = MemeStorage.instance.at(indexPath.row)
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            MemeStorage.instance.delete(indexPath.row)
            table.reloadData()
        }
    }
    
    @IBAction func makeMeme(sender: AnyObject) {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("MemeEditor")
        presentViewController(viewController!, animated: true, completion: nil)
    }

    
}
