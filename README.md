# CYCLE_DEV

## Github

### 1. Initialiser le projet
echo "# CYCLE_DEV" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main

### 2. Lier avec SSH
git remote add origin git@github.com:VDB06500/CYCLE_DEV.git

### 3. Pousser
git push -u origin main

### 4. Commandes

- Vérifier la clé SSH
ssh -T git@github.com
>> Hi VDB06500! You've successfully authenticated, but GitHub does not provide shell access.

- Vérifier l'URL du remote
git remote -v 
>> origin  git@github.com:VDB06500/CYCLE_DEV.git (fetch)
>> origin  git@github.com:VDB06500/CYCLE_DEV.git (push)

### 5. Synthèse

#### CONFIGURATION		

Définir nom utilisateur	
git config --global user.name "John"

Définir email
git config --global user.email "john@email.com"

Voir configuration
git config --list
>> credential.helper=osxkeychain
>> filter.lfs.required=true
>> filter.lfs.clean=git-lfs clean -- %f
>> filter.lfs.smudge=git-lfs smudge -- %f
>> filter.lfs.process=git-lfs filter-process
>> user.name=LAURENT06500
>> user.email=contact@sobox.fr
>> core.repositoryformatversion=0
>> core.filemode=true
>> core.bare=false
>> core.logallrefupdates=true
>> core.ignorecase=true
>> core.precomposeunicode=true
>> remote.origin.url=git@github.com:VDB06500/CYCLE_DEV.git
>> remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
>> branch.main.remote=origin
>> branch.main.merge=refs/heads/main

#### DÉMARRER		
Initialiser repository	
git init

Cloner repository distant	
git clone https://github.com/user/repo.git

#### INFORMATIONS		
État des fichiers	
git status

Historique des commits	
git log --oneline
>> 494fc60 (HEAD -> main, origin/main) Maj projet complet
>> a2c202a first commit

Voir modifications	
git diff

#### COMMITS		
Ajouter fichiers au staging	
git add .

Créer commit	
git commit -m "message"

Modifier dernier commit	git commit --amend

#### BRANCHES		
Lister branches	
git branch

Créer branche	
git branch feature1

git checkout main	
Changer de branche	

Créer et changer	
git checkout -b feature1

Fusionner branches	
git merge feature1

SYNCHRONISATION		
git remote add	Ajouter remote	git remote add origin URL
git push	Pousser vers remote	git push origin main
git pull	Récupérer modifications	git pull origin main
git fetch	Télécharger sans fusionner	git fetch origin

ANNULER		
git reset	Annuler git add	git reset
git restore	Annuler modifications	git restore fichier.txt
git reset --hard	Tout annuler	git reset --hard HEAD

AVANCÉ		
git stash	Sauvegarder temporairement	git stash
git tag	Créer tag	git tag v1.0.0
git rebase	Réorganiser historique	git rebase main