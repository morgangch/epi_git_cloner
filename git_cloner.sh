#!/bin/bash

# Get the variables from the .env file

set -o allexport
source .cloner.env
set +o allexport

# Fonction pour vérifier si l'entrée est un entier entre deux bornes
function is_valid_input {
    local input=$1
    local lower_bound=$2
    local upper_bound=$3

    if [[ $input =~ ^[0-9]+$ && $input -ge $lower_bound && $input -le $upper_bound ]]; then
        return 0
    else
        return 1
    fi
}

# Fonction pour demander à l'utilisateur de saisir une valeur
function prompt_user {
    local message=$1
    local input

    read -p "$message: " input
    echo $input
}

full_pwd=""

function get_pwd {
    local semester=$1
    local module=$2

    if ((semester == -1)); then
        full_pwd="$epi_path/Stumpers"
    elif ((semester == -2)); then
        full_pwd=$perso_path
    else
        full_pwd="$epi_path/Semestre$semester"
    fi
    if [ ! -d "$full_pwd" ]; then
        mkdir -p "$full_pwd"
    fi
    if ((semester >= 0)); then
        full_pwd+="/$module"
        if [ ! -d "$full_pwd"  ]; then
            mkdir -p "$full_pwd"
        fi
    fi
}

function project {
    # Demander à l'utilisateur de saisir le numéro du semestre
    semester=$(prompt_user "Entrez le numéro du semestre (entre 1 et 10)")
    while ! is_valid_input "$semester" 1 10; do
        echo "Erreur: Veuillez entrer un numéro de semestre valide (entre 1 et 10)."
        semester=$(prompt_user "Entrez le numéro du semestre (entre 1 et 10)")
    done
    semester2=$semester
    if ((semester < 10)); then
        semester2="0$semester2"
    fi

    # Demander à l'utilisateur de saisir le numéro du module
    module_list=("PSU" "CPE" "AIA" "MAT" "MUL" "DOP" "SEC" "PRO" "WEB" "PDG")
    module=$(prompt_user "Entrez le numéro du module (entre 1 et 20)
            1 - PSU
            2 - CPE
            3 - AIA
            4 - MAT
            5 - MUL
            6 - DOP
            7 - SEC
            8 - PRO
            9 - WEB
	    10 - PDG
            ")
    while ! is_valid_input "$module" 1 20; do
        echo "Erreur: Veuillez entrer un numéro de module valide (entre 1 et 20)."
        module=$(prompt_user "Entrez le numéro du module (entre 1 et 20)")
    done
    module_name="${module_list[$((module - 1))]}"

    # Demander à l'utilisateur de saisir le nom du responsable du projet
    is_me=$(prompt_user "Si vous êtes le leader du groupe, rentrez 1, sinon 0")
    while ! is_valid_input "$is_me" 0 1; do
        echo "Erreur: Veuillez entrer 0 si vous n'êtes pas le leader ou 1."
        is_me=$(prompt_user "Renseignez si vous êtes le leader du groupe ou non (0 ou 1)")
    done
    if ((is_me > 0)); then
        leader_fname=$fname
        leader_name=$name
    else
        leader_name=$(prompt_user "Entrez le nom de famille du leader du groupe")
        leader_fname=$(prompt_user "Entrez le prenom du leader du groupe")
    fi
    leader_fname=$(echo "$leader_fname" | tr '[:upper:]' '[:lower:]')
    leader_name=$(echo "$leader_name" | tr '[:upper:]' '[:lower:]')
    leader="$leader_fname.$leader_name"

    # Demander à l'utilisateur de savoir s'il y a un bootstrap
    bootstrap=$(prompt_user "Y a t il un repo github pour un bootstrap (0 ou 1)")
    while ! is_valid_input "$bootstrap" 0 1; do
        echo "Erreur: Veuillez entrer 0 s'il n'y a pas de bootstrap ou 1."
        bootstrap=$(prompt_user "Renseignez s'il y a un bootstrap ou non (0 ou 1)")
    done

    get_pwd $semester2 $module_name

    project_name=$(prompt_user "Nom du projet")
    project_name=$(echo "$project_name" | tr '[:upper:]' '[:lower:]')

    cd $full_pwd
    $gitswitch_path $user1
    repo_num="${semester}00"
    repo="B-$module_name-$repo_num-$city-$semester-1-$project_name-$leader"
    git clone "git@github.com:EpitechPromo$promo/$repo"
    mv $repo $project_name
    if ((bootstrap > 0)); then
        bs_repo="B-$module_name-$repo_num-$city-$semester-1-bs$project_name-$leader"
        git clone "git@github.com:EpitechPromo$promo/$bs_repo"
        mv $bs_repo "bs$project_name"
    else
        cd $project_name
    fi
}

function stumper {
    is_duo=$(prompt_user "Si le stumper est en duo, rentrez 1, sinon 0")
    while ! is_valid_input "$is_duo" 0 1; do
        echo "Erreur: Veuillez entrer 0 s'il n'y a pas de duo ou 1."
        is_duo=$(prompt_user "Renseignez s'il y a un duo ou non (0 ou 1)")
    done
    semester=$(prompt_user "Entrez le numéro du semestre (entre 1 et 2)")
    while ! is_valid_input "$semester" 1 2; do
        echo "Erreur: Veuillez entrer un numéro de semestre valide (entre 1 et 2)."
        semester=$(prompt_user "Entrez le numéro du semestre (entre 1 et 2)")
    done
    stumper_num=$(prompt_user "Numéro du stumper: (entre 1 et 14)")
    while ! is_valid_input "$stumper_num" 1 14; do
        echo "Erreur: Veuillez entrer un numéro de stumper valide (entre 1 et 14)."
        stumper_num=$(prompt_user "Entrez le numéro du stumper (entre 1 et 14)")
    done
    is_me=$(prompt_user "Si vous êtes le leader du groupe, rentrez 1, sinon 0")
    while ! is_valid_input "$is_me" 0 1; do
        echo "Erreur: Veuillez entrer 0 si vous n'êtes pas le leader ou 1."
        is_me=$(prompt_user "Renseignez si vous êtes le leader du groupe ou non (0 ou 1)")
    done
    if ((is_me > 0)); then
        leader_fname=$fname
        leader_name=$name
    else
        leader_name=$(prompt_user "Entrez le nom de famille du leader du groupe")
        leader_fname=$(prompt_user "Entrez le prenom du leader du groupe")
    fi
    leader_fname=$(echo "$leader_fname" | tr '[:upper:]' '[:lower:]')
    leader_name=$(echo "$leader_name" | tr '[:upper:]' '[:lower:]')
    leader="$leader_fname.$leader_name"

    $gitswitch_path $user1
    if ((is_duo > 0)); then
        repo="B-CPE-210-$city-$semester-1-stumper$stumper_num-$leader"
    else
        repo="B-CPE-210-$city-$semester-1-solostumper$stumper_num-$leader"
    fi
    get_pwd -1 "Stumper$stumper_num"
    cd $full_pwd
    git clone "git@github.com:EpitechPromo$promo/$repo"
    mv $repo "Stumper$stumper_num"
    cd "Stumper$stumper_num"
}

function big_perso {
    local user=$1
    local git_user=$2

    $gitswitch_path $user
    repo_name=$(prompt_user "Entrez le nom du repo")
    repo="git@github.com:$git_user/$repo_name"
    echo "Repo : $repo"
    get_pwd -2 $repo_name
    cd $full_pwd
    git clone $repo
    cd $repo_name
}

function perso {
    echo "Sur quel compte le projet est il ?"
    echo "1 - $user1"
    echo "2 - $user2"
    echo "3 - Annuler"
    choice=$(prompt_user "Entrez votre choix (1, 2 ou 3)")
    while ! is_valid_input "$choice" 1 3; do
        echo "Erreur: Veuillez entrer un choix valide (1, 2 ou 3)."
        choice=$(prompt_user "Entrez votre choix (1, 2 ou 3)")
    done

    case $choice in
        1)
            big_perso $user1 $git_user1
            ;;
        2)
            big_perso $user2 $git_user2
            ;;
        3)
            main
            ;;
    esac
}

function is_number_greater_than_ten {
    local input=$1

    # Supprimer tous les caractères qui ne sont pas des chiffres
    local num=$(echo "$input" | tr -cd '0-9')

    # Si la chaîne est vide après nettoyage, définir à 0
    if [ -z "$num" ]; then
        num=0
    fi

    # Comparer si le nombre est supérieur à 10
    if [ "$num" -gt 10 ]; then
        return 1
    else
        return 0
    fi
}

function big_piscine
{
    local module_name=$1
    local repo_num=$2
    local semester=$3
    local project_name=$4

    semester2=$semester
    if ((semester < 10)); then
        semester2="0$semester2"
    fi
    leader_fname=$(echo "$fname" | tr '[:upper:]' '[:lower:]')
    leader_name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
    leader="$leader_fname.$leader_name"

    get_pwd $semester2 $module_name

    pool_day=$(prompt_user "Day de Piscine")
    if (is_number_greater_than_ten "$pool_day"); then
        pool_day="0$pool_day"
    fi
    project_name="$project_name$pool_day"
    cd $full_pwd
    $gitswitch_path $user1
    repo="B-$module_name-$repo_num-$city-$semester-1-$project_name-$leader"
    git clone "git@github.com:EpitechPromo$promo/$repo"
    mv $repo $project_name
    cd $project_name
}

function piscine {
    echo "Quelle piscine faites-vous ?"
    echo "1 - Tek0"
    echo "2 - Tek2"
    choice=$(prompt_user "Entrez votre choix (1 ou 2)")
    while ! is_valid_input "$choice" 1 2; do
        echo "Erreur: Veuillez entrer un choix valide (1 ou 2)."
        choice=$(prompt_user "Entrez votre choix (1 ou 2)")
    done

    case $choice in
        1)
            big_piscine "CPE" 100 1 "CPOOLDAY"
            ;;
        2)
            big_piscine "PDG" 300 3 "PDGD"
            ;;
    esac
}

function main {
    echo "Que voulez-vous cloner ?"
    echo "1 - Projet"
    echo "2 - Stumper"
    echo "3 - Projet perso"
    echo "4 - Piscine"
    echo "5 - Quitter"
    choice=$(prompt_user "Entrez votre choix (1, 2, 3, 4 ou 5)")
    while ! is_valid_input "$choice" 1 5; do
        echo "Erreur: Veuillez entrer un choix valide (1, 2, 3, 4 ou 5)."
        choice=$(prompt_user "Entrez votre choix (1, 2, 3, 4 ou 5)")
    done

    case $choice in
        1)
            project
            ;;
        2)
            stumper
            ;;
        3)
            perso
            ;;
        4)
            piscine
            ;;
        5)
            return
            ;;
    esac
}

if [ $user1 == "" ]; then
    lang=$(prompt_user "Entrez la langue que vous souhaitez utiliser (fr ou en)")
    if [ $lang == "fr" ]; then
        echo "Bienvenue sur le cloner de projets Epitech !"
    else
        echo "Welcome to the Epitech project cloner!"
    fi
    user1=$(prompt_user "Entrez le nom d'utilisateur du premier compte github")
    git_user1=$(prompt_user "Entrez le nom d'utilisateur github du premier compte")
    user2=$(prompt_user "Entrez le nom d'utilisateur du deuxième compte github")
    git_user2=$(prompt_user "Entrez le nom d'utilisateur github du deuxième compte")
    perso_path=$(prompt_user "Entrez le chemin du dossier pour les projets perso")
    epi_path=$(prompt_user "Entrez le chemin du dossier pour les projets Epitech")
    promo=$(prompt_user "Entrez l'année de la promo (ex: 2023 pour la promo diplômée en 2023)")
    city=$(prompt_user "Entrez le nom de la ville en code à 3 lettres (ex: BDX pour Bordeaux)")
    fname=$(prompt_user "Entrez votre prénom")
    name=$(prompt_user "Entrez votre nom")
    echo "lang=$lang" >> .cloner.env
    echo "user1=$user1" >> .cloner.env
    echo "git_user1=$git_user1" >> .cloner.env
    echo "user2=$user2" >> .cloner.env
    echo "git_user2=$git_user2" >> .cloner.env
    echo "perso_path=$perso_path" >> .cloner.env
    echo "epi_path=$epi_path" >> .cloner.env
    echo "promo=$promo" >> .cloner.env
    echo "city=$city" >> .cloner.env
    echo "fname=$fname" >> .cloner.env
    echo "name=$name" >> .cloner.env
fi

main
