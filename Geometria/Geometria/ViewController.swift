//
//  ViewController.swift
//  Geometria e Crittografia
//
//  Created by Pietro Calamusa on 31/03/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let menuButton = UIButton(type: .system)
        menuButton.setTitle("Apri Menu", for: .normal)
        menuButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)

        let menu = UIMenu(title: "Opzioni", children: [
            UIAction(title: "Prova", handler: { _ in self.openProvaScreen() }),
            UIAction(title: "Quadrato", handler: { _ in self.openQuadratoScreen() }),
            UIAction(title: "Rettangolo", handler: { _ in self.openRettangoloScreen() }),
            UIAction(title: "Rsa", handler: { _ in self.openRsaScreen() }),
            UIAction(title: "Miller-Rabin", handler: { _ in self.openRabinScreen()}),
            UIAction(title: "Diffie-Hellman", handler: { _ in self.openDiffieScreen()}),
            UIAction(title: "Converti temperature", handler: { _ in self.openTempScreen()}),
            UIAction(title: "Person data", handler: {_ in self.openPersonScreen()}),
            UIAction(title: "Manga collection", handler: {_ in self.openMangaScreen()}),
            UIAction(title: "Stats Builder", handler: {_ in self.openArtefactScreen()}),
            UIAction(title: "Esci", attributes: .destructive, handler: { _ in print("Hai selezionato Esci") })
        ])
        
        menuButton.menu = menu
        menuButton.showsMenuAsPrimaryAction = true
        
        // Aumenta la dimensione del testo
        menuButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        view.addSubview(menuButton)
    }
    
    func openQuadratoScreen() {
        let quadratoVC = QuadratoViewController()
        quadratoVC.modalPresentationStyle = .fullScreen
        present(quadratoVC, animated: true, completion: nil)
    }
    
    func openRettangoloScreen() {
        let rettangoloVC = RettangoloViewController()
        rettangoloVC.modalPresentationStyle = .fullScreen
        present(rettangoloVC, animated: true, completion: nil)
    }
    
    func openRsaScreen() {
        let rsaVC = RsaViewController()
        rsaVC.modalPresentationStyle = .fullScreen
        present(rsaVC, animated: true, completion: nil)
    }
    
    func openRabinScreen() {
        let rabinVC = RabinViewController()
        rabinVC.modalPresentationStyle = .fullScreen
        present(rabinVC, animated: true, completion: nil)
    }
    
    func openDiffieScreen() {
        let hellmanVC = HellmanViewController()
        hellmanVC.modalPresentationStyle = .fullScreen
        present(hellmanVC, animated: true, completion: nil)
    }
    
    func openTempScreen() {
        let temperatureVC = TemperatureViewController()
        temperatureVC.modalPresentationStyle = .fullScreen
        present(temperatureVC, animated: true, completion: nil)
    }
    
    func openPersonScreen() {
        let personVC = PersonViewController()
        personVC.modalPresentationStyle = .fullScreen
        present(personVC, animated: true, completion: nil)
    }
    
    func openMangaScreen() {
        let mangaVC = MangaViewController()
        mangaVC.modalPresentationStyle = .fullScreen
        present(mangaVC, animated: true, completion: nil)
    }
    
    func openArtefactScreen() {
        let artefattiVC = ArtefattiViewController()
        artefattiVC.modalPresentationStyle = .fullScreen
        present(artefattiVC, animated: true, completion: nil)
    }
    
    func openProvaScreen() {
        let provaVC = IconMenuViewController()
        provaVC.modalPresentationStyle = .fullScreen
        present(provaVC, animated: true, completion: nil)
    }
}



