//
//  GeometriaUITests.swift
//  GeometriaUITests
//
//  Created by Pietro Calamusa on 31/03/25.
//

import XCTest

final class GeometriaUITests: XCTestCase {

    override func setUpWithError() throws {
            continueAfterFailure = false
            // In UI tests it is usually best to stop immediately when a failure occurs.
        }

        override func tearDownWithError() throws {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

        func testCaricamentoSchermata() throws {
            // Verifica che la schermata si carichi e che alcuni elementi siano presenti
            let app = XCUIApplication()
            app.launch()

            XCTAssertTrue(app.staticTexts["schermataQuadratoLabel"].exists)
            XCTAssertTrue(app.textFields["latoTextField"].exists)
            XCTAssertTrue(app.buttons["calcolaAreaButton"].exists)
            XCTAssertTrue(app.buttons["calcolaPerimetroButton"].exists)
            XCTAssertTrue(app.buttons["aggiornaQuadratoButton"].exists)
            XCTAssertTrue(app.buttons["chiudiButton"].exists)
            XCTAssertTrue(app.otherElements["quadratoView"].exists)
        }

        func testCalcoloAreaCorretto() throws {
            // Verifica che il calcolo dell'area sia corretto
            let app = XCUIApplication()
            app.launch()

            let latoTextField = app.textFields["latoTextField"]
            latoTextField.tap()
            latoTextField.typeText("5")

            let calcolaAreaButton = app.buttons["calcolaAreaButton"]
            calcolaAreaButton.tap()

            let risultatoAreaLabel = app.staticTexts["risultatoAreaLabel"]
            XCTAssertEqual(risultatoAreaLabel.label, "Area: 25.0")
        }

        func testCalcoloPerimetroCorretto() throws {
            // Verifica che il calcolo del perimetro sia corretto
            let app = XCUIApplication()
            app.launch()

            let latoTextField = app.textFields["latoTextField"]
            latoTextField.tap()
            latoTextField.typeText("7")

            let calcolaPerimetroButton = app.buttons["calcolaPerimetroButton"]
            calcolaPerimetroButton.tap()

            let risultatoPerimeterLabel = app.staticTexts["risultatoPerimeterLabel"]
            XCTAssertEqual(risultatoPerimeterLabel.label, "Perimetro: 28.0")
        }

        func testAggiornamentoDimensioniQuadrato() throws {
            // Verifica che la dimensione del quadrato cambi dopo l'aggiornamento
            let app = XCUIApplication()
            app.launch()

            let quadratoView = app.otherElements["quadratoView"]
            let initialSize = quadratoView.frame.size

            let latoTextField = app.textFields["latoTextField"]
            latoTextField.tap()
            latoTextField.typeText("150")

            let aggiornaQuadratoButton = app.buttons["aggiornaQuadratoButton"]
            aggiornaQuadratoButton.tap()

            // Aspetta un breve periodo per l'animazione (potrebbe essere necessario un approccio più robusto per testare le animazioni)
            sleep(1)

            let finalSize = quadratoView.frame.size
            XCTAssertNotEqual(initialSize, finalSize)
            XCTAssertEqual(finalSize.width, 150.0)
            XCTAssertEqual(finalSize.height, 150.0)
        }

        func testChiusuraSchermata() throws {
            // Verifica che il bottone "Chiudi" esista (non possiamo facilmente testare la chiusura effettiva
            // della view controller in un UITest puro senza entrare in dettagli di navigazione)
            let app = XCUIApplication()
            app.launch()

            XCTAssertTrue(app.buttons["chiudiButton"].exists)

            // Potresti aggiungere un test più complesso se la chiusura innesca una navigazione specifica
            // e vuoi verificare la presenza della schermata precedente.
        }

        func testInserimentoTestoNonNumerico() throws {
            // Verifica che l'app gestisca l'inserimento di testo non numerico
            let app = XCUIApplication()
            app.launch()

            let latoTextField = app.textFields["latoTextField"]
            latoTextField.tap()
            latoTextField.typeText("abc")

            let calcolaAreaButton = app.buttons["calcolaAreaButton"]
            calcolaAreaButton.tap()

            let risultatoAreaLabel = app.staticTexts["risultatoAreaLabel"]
            XCTAssertEqual(risultatoAreaLabel.label, "Inserisci un numero valido")

            let calcolaPerimetroButton = app.buttons["calcolaPerimetroButton"]
            calcolaPerimetroButton.tap()

            let risultatoPerimeterLabel = app.staticTexts["risultatoPerimeterLabel"]
            XCTAssertEqual(risultatoPerimeterLabel.label, "Inserisci un numero valido")
        }
    }
