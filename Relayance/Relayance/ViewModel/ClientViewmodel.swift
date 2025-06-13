//
//  ClientViewmodel.swift
//  Relayance
//
//  Created by Alassane Der on 29/05/2025.
//

import Foundation

class ClientViewmodel: ObservableObject {
    
    @Published var clients: [Client] = []
    @Published var succesMessage: String? = nil
    @Published var savingError: String? = nil
    
    private let persistence: Persistable
    
    init(persistence: Persistable = PersistenceService()) {
        self.persistence = persistence
        loadClients()
    }
    
    // MARK: - methods

    func loadClients() {
        do {
            clients = try persistence.load()
        } catch {
            savingError = "Loading client failed"
        }
    }
    
    func createNewClient(nom: String, email: String) {
        guard !nom.isEmpty else {
            savingError = "Veuillez renseigner un nom"
            return
        }
        
        guard email.isEmail() else {
            savingError = "L'email n'est pas valide"
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
            succesMessage = "Client ajouté avec succes"
            save()
        } else {
            savingError = "Le client existe déjà."
        }
        
    }
    
    func isNewClient(client: Client) -> Bool {
        let today = Date.now
        let dateCreation = client.dateCreation
        return Calendar.current.isDate(dateCreation, inSameDayAs: today)
    }
    
    func clientExist(client: Client) -> Bool {
        clients.contains { $0.email == client.email }
    }
    
    func formatDateToString(client: Client) -> String {
        return Date.stringFromDate(client.dateCreation) ?? client.dateCreationString
    }
    
    func deleteClient(client: Client) {
        if let index = clients.firstIndex(where: { $0.id == client.id }) {
            clients.remove(at: index)
            save()
            succesMessage = "Client supprimer avec success"
        }
    }
    
    private func save() {
        do {
            try persistence.save(clients)
        } catch {
            savingError = "Saving error: \(error.localizedDescription)"
        }
    }
}


/*
 // MARK: - properties
 
 @Published var clients: [Client] = [] {
     didSet {
         print("change detected, sauving clients...")
         persistenceService.save(clients)
     }
 }
 
 @Published var message: String? = nil
 let persistenceService: Persistable
 // MARK: - initialization

 init(persistenceService: PersistenceProtocol = PersistenceService()) {
     self.persistenceService = persistenceService
     chargerClients()
     print("clients load from persistance.)")
 }
 */
