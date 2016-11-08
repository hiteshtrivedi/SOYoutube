//  VideoListCell.swift
//  YoutubeApp

import UIKit

class VideoListCell: UITableViewCell {

    //Top VC
    @IBOutlet weak var imgVideoThumb: UIImageView!
    @IBOutlet weak var lblVideoName: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var lblVideoCount: UILabel!
    
    //Search VC
    @IBOutlet weak var lblVideoViews: UILabel!
    
    
    //Playlist
    @IBOutlet weak var lblPlaylistName: UILabel!
    @IBOutlet weak var lblPlaylistCreateTime: UILabel!
    @IBOutlet weak var lblPlaylistVideoCount: UILabel!
    @IBOutlet weak var btnCheckUncheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        imgVideoThumb.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
