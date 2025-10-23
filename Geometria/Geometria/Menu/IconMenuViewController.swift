//
//  IconMenuViewController.swift
//  Geometria
//
//  Created by Pietro Calamusa on 16/04/25.
//

import UIKit
import Foundation

struct IconSection {
    let title: String? // Titolo opzionale per la sezione
    let iconNames: [String]
}

class IconMenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var sections: [IconSection] = [
        IconSection(title: "Geometria", iconNames: ["Quadrato", "Rettangolo"]),
        IconSection(title: "Crittografia", iconNames: ["Rsa", "Miller-Rabin", "Diffie-Hellman"]),
        IconSection(title: "Artefatti", iconNames: ["Artefatti"]),
        IconSection(title: "Collezione Manga", iconNames: ["Manga"]),
        IconSection(title: "Utilità", iconNames: ["Converti temperature", "Magazzino"]),
        IconSection(title: "Prove", iconNames: ["Person Data", "Prova"]),
        // Aggiungi altre sezioni qui
    ]
    // La seguente riga non è più necessaria con la struttura a sezioni
    // let iconNames = ["Quadrato", "Rettangolo", "Rsa", "Miller-Rabin", "Diffie-Hellman", "Converti temperature"]
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.frame.width - 40) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // Altezza modificata precedentemente
        layout.minimumInteritemSpacing = 5 // Modifica questo valore (era 10)
        layout.minimumLineSpacing = 5 // Modifica questo valore (era 10)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 30) // Dimensioni dell'header

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: "IconCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader") // Registra l'header

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].iconNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! IconCollectionViewCell

        let iconName = sections[indexPath.section].iconNames[indexPath.item]
        cell.iconImageView.image = UIImage(named: iconName)
        //cell.iconLabel.text = nil // Assicurati che la label sia nil se non la usi

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
            headerView.titleLabel.text = sections[indexPath.section].title
            return headerView
        }
        return UICollectionReusableView() // Restituisci una view vuota se il kind non è header
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIconName = sections[indexPath.section].iconNames[indexPath.item]
        print("Icona \(selectedIconName) toccata nella sezione \(indexPath.section)!")

        switch selectedIconName {
        case "Quadrato":
            openQuadratoScreen()
            print("Hai toccato Quadrato nella sezione Geometria")
            // Aggiungi qui la logica per Quadrato
        case "Rettangolo":
            openRettangoloScreen()
            print("Hai toccato Rettangolo nella sezione Geometria")
            // Aggiungi qui la logica per Rettangolo
        case "Rsa":
            openRsaScreen()
            print("Hai toccato Rsa nella sezione Crittografia")
            // Aggiungi qui la logica per Rsa
        case "Miller-Rabin":
            openRabinScreen()
            print("Hai toccato Miller-Rabin nella sezione Crittografia")
            // Aggiungi qui la logica per Miller-Rabin
        case "Diffie-Hellman":
            openDiffieScreen()
            print("Hai toccato Diffie-Hellman nella sezione Crittografia")
            // Aggiungi qui la logica per Diffie-Hellman
        case "Converti temperature":
            openTempScreen()
            print("Hai toccato Converti temperature nella sezione Utilità")
            // Aggiungi qui la logica per Converti temperature
        case "Artefatti":
            openArtefactScreen()
            print("Hai toccato Artefatti nella sezione Artefatti")
        case "Manga":
            openMangaScreen()
            print("Hai toccato Manga nella sezione Collezione Manga")
        case "Person Data":
            openPersonScreen()
            print("Hai toccato Person Data nella sezione Prova")
        case "Magazzino":
            openMagazzinoScreen()
            print("Hai toccato Magazzino nella sezione Prova")
        case "Prova":
            openProvaScreen()
            print("Hai toccato Prova nella sezione Prova")
        default:
            break
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout (opzionale)

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let _ = sections[section].title {
            return CGSize(width: collectionView.frame.width, height: 30)
        }
        return CGSize.zero // Nessun header se il titolo è nil
    }
    
    func openQuadratoScreen() {
        let quadratoVC = QuadratoViewController()
        quadratoVC.modalPresentationStyle = .fullScreen
        quadratoVC.modalTransitionStyle = .crossDissolve
        present(quadratoVC, animated: true, completion: nil)
    }
    
    func openRettangoloScreen() {
        let rettangoloVC = RettangoloViewController()
        rettangoloVC.modalPresentationStyle = .fullScreen
        rettangoloVC.modalTransitionStyle = .crossDissolve
        present(rettangoloVC, animated: true, completion: nil)
    }
    
    func openRsaScreen() {
        let rsaVC = RsaViewController()
        rsaVC.modalPresentationStyle = .fullScreen
        rsaVC.modalTransitionStyle = .crossDissolve
        present(rsaVC, animated: true, completion: nil)
    }
    
    func openRabinScreen() {
        let rabinVC = RabinViewController()
        rabinVC.modalPresentationStyle = .fullScreen
        rabinVC.modalTransitionStyle = .crossDissolve
        present(rabinVC, animated: true, completion: nil)
    }
    
    func openDiffieScreen() {
        let hellmanVC = HellmanViewController()
        hellmanVC.modalPresentationStyle = .fullScreen
        hellmanVC.modalTransitionStyle = .crossDissolve
        present(hellmanVC, animated: true, completion: nil)
    }
    
    func openTempScreen() {
        let temperatureVC = TemperatureViewController()
        temperatureVC.modalPresentationStyle = .fullScreen
        temperatureVC.modalTransitionStyle = .crossDissolve
        present(temperatureVC, animated: true, completion: nil)
    }
    
    func openPersonScreen() {
        let personVC = PersonViewController()
        personVC.modalPresentationStyle = .fullScreen
        personVC.modalTransitionStyle = .crossDissolve
        present(personVC, animated: true, completion: nil)
    }
    
    func openMangaScreen() {
        let mangaVC = MangaViewController()
        mangaVC.modalPresentationStyle = .fullScreen
        mangaVC.modalTransitionStyle = .crossDissolve
        present(mangaVC, animated: true, completion: nil)
    }
    
    func openArtefactScreen() {
        let artefattiVC = ArtefattiViewController()
        artefattiVC.modalPresentationStyle = .fullScreen
        artefattiVC.modalTransitionStyle = .crossDissolve
        present(artefattiVC, animated: true, completion: nil)
    }
    
    func openMagazzinoScreen() {
        let magazzinoVC = MagazzinoViewController()
        magazzinoVC.modalPresentationStyle = .fullScreen
        magazzinoVC.modalTransitionStyle = .crossDissolve
        present(magazzinoVC, animated: true, completion: nil)
    }
    
    func openProvaScreen() {
        let provaVC = prova()
        provaVC.modalPresentationStyle = .fullScreen
        provaVC.modalTransitionStyle = .crossDissolve
        present(provaVC, animated: true, completion: nil)
    }
}
