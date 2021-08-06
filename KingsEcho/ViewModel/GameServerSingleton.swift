//
//  GameServerSingleton.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/5/21.
//

import Foundation
import Firebase
import FirebaseDatabase


protocol GameServerDelegate:AnyObject {
    func updateGameParameters()
    func updateGamePlayers()
    
    func leaveGame()
    func bootedFromGame()
}

class GameServerSingleton {
    static let shared = GameServerSingleton()
    
    var publishedPostDelegate:GameServerDelegate?
//    var gamePlayersDelegate:GameServerDelegate?
    
    
}
