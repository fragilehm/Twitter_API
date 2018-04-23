//
//  Entities.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import Foundation
import SwiftyJSON
struct Entities {
    var media: Medias
    init(json: JSON) {
        media = Medias(json: json["media"])
    }
    init() {
        media = Medias()
    }
}
struct ExtendedEntities {
    var media: Medias
    init(json: JSON) {
        media = Medias(json: json["media"])
    }
    init() {
        media = Medias()
    }
}
struct Media {
    var media_url: String
    var id_str: String
    var type: String
    var url: String
    var video_info: VideoInfo?
    init(json: JSON) {
        media_url = json["media_url"].stringValue
        id_str = json["id_str"].stringValue
        type = json["type"].stringValue
        url = json["url"].stringValue
        video_info = VideoInfo(json: json["video_info"])
    }
}
struct Medias {
    var medias = [Media]()
    init(json: JSON) {
        for media in json.arrayValue {
            medias.append(Media(json: media))
        }
    }
    init(){}
}
struct VideoInfo {
    var duration_millis: Int
    var variants: Variants
    init(json: JSON) {
        duration_millis = json["duration_millis"].intValue
        variants = Variants(json: json["variants"])
    }
}
struct Variant {
    var bitrate: Int
    var content_type: String
    var url: String
    init(json: JSON) {
        bitrate = json["bitrate"].intValue
        content_type = json["content_type"].stringValue
        url = json["url"].stringValue
    }
}
struct Variants {
    var variants = [Variant]()
    init(json: JSON) {
        for variant in json.arrayValue {
            variants.append(Variant(json: variant))
        }
    }
}
