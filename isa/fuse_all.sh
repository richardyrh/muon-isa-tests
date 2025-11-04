#!/usr/bin/env bash
set -euo pipefail

# Ensure the script operates from the directory it lives in.
cd "$(dirname "${BASH_SOURCE[0]}")"

soc_dir_rel='../../soc'
output_dir='fused'

mkdir -p "${output_dir}"

shopt -s nullglob

for bin in *; do
    [[ -f "${bin}" ]] || continue
    [[ -x "${bin}" ]] || continue
    [[ "${bin}" == *.dump ]] && continue
    [[ "${bin}" == "$(basename "${BASH_SOURCE[0]}")" ]] && continue

    fused_path="$(make --silent -C "${soc_dir_rel}" fuse-temp MUON_ELF="$(pwd)/${bin}")"
    cp "${fused_path}" "${output_dir}/${bin}"
    echo "${output_dir}/${bin}"
done
