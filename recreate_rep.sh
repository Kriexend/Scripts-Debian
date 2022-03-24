#Variables :
SOURCE="test" #Repertoire a copier
result="copy_rep_result.sh" #Script pour la recreation du repertoire
rep_result="COPY_REP_RESULT" #Dossier temporaire pour les fichiers de resultat
list_rep="$rep_result/list_rep" #Fichier temporaire contenant la liste des dossiers
ls_rep="$rep_result/ls_rep" #Fichier temporaire contenant les permissions des dossiers
#Lancement du script :
mkdir $rep_result #Creation du dossier temporaire
touch $result #Creation du fichier pour le resultat
find $SOURCE -type d -exec ls -ld {} \; >> $ls_rep #Recuperation de la liste des permissions des dossiers
while read ls
do
    ls="echo -e '$ls'"
    chmod_user=$($ls | cut -c 3-5 | tr -d -) #Droit utilisateur du dossier
    chmod_group=$($ls | cut -c 6-8 | tr -d -) #Droit groupe du dossier
    chmod_other=$($ls | cut -c 9-11 | tr -d -) #Droit autres du dossier
    chown_user=$($ls | awk '{print $3}') #Propriétaire du dossier
    chown_group=$($ls | awk '{print $4}') #Groupe du dossier
    rep_name=$(echo "$ls" | awk '{print $9}') #Nom du dossier
    echo mkdir -p $rep_name >> $result #Creation du dossier
    echo chmod u=$chmod_user,g=$chmod_group,o=$chmod_other $rep_name >> $result #Changement des permissions du dossier
    echo chown $chown_user:$chown_group $rep_name >> $result #Changement du propriétaire et du groupe du dossier
done < $ls_rep
chmod 755 $result #Droit d execution sur le script de recreation 
rm -Rf COPY_REP_RESULT #Suppression du dossier temporaire
