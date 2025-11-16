# Test de l'Application Notes

## Étapes de test à suivre :

### 1. Lancement de l'application
```bash
cd notes
flutter run
```

### 2. Test de connexion
- Utiliser les identifiants : `admin` / `password`
- Vérifier que la connexion fonctionne
- Vérifier la redirection vers l'écran des notes

### 3. Test de création de note
- Cliquer sur le bouton `+`
- Saisir un titre : "Ma première note"
- Saisir du contenu : "Ceci est le contenu de ma première note"
- Cliquer sur "Sauvegarder"
- Vérifier le retour à la liste
- **Vérifier que la note apparaît dans la liste**

### 4. Test d'édition
- Cliquer sur la note créée
- Modifier le titre ou le contenu
- Sauvegarder
- Vérifier que les modifications sont visibles

### 5. Test de suppression
- Cliquer sur le menu `⋮` d'une note
- Choisir "Supprimer"
- Confirmer la suppression
- Vérifier que la note disparaît

## Problèmes potentiels et solutions :

### Si les notes ne s'affichent pas :
1. Vérifier les logs dans la console Flutter
2. Les messages de debug devraient afficher :
   - "Note insérée avec ID: X, titre: ..."
   - "Nombre de notes récupérées: X"

### Si l'application plante :
1. Vérifier que les dépendances sont installées : `flutter pub get`
2. Nettoyer le build : `flutter clean && flutter pub get`
3. Redémarrer l'application

### Logs utiles :
- Regarder la console Flutter pour les messages de debug
- Les erreurs SQLite apparaîtront dans les logs