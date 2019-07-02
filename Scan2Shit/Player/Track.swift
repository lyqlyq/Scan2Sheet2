//
//  Track.swift
//  FrRadio
//
//  Created by Admin on 4/20/18.
//  Copyright © 2018 HCM. All rights reserved.
//

import Foundation
import Alamofire

class Track {
    var id: String!
    var title: String!
    var artist: String?
    var artworkURL: URL?
    var url: URL?
    
    var favorited: Bool!
    var isPodcast: Bool!
    
    var moreTitle1: String?
    var moreTitle2: String?
    var artworkImage: UIImage?
    
    var channelId: String!
    
//    convenience init(with channel: Channel) {
//        self.init()
//
//        id = channel.title
//        title = channel.title
//        artist = channel.subTitle
//        artworkURL = channel.avatarURL
//        if !channel.isPodcast {
//            url = URL(string: channel.streamLink)
//        }
//
//        favorited = channel.favorited
//        isPodcast = channel.isPodcast
//
//        moreTitle1 = title
//        moreTitle2 = artist
//
//        channelId = channel.channelId
//    }
    
    func loadArtworkImage(completion: (()->Void)? = nil) {
//        if let artworkURL = artworkURL {
//            Alamofire.request(artworkURL.absoluteString).responseImage { (response) in
//                self.artworkImage = response.result.value
//                completion?()
//            }
//        }
    }
}

extension Track : Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func != (lhs: Track, rhs: Track) -> Bool {
        return lhs.id != rhs.id
    }
}
