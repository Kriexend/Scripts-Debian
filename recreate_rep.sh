#!/bin/bash
#
# Creation: 0.1 jeudi 07/07/2022 - Killian LESAGE

# Script pour copier l arborescence d un dossier sous AIX

#------ Variables ------ :
# Date du jour
date=$(printf "%(%Y%m%d)T\n" -1)
# Script pour la recreation du repertoire
result="./copy_rep_result_$date.sh" 
# Dossier temporaire pour les fichiers de resultat
rep_result="COPY_REP_RESULT" 
# Fichier temporaire contenant la liste des dossiers
list_rep="$rep_result/list_rep" 
# Fichier temporaire contenant les permissions des dossiers
ls_rep="$rep_result/ls_rep" 

#------ Lancement du script ------ :
echo "################################################"
echo "##### Script Debian de copie de repertoire #####"
echo "################################################"
echo "______________________________________________"
echo "Entrer le chemin du repertoire a copier :"
read SOURCE
#------ Test si le repertoire a copier existe ------- :
if [ -d $SOURCE ];
then
    # Creation du dossier temporaire
    mkdir $rep_result 
    # Recuperation de la liste des permissions des dossiers
    find $SOURCE -type d -exec ls -ld {} \; >> $ls_rep 
    nb_ligne=$(wc -l $ls_rep | awk '{print $1}')
    echo "______________________________________________"
    echo "Creation du script de recreation du repertoire"
    #------ Creation du script de recreation du repertoire a copier ------ :
    while read ls
    do
        i=$((i+1))
        #Droit utilisateur du dossier
        chmod_user=$(echo -e $ls | cut -c 2-4 | tr -d -) 
        #Droit groupe du dossier 
        chmod_group=$(echo -e $ls | cut -c 5-7 | tr -d -) 
        #Droit autres du dossier
        chmod_other=$(echo -e $ls | cut -c 8-10 | tr -d -) 
        #Propriétaire du dossier
        chown_user=$(echo -e $ls | awk '{print $3}') 
        #Groupe du dossier
        chown_group=$(echo -e $ls | awk '{print $4}') 
        rep_name=$(echo -e $ls | awk '{print $9}')
        #Creation du dossier dans le script de recreation
        echo mkdir -p $rep_name >> $result 
        #Changement des permissions du dossier dans le script de recreation
        echo chmod u+$chmod_user,g+$chmod_group,o+$chmod_other $rep_name >> $result 
        #Changement du propriétaire et du groupe du dossier dans le script de recreation
        echo chown $chown_user:$chown_group $rep_name >> $result
        echo "Copie du dossier $rep_name"
        echo "Total : $i/$nb_ligne"
    done < $ls_rep
    #Droit d execution sur le script de recreation
    chmod 755 $result  
    #Suppression du dossier temporaire
    rm -Rf COPY_REP_RESULT 
    echo "______________________________________________"
    echo "Chemin du script de recreation du repertoire"
    echo "--> $result"
    echo "______________________________________________"
else
echo "Le repertoire $SOURCE n'existe pas."
fi
