def menu_principal

    puts "-------------------------"
    tab = ["Achat de médicament", "Approvisionnement en médicaments", "Etats des stocks et des credits", "Quitter"]
    tab.each_with_index {|op,i| puts "#{i+1}. #{op}"}
    puts "-------------------------"
    choice = 0
    while choice < 1 || choice > 4
        print "Entrez votre choix :"
        choice = gets.chomp.to_i
    end
    return choice
end

class Client
    attr_reader :nom, :credit
    def initialize (nom, credit)
        @nom = nom
        @credit = credit
    end
    # paiement : somme donnée par le client
    # cout : prix total des médicaments achetés
    def achat(paiement,cout)
        @credit += cout - paiement
    end
end

class Medicament
    attr_reader :nom, :prix, :stock
    def initialize (nom, prix, stock)
        @nom = nom
        @prix = prix
        @stock = stock
    end
    def majStock (montant)
        @stock += montant
    end
end

def lMedicament
    puts "Nom du medicament"
    found = []
    until found != []
        medicamentVoulu = gets.chomp
        found = $medicaments.select {|e| e.nom.to_s.downcase == medicamentVoulu.to_s.downcase}
        if found == []
            print "Médicament inconnu, réessayez\n"
        end
    end
    return found[0]
end

def lClient
    puts "Nom du client"
    found = []
    until found != []
        clientVoulu = gets.chomp
        found = $clients.select {|e| e.nom.to_s.downcase == clientVoulu.to_s.downcase}
        if found == []
            print "Client inconnu, réessayez\n"
        end
    end
    return found[0]
end

def approvisionnement
    medicament = lMedicament
    puts "Donner la quantité"
    montant = gets.chomp.to_i
    medicament.majStock(montant)
end

def achat
    client = lClient
    medicament = lMedicament
    puts "quelle est le montant du paiement ?"
    montant = gets.chomp.to_f
    puts "Quelle est la quantité acheter ?"
    quantite = gets.chomp.to_i
    if medicament.stock >= quantite
        medicament.majStock(-quantite)
        client.achat(montant, quantite * medicament.prix)
    else
        puts "Stock insufisant"
    end
end

def affichage
    puts "Affichage des stocks :"
    $medicaments.each{ |e| puts "  Stock du médicament #{e.nom} : #{e.stock}" }
    puts "Affichage des crédits :"
    $clients.each{ |e| puts "  Credit du client #{e.nom} : #{e.credit}" }
end

$clients = [
    Client.new("Tristan", 0),
    Client.new("Fred", 40),
    Client.new("Marie", 2),
    Client.new("William", 0),
    Client.new("Amaia", -30)
]

$medicaments = [
    Medicament.new("Aspiron", 20.40, 5),
    Medicament.new("Rhinoplexil", 19.15, 5),
    Medicament.new("Dolipram", 5.98, 80)
]

loop do
    choice = menu_principal
    if choice == 1
        achat
    elsif choice == 2
        approvisionnement
    elsif choice == 3
        affichage
    else 
        puts "Programme terminer"
        break
    end
end