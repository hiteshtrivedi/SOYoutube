//
//  TopVideoVC.swift
//  SOYoutube
//
//  Created by Hitesh on 11/7/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import SDWebImage

class TopVideoVC: UIViewController {

    @IBOutlet weak var tblTopvideos: UITableView!
    let arrVideos = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getTopVideosFromYoutube(self)
    }
    
    
    func getTopVideosFromYoutube(sender:AnyObject) {
        SOYoutubeAPI().getTopVideos("", showLoader : false) { (videosArray, succses, nextpageToken) in
            if succses == true {
                print(videosArray)
                self.arrVideos.addObjectsFromArray(videosArray)
                self.tblTopvideos.reloadData()
            }
        }
    }
    
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrVideos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:VideoListCell = tableView.dequeueReusableCellWithIdentifier("VideoListTopCell", forIndexPath: indexPath) as! VideoListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let videoDetails = arrVideos[indexPath.row]
        
        cell.lblVideoName.text = videoDetails["videoTitle"] as? String
        cell.lblSubTitle.text = videoDetails["videoSubTitle"] as? String
        
        cell.imgVideoThumb.sd_setImageWithURL(NSURL(string: (videoDetails["imageUrl"] as? String)!))
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }


    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var actionBack: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
