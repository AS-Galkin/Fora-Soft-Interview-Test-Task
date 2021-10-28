//
//  UserDefaultsLayer.swift
//  ForaSoftInterview
//
//  Created by Александр Галкин on 28.10.2021.
//

import Foundation

protocol HistoryDataProtocol {
    func saveQuery(for object: String)
    func loadHistory(closure: @escaping ([String]) -> Void)
}

class UserDefaultsLayer: HistoryDataProtocol {

    private let codingKey: String = "history"
    private let defaults = UserDefaults.standard

    static let shared: UserDefaultsLayer = {
        let shared = UserDefaultsLayer()
        return shared
    }()

    private init () {

    }
    
    func loadHistory(closure: @escaping ([String]) -> Void) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let key = self?.codingKey else { return }
            
            if let existing = self?.defaults.array(forKey: key) as? [String] {
                DispatchQueue.main.async {
                    closure(existing)
                }
            } else {
                return
            }
        }
    }
    
    func saveQuery(for object: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let key = self?.codingKey else { return }
            
            if var existing = self?.defaults.array(forKey: key) as? [String] {
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
    
}

