help() {
    echo """Usage: ./run.sh [-h] [-d]
-d: Delete deployed infrastructure.
    """
}

export_env() {
    set -a
    source .env_example
    set +a
}

delete_infra() {
    export_env
    cd infra
    make uninstall
}

create_infra() {
    export_env
    cd infra
    make install
    make run
}

while getopts ":hd" option; do
    case $option in
    h) # display Help
        help
        exit
        ;;
    d)  # delete infra
        delete_infra
        exit
        ;;
    esac
done

create_infra