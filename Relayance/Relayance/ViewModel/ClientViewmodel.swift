//
//  ClientViewmodel.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

class ClientViewmodel: ObservableObject {
    // MARK: - properties
    
    @Published var clients: [Client] = [] {
        didSet {
            print("change detected, sauving clients...")
            PersistenceService.save(clients: clients)
        }
    }
    
    @Published var message: String = ""
    
    // MARK: - initialization

    init() {
        chargerClients()
        print("clients load from persistance.)")
    }
    
    
    // MARK: - methods

    func chargerClients() {
        self.clients = PersistenceService.load()
    }
    
    func creerNouveauClient(nom: String, email: String) {
        guard !nom.isEmpty else {
            message = "Veuillez renseigner un nom"
            return
        }
        
        guard email.isEmail() else {
            message = "L'email n'est pas valide"
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let newClient = Client(
            nom: nom,
            email: email,
            dateCreationString: dateFormatter.string(from: Date.now)
        )
        
        if !clientExist(client: newClient) {
            clients.append(newClient)
            message = "Client ajouté avec succes"
        } else {
            message = "Le client existe déjà."
        }
        
    }
    
    func estNouveauClient(client: Client) -> Bool {
        let today = Date.now
        let dateCreation = client.dateCreation
        return Calendar.current.isDate(dateCreation, inSameDayAs: today)
    }
    
    func clientExist(client: Client) -> Bool {
        clients.contains { $0.email == client.email }
    }
    
    func formatDateVersString(client: Client) -> String {
        return Date.stringFromDate(client.dateCreation) ?? client.dateCreationString
    }
    
    func supprimerClient(client: Client) {
        if let index = clients.firstIndex(where: { $0.id == client.id }) {
            clients.remove(at: index)
            message = "Client supprimer avec success"
        }
    }
}
