//
//  ToChatTableViewCell.swift
//  Chat test
//
//  Created by Sourav@Beas on 28/08/17.
//  Copyright © 2017 beas. All rights reserved.
//

import UIKit

class ToChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imgChatBubble: UIImageView!
    @IBOutlet weak var txtChat: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var chatbubbleWidth: NSLayoutConstraint!
    @IBOutlet weak var chatbubbleHeight: NSLayoutConstraint!
    @IBOutlet weak var chatTxtWidth: NSLayoutConstraint!
    @IBOutlet weak var chatTxtHeight: NSLayoutConstraint!
    let rightChatBubbleimage = #imageLiteral(resourceName: "ChatOut").resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgChatBubble.image = rightChatBubbleimage
        imgChatBubble.tintColor = UIColor.black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
