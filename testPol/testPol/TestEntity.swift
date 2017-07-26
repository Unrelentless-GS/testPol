//
//  TestEntity.swift
//  testPol
//
//  Created by Pavel Boryseiko on 26/7/17.
//  Copyright © 2017 GRIDSTONE. All rights reserved.
//

import UIKit
import MPOLKit
import Unbox


class TestEntity: MPOLKitEntity, Unboxable {

    var name: String?
    var alpha2_code: String?
    var alpha3_code: String?

    public required init(unboxer: Unboxer) throws {
        name = unboxer.unbox(key: "name")
        alpha2_code = unboxer.unbox(key: "alpha2_code")
        alpha3_code = unboxer.unbox(key: "alpha3_code")
        super.init()
    }
}
