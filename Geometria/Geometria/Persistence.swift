//
//  Persistence.swift
//  Geometria
//
//  Created by Pietro Calamusa on 12/04/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Geometria") // Usa il nome esatto del tuo .xcdatamodeld
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Errore nel caricamento del database: \(error)")
            }
        }
    }
}
