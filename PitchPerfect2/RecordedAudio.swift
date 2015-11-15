//
//  RecordedAudio.swift
//  PitchPerfect2
//
//  Created by Roberta Voulon on 2015-09-25.
//  Copyright © 2015 Roberta Voulon. All rights reserved.
//

import Foundation

class RecordedAudio {
    var url: NSURL!
    var title: String!
    
    init(url: NSURL, title: String) {
        self.url = url
        self.title = title
    }
}