//
//  UserClass.swift
//  SnapchatClone
//
//  Created by Melik Demiray on 9.12.2023.
//

import Foundation


class UserSingleton {

    static let sharedUserInfo = UserSingleton()

    var email = ""
    var username = ""

    private init() {

    }

}
