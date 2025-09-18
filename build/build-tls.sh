
#!/bin/bash

kubectl create secret tls elastic-tls \
  --cert=./ssl/cert.crt \
  --key=./ssl/cert.key \
  -n monitoring
