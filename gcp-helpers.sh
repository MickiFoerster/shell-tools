function gcp-create_bucket() {
    if [[ "$1" == "" ]]; then 
        echo "1st argument is name of the bucket and cannot be empty"
        return 1
    fi

    export PROJECT_ID=$(gcloud config get-value project)
    export BUCKET_NAME="${PROJECT_ID}-$1

    gsutil mb -p ${PROJECT_ID} gs://${BUCKET_NAME}
}
