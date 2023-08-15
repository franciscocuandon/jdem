SELECTED_OPTION=$1

JAVA_08=/usr/lib/jvm/java-8-openjdk-amd64/jre
JAVA_11=/usr/lib/jvm/java-11-openjdk-amd64
JAVA_17=/usr/lib/jvm/java-17-openjdk-amd64

isThisJavaJDKRouteSaved(){
    local isSaved=0
    local result="$(grep JAVA_HOME=\"$1\" /etc/environment -n)"
    if [ ! -z $result ]; then isSaved=1; fi
    echo $isSaved
}

getLastJavaJDKRouteSaved(){
    local lastJavaJDKRoute=\"\"
    
    if [ $(isThisJavaJDKRouteSaved $JAVA_08) = 1 ]; then lastJavaJDKRoute=$JAVA_08; fi
    if [ $(isThisJavaJDKRouteSaved $JAVA_11) = 1 ]; then lastJavaJDKRoute=$JAVA_11; fi
    if [ $(isThisJavaJDKRouteSaved $JAVA_17) = 1 ]; then lastJavaJDKRoute=$JAVA_17; fi

    echo $lastJavaJDKRoute
}

getNewJavaJDKRouteToSave(){
    local newJavaJDKRoute=\"\"

    if [ $SELECTED_OPTION = 8 ]; then newJavaJDKRoute=$JAVA_08; fi
    if [ $SELECTED_OPTION = 11 ]; then newJavaJDKRoute=$JAVA_11; fi
    if [ $SELECTED_OPTION = 17 ]; then newJavaJDKRoute=$JAVA_17; fi

    echo $newJavaJDKRoute
}

updateAlternatives(){
    update-alternatives --set java $(update-alternatives --list java | grep java-$SELECTED_OPTION)
    update-alternatives --set javac $(update-alternatives --list javac | grep java-$SELECTED_OPTION)
}

updateJavaJDKRoute(){
    local command="s%$1%$2%g"
    sed -i $command "/etc/environment"
}

if [ ! $(getLastJavaJDKRouteSaved) = $(getNewJavaJDKRouteToSave) ] 
then $(updateJavaJDKRoute $(getLastJavaJDKRouteSaved) $(getNewJavaJDKRouteToSave)) && updateAlternatives
fi

echo "New JAVA_HOME: $(getLastJavaJDKRouteSaved)"
echo "Restart session is needed to update JAVA_HOME globally"
