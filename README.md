# 🏆 **README - Job Transport PL (FiveM ESX)**  

## 🚚 Job Transport PL - FiveM ESX  
Un script complet et optimisé pour gérer une société de transport PL sur FiveM avec **système de livraison**, **gestion des employés** et **menu customisé**.  

---

## ✨ **Fonctionnalités**  

✅ **Gestion des employés** : Embauche, grades et licenciement via un menu RageUI.  
✅ **Spawn de camions selon le grade** : Véhicules configurables dans un fichier dédié.  
✅ **Spawn de remorque:** La remorque est requit pour les livraisons.  
✅ **Système de livraison avancé** : Sélection de destinations aléatoires selon la catégorie.  
✅ **Validation de livraison via PNJ** : Vérification du camion et de la remorque avant validation.  
✅ **Livraison payée en liquide** : L'argent est ajouté directement au joueur après validation.  
✅ **Possibilité d’annuler une livraison** : Confirmation via un menu interactif.  

---

## 📺 **Installation**  

### 1️⃣ **Téléchargement et Installation**  
- Télécharge le script depuis [GitHub](https://github.com/Ducratif/job_transport_pl/edit/main/README.md).  
- Place le dossier **`job_transport_pl`** dans `resources/`.  
- Ajoute ceci dans `server.cfg` :  
  ```ini
  ensure job_transport_pl
  ```

---

## ⚙️ **Configuration**  

### 🔹 **Grades et Permissions**  
Les grades disponibles :  
- **Patron** (gestion complète)  
- **Chef d'équipe**  
- **Chauffeur PL Expérimenté**  
- **Chauffeur PL**  
- **Apprenti Chauffeur PL**  
- **Stagiaire Chauffeur PL**  

📌 **Modification des grades** dans le fichier :  
💽 `job_transport_pl/server.lua`  

### 🔹 **Configuration des véhicules**  
Les camions autorisés sont définis ici :  
💽 `job_transport_pl/client/livraison.lua`  
```lua
local authorizedTrucks = {
    [`hauler`] = true,
    [`phantom`] = true,
    [`phantom3`] = true,
    [`phantom4`] = true
}
```
Ajoute des modèles personnalisés si besoin.
Les autres fichiers on aussi des configs de véhicule, merci de vérifier et adapter.

### 🔹 **Ajout de points de livraison**  
💽 `job_transport_pl/client/livraison.lua`  
```lua
local deliveryLocations = {
    ville = {
        {x = -694.80, y = -2454.77, z = 13.86, reward = 500},
        {x = -887.51, y = -3004.30, z = 13.08, reward = 500}
    },
    nordDucratif = {
        {x = -2194.89, y = 3301.98, z = 31.94, reward = 5000},
        {x = 40.64, y = 3682.99, z = 38.70, reward = 5500}
    }
}
```
Ajoute autant de points que tu veux ! 🗳️

Pour ajouter une catégorie, faite comme ceci:
```lua
local deliveryLocations = {
    exemple = {
        {x = -694.80, y = -2454.77, z = 13.86, reward = 500},
        {x = -887.51, y = -3004.30, z = 13.08, reward = 500}
    }
}
```

---

## 🎮 **Utilisation**  

### 📌 **Prendre un camion**  
- Accède au menu d’entreprise et choisis un camion adapté à ton grade.  
- Une seule sortie de véhicule à la fois.  

### 📌 **Prendre une remorque**  
- Approche toi du PNJ.
- Selectionne une remorque.
- Une fois sorti, approche ton camion en marche arriere.
- La remorque s'accroche tout seul.

### 📌 **Prendre une livraison**  
- Approche-toi du **PNJ de validation des bons de livraison**.  
- Vérifie que ton camion et ta remorque sont bien présents.
- Descend de ton camuion.
- Appuie sur `E` pour ouvrir le menu et choisis une catégorie.  
- Un **point GPS permanent** s’affiche jusqu’à la fin de la mission.  

### 📌 **Effectuer une livraison**  
- Une fois arrivé, un **PNJ est visible** sur place.  
- Vérifie que ta remorque est à **moins de 20 mètres**.  
- Détache la remorque puis **appuie sur `E`** pour valider.  
- La remorque est supprimée et tu reçois **ton paiement en liquide**.  

### 📌 **Annuler une livraison**  
- Appuie sur **`H`** pour ouvrir le menu d’annulation.  
- Confirme si tu veux **arrêter la livraison**.  
- Si tu annules, une notification est envoyée :  
  ```lua
  ESX.ShowNotification("Livraison annulée ! Le client est averti.")
  ```

### 📌 **Modifier la touche pour annuler une livraison**
- Va dans le dossier **client/livraison.lua**.
- A la ligne `289`.
- Change **74** par la touche que tu veux.
- [Documentation des touches FiveM](https://docs.fivem.net/docs/game-references/controls/)

---

## 🛠️ **Dépannage**  

### ❌ **Problème d’argent non reçu en liquide ?**  
- Vérifie que tu utilises bien `xPlayer.addMoney(reward)` au lieu de `xPlayer.addAccountMoney('cash', reward)`.  
- Ton ESX doit supporter `cash` comme **compte d'argent liquide**.  

### ❌ **Bug du PNJ de validation ?**  
- Assure-toi que ton camion et ta remorque sont bien **à proximité du PNJ**.  
- Si besoin, **redémarre le script** via :  
  ```
  restart job_transport_pl
  ```
  
### ❌ **Probleme de gestion des grades ?**
- Esseye la gestion via un second menu.
- Le script est par défaut un métier **farm**

### ❌ **La remorque s'attache pas ?** 
- Vérifie bien que le modele est fonctionnel.
- Va dans le dossier `client/force_trailer_attach.lua`.
- Ajoute le modele de la remorque dans `authorizedTrailers`.
- Aide toi des modeles présent ici: [Modele vehicule FiveM](https://docs.fivem.net/docs/game-references/vehicle-references/vehicle-models/)
- Oublie pas de modifier dans le meme fichier la catégorie `authorizedTrucks` pour le camion utiliser.

### ❌ **Un autre problème ?**
- Hésite pas a rejoindre notre [Serveur Discord](https://discord.gg/c8YB6RRCuq)

---

## 💡 **Crédits**  

👤 **Développé par :** [Ducratif](https://github.com/ducratif)  
📌 **Version :** 1.0.0  
🔗 **GitHub :** [Ducratif/job_transport_pl]([https://github.com/tonrepo](https://github.com/Ducratif/job_transport_pl))  

Merci d'utiliser ce script ! 🚛💨  

---

🔥 **Bon jeu et bonnes livraisons sur FiveM !** 🎮🚚

