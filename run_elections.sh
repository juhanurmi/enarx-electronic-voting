#!/bin/bash

# Usage
if [ $# != 1 ] ; then
  echo "Usage: $0 [normal/kvm/sgx/sev]" >&2
  exit 1
fi

cd voting-machine

# Build
cargo build --release --target=wasm32-wasi

ERR_MSG="You did not give the argument required: normal, kvm, sgx, sev"

if [[ ${1?$ERR_MSG} == "normal" ]]; then
  echo "Normal application execution"
  # Run the app without Enarx
  cargo run --release
elif [[ ${1?$ERR_MSG} == "kvm" ]]; then
  echo "KVM application execution"
  # Run the app inside the Enarx keep in KVM
  enarx run --backend=kvm target/wasm32-wasi/release/voting-machine.wasm
elif [[ ${1?$ERR_MSG} == "sgx" ]]; then
  echo "Intel SGX protected application execution"
  # Run the app inside the Enarx keep in SGX
  enarx run --backend=sgx target/wasm32-wasi/release/voting-machine.wasm
elif [[ ${1?$ERR_MSG} == "sgx" ]]; then
  echo "AMD SEV protected application execution"
  # Run the app inside the Enarx keep in SEV
  enarx run --backend=sev target/wasm32-wasi/release/voting-machine.wasm
else
    echo $ERR_MSG
    exit 1
fi
