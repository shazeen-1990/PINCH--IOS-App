//
//  PageModel.swift
//  Pinch
//
//  Created by Shazeen Thowfeek on 08/03/2024.
//

import Foundation

struct Page: Identifiable{
    let id: Int
    let imageName: String
}


extension Page{
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
