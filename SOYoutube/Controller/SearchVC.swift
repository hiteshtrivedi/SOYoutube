//
//  SearchVC.swift
//  SOYoutube
//
//  Created by Hitesh on 11/7/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var tblSearchVideos: UITableView!
    @IBOutlet weak var searchBarvideo: UISearchBar!
    
    var arrSearch = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var actionBack: UIButton!
    
    
    //MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSearch.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell? {
        let cell:VideoListCell = tableView.dequeueReusableCellWithIdentifier("VideoListSearchCell", forIndexPath: indexPath) as! VideoListCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let videoDetails = arrSearch[indexPath.row]
        
        cell.lblVideoName.text = videoDetails["videoTitle"] as? String
        cell.lblSubTitle.text = videoDetails["videoSubTitle"] as? String
        
        cell.imgVideoThumb.sd_setImageWithURL(NSURL(string: (videoDetails["imageUrl"] as? String)!))
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    }

    // MARK: - Searchbar Delegate -
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        tblSearchVideos.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        tblSearchVideos.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.arrSearch.removeAllObjects()
            self.tblSearchVideos.reloadData()
            return
        }else if searchText.characters.count > 1 {
            self.arrSearch.removeAllObjects()
            self.searchYouttubeVideoData(searchText)
        }else{
            self.arrSearch.removeAllObjects()
            self.tblSearchVideos.reloadData()
        }
    }
    
    //MARK: Search Videos
    func searchYouttubeVideoData(searchText:String) -> Void {
        SOYoutubeAPI().getVideoWithTextSearch(searchText, nextPageToken: "", completion: { (videosArray, succses, nextpageToken) in
            if(succses == true){
                self.arrSearch.addObjectsFromArray(videosArray)
                if(self.arrSearch.count ==  0){
                    self.tblSearchVideos.hidden = true
                }else{
                    self.tblSearchVideos.hidden = false
                }
            }
            self.tblSearchVideos.reloadData()
        })
        
    }
    

    
    @IBAction func actionBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
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
