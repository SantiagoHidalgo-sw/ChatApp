//
//  DatabaseManager.swift
//  Chat
//
//  Created by Santiago Hidalgo on 18/01/2021.
//

import Foundation
import FirebaseDatabase


final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

/// Inserta un usuario nuevo



extension DatabaseManager {
    
    public func userExist(with email: String, completion: @escaping (Bool)->Void) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value , with: {snapshot in
            guard  snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
        
    }
    
    public func insertUser(with user: UsuarioChat){
        database.child(user.safeEmail).setValue(["nombre":user.nombre,"apellido" : user.apellido
        ])
    }
}

struct UsuarioChat{
    let nombre:String
    let apellido: String
    let emailAddres:String
    
    var safeEmail: String {
        var safeEmail = emailAddres.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
    }
}

    

