//
//  Extensions.swift
//  TestGame
//
//  Created by Natalya on 11/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SpriteKit

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count-1)))
        return self[index]
    }
}

