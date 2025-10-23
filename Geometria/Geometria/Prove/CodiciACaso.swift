//
//  CodiciACaso.swift
//  Geometria
//
//  Created by Pietro Calamusa on 25/04/25.
//

// MARK: - Database
import UIKit
import Foundation
import SQLite
func dataBase() {
    do {
        let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent("mydatabase").appendingPathExtension("sqlite3")
        let db = try Connection(fileURL.path)
        
        let users = Table("users")
        let name = Expression<String>(value: "name")
        let age = Expression<Int?>(value: 30)
        
        print ("Database aperto con successo!")
        do {
            try db.run(users.create(ifNotExists: true) {
                t in
                t.column(name)
                t.column(age)
            })
        } catch {
            print("Errore durante la creazione della tabella: \(error)")
        }
        print("\(users[age])")
    } catch {
        print("Errore durante l'apertura del database: \(error)")
    }
}

// MARK: - Notifica

/*
     let notifica = Notification(name: Notification.Name("Area Quadrato"), object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(gestnot), name: Notification.Name("updateQuadratoSize"), object: nil)
     NotificationCenter.default.post(notifica)
     
     func gestnot() {
     
     }
 */

// MARK: - Sito web

/*
import WebKit

// Dentro la classe
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        view = webView
    }
// Dentro la viewDidLoad
    let url = URL(string: "https://www.google.com")!
    let request = URLRequest(url: url)
    webView.load(request)
*/


// MARK: - Configurazione Bottoni

/*
    [].forEach {
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.systemGray6, for: .highlighted)
        $0.backgroundColor = .systemGray3
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
        $0.layer.shadowRadius = 5
    }
*/

// MARK: - Configurazione ButtonStackView

/*
    buttonStackView1.axis = .horizontal
    buttonStackView1.distribution = .fillEqually // O .equalSpacing
    buttonStackView1.spacing = 10 // Spazio tra i bottoni
    buttonStackView1.translatesAutoresizingMaskIntoConstraints = false
    [].forEach {
        buttonStackView1.addArrangedSubview($0)
    }
*/
