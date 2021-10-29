//
//  UserDefaultsLayer.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 28.10.2021.
//

import Foundation

/// HistoryDataProtocol. Procol that requires Save, Load and Edit some Data in UserDefaults
protocol HistoryDataProtocol {
    func saveSearchQuery(for object: String)
    func loadHistory(closure: @escaping ([String]) -> Void)
    func saveNewHistory(history: [String])
}

/// UserDefaultsLayer. Singleton Class that provide Saving, Modifying and Loading Data from UserDafaults.
class UserDefaultsLayer: HistoryDataProtocol {
    
    /// Key of UseDefaults that associated with stored data
    private let codingKey: String = "history"
    /// Object of Standart configuration of UserDefaults
    private let defaults = UserDefaults.standard
    
    /**
     Variable that giving access to class instance.
     - returns:
     Instance UserDefaultsLayer.
     */
    static let shared: UserDefaultsLayer = {
        let shared = UserDefaultsLayer()
        return shared
    }()
    
    private init () {
        
    }
    /**
     Loading Data from UserDefaults using *codingKey*
     - returns:
     Void
     - parameters:
     - closure: Closure that has *[String]* and will runs  into Main Queue
     */
    func loadHistory(closure: @escaping ([String]) -> Void) {
        
        /// Create Job in GLobalQueue with Qos
        DispatchQueue.global(qos: .default).async { [weak self] in
            
            /// Geting *codingKey*
            guard let key = self?.codingKey else { return }
            
            /// Check, if in UserDefault exists data with key, send it into Closure.
            if let existing = self?.defaults.array(forKey: key) as? [String] {
                
                /// Runs closure in Main Queue asynchoronos
                DispatchQueue.main.async {
                    closure(existing)
                }
            } else {
                return
            }
        }
    }
    
    /**
     Saving new element to UserDefaults using *codingKey*
     - returns:
     Void
     - parameters:
     - object: Some string, that will be save.
     */
    func saveSearchQuery(for object: String) {
        
        /// Create Job in GLobalQueue with Qos
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            /// Geting *codingKey*
            guard let key = self?.codingKey else { return }
            
            if var existing = self?.defaults.array(forKey: key) as? [String] {
                
                /// Check, if that string existing nod adding it to UserDefaults. If not exist add new element and save new UserDefaults
                if existing.contains(where: {$0 == object}) {
                    return
                } else {
                    existing.append(object)
                }
                
                self?.defaults.set(existing, forKey: key)
            } else {
                self?.defaults.set([object], forKey: key)
            }
        }
    }
    
    
    /**
     Saving edited Data to UserDefaults using *codingKey*
     - returns:
     Void
     - parameters:
     - history: Array of string that will be save.
     */
    func saveNewHistory(history: [String]) {
        
        /// Create Job in GLobalQueue with Qos
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            /// Saving edited data in UserDefaults.
            guard let key = self?.codingKey else { return }
            self?.defaults.removeObject(forKey: key)
            self?.defaults.set(history, forKey: key)
        }
    }
    
}

