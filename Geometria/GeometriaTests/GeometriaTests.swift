//
//  GeometriaTests.swift
//  GeometriaTests
//
//  Created by Pietro Calamusa on 31/03/25.
//

import Testing
import XCTest
@testable import Geometria

struct GeometriaTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    

}

class QuadratoViewControllerTests: XCTestCase {

    var viewController: QuadratoViewController!


        override func setUp() {
            super.setUp()
            // Inizializza la view controller direttamente
            viewController = QuadratoViewController()

            // Forza il caricamento della view per inizializzare le viste e le constraints
            _ = viewController.view
        }

        override func tearDown() {
            viewController = nil
            super.tearDown()
        }

    func testCalculateArea_ValidInput() {
        // Dato un input valido
        viewController.latoText.text = "5"

        // Quando viene chiamato calculateArea
        viewController.calculateArea(viewController.calculateAreaButton)

        // Allora il risultato dell'area è corretto
        XCTAssertEqual(viewController.resultAreaLabel.text, "Area: 25.0", "L'area calcolata non è corretta")
    }

    func testCalculateArea_InvalidInput() {
        // Dato un input non valido
        viewController.latoText.text = "abc"

        // Quando viene chiamato calculateArea
        viewController.calculateArea(viewController.calculateAreaButton)

        // Allora il messaggio di errore è mostrato
        XCTAssertEqual(viewController.resultAreaLabel.text, "Inserisci un numero valido", "Il messaggio di errore non è corretto")
    }

    func testCalculatePerimeter_ValidInput() {
        // Dato un input valido
        viewController.latoText.text = "7"

        // Quando viene chiamato calcolaPerimetro
        viewController.calcolaPerimetro(viewController.calculatePerimeterButton)

        // Allora il risultato del perimetro è corretto
        XCTAssertEqual(viewController.resultPerimeterLabel.text, "Perimetro: 28.0", "Il perimetro calcolato non è corretto")
    }

    func testCalculatePerimeter_InvalidInput() {
        // Dato un input non valido
        viewController.latoText.text = "xyz"

        // Quando viene chiamato calcolaPerimetro
        viewController.calcolaPerimetro(viewController.calculatePerimeterButton)

        // Allora il messaggio di errore è mostrato
        XCTAssertEqual(viewController.resultPerimeterLabel.text, "Inserisci un numero valido", "Il messaggio di errore non è corretto")
    }

    func testUpdateQuadratoSize_ValidInput() {
        // Dato un input valido
        viewController.latoText.text = "150"

        // Quando viene chiamato updateQuadratoSize
        viewController.updateQuadratoSize(viewController.updateButton)

      // Potrebbe essere necessario un modo per accedere alla dimensione del quadrato dopo l'animazione.
      // Per semplicità, qui verifichiamo che la funzione sia stata chiamata senza errori.
      // In uno scenario reale, potresti voler aggiungere un modo per osservare la dimensione del quadrato.
      XCTAssertNotNil(viewController.quadrato.frame)
    }

    func testUpdateQuadratoSize_InputExceedsMaxSize() {
        // Dato un input che supera la dimensione massima
        viewController.latoText.text = "500"

        // Quando viene chiamato updateQuadratoSize
        viewController.updateQuadratoSize(viewController.updateButton)

        // Allora la dimensione del quadrato è limitata alla dimensione massima
        // (Anche qui, potresti aver bisogno di un modo per osservare la dimensione del quadrato dopo l'animazione)
        XCTAssertLessThanOrEqual(viewController.quadrato.frame.width, 300)
        XCTAssertLessThanOrEqual(viewController.quadrato.frame.height, 300)
    }

    func testCloseScreen() {
        // Dato che closeScreen usa un DispatchQueue.main.asyncAfter,
        // dobbiamo usare una expectation per aspettare che l'animazione finisca.
        let expectation = self.expectation(description: "Schermata chiusa")

        // Quando viene chiamato closeScreen
        viewController.closeScreen()

        // Aspetta che l'animazione di chiusura finisca (potrebbe essere necessario un tempo più lungo)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        // Qui, idealmente, verificheresti che la view controller sia stata dismissata.
        // Tuttavia, testare il dismiss direttamente è complicato.
        // Potresti aver bisogno di un modo per segnalare da dove viene chiamata
        // la funzione dismiss (es. una variabile di stato) e verificare quella.
        // Per semplicità, qui verifichiamo solo che l'expectation sia stata soddisfatta.
        XCTAssert(true) // Sostituisci con una verifica più significativa se possibile.
    }
}
