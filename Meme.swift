//
//  Meme.swift
//  ImagePicker
//
//  Created by Nathaniel PiSierra on 3/28/16.
//  Copyright © 2016 Nathaniel PiSierra. All rights reserved.
//

import Foundation
import UIKit

struct Meme{

    var text: String
    var image: UIImage
    var memedImage: UIImage

}

class MemeStorage {
    static var instance = MemeStorage()
    
    private var memes: [Meme] = []
    
    func at(index: Int) -> Meme {
        return memes[index]
    }
    
    func add(meme: Meme) {
        memes.append(meme)
    }
    
    func delete(index: Int) {
        memes.removeAtIndex(index)
    }
    
    var count: Int {
        return memes.count
    }
}