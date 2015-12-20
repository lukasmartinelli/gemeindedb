#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly EXCEL_DIR=${EXCEL_DIR:-/excel}
readonly TSV_DIR=${TSV_DIR:-/tsv}

function convert_all_xlsx() {
    for xlsx_file in $EXCEL_DIR/*.xlsx; do
        local file_name=${xlsx_file##*/}
        local base_name=${file_name%.xlsx}
        local tsv_file="$TSV_DIR/${base_name}.tsv"
        echo "Convert data from $xlsx_file into $tsv_file"
        python convert_xlsx.py "$xlsx_file" > "$tsv_file"
    done
}

function main() {
    convert_all_xlsx
}

main
