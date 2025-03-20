#!/bin/sh

rand()
{
    od -An -N2 -i /dev/urandom | tr -d ' '
}

waitMsg(){
    pid="$1"
    msg="$2"
    msgDone="$3"
    sleepTime=0.1
    printf "%s -" "$msg"
    while kill -0 "$pid" 2>/dev/null; do
        printf "\b|"
        sleep "$sleepTime"
        printf "\b/"
        sleep "$sleepTime"
        printf "\b-"
        sleep "$sleepTime"
        printf "\b\\"
        sleep "$sleepTime"
    done
    printf "\b%s\n" "$msgDone"
}

elefantes(){
    echo "Un elefante, se balanceaba,"
    echo "sobre la tela de una araña."
    echo "Como veía que resistía,"
    echo "fue a llamar a otro elefante."
    for i in $(seq 2 "$1"); do
        echo "$i elefantes, se balanceaban,"
        echo "sobre la tela de una araña."
        echo "Como veían que resistía,"
        echo "fueron a llamar a otro elefante."
    done
}

template="pg.XXXX"
dir=$(mktemp -d -p "$PWD" -t "$template")

{
    cd "$dir" || exit 1
    mkdir comodines
    cd comodines || exit 1
    for i in $(seq 1 25); do
        for b in ax bx cx aa bb cc a; do
            for ext in pdf jpg txt; do
                file="${b}$(printf "%03d" "$i").${ext}"
                echo "Archivo $file" > "$file"
            done
        done
    done
    cd "$dir" || exit 1
    mkdir grep
    cd grep || exit 1
    maxElefantes=50
    for i in $(seq 1 "$maxElefantes"); do
        file=$(printf "%02d-elefantes.txt" "$i")
        elefantes "$i" > "$file"
    done
    rnd=$(($(rand) % (maxElefantes - 1) +1))
    file=$(printf "%02d-elefantes.txt" "$rnd")
    sed -i 's/elefante/pingüino/' "$file"
} &

jpid="$!"

waitMsg "$jpid" 'Creando playground: ' 'Terminado!!'
echo "Directorio playground: $dir"
