#!/bin/bash

# Enter the namespace where the service is deployed
namespace=datastore

#!/bin/bash

# Loop through all namespaces
#for namespace in $(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}'); do

  # Loop through all services in the current namespace
  for service in $(kubectl get services -n $namespace -o jsonpath='{.items[*].metadata.name}'); do

    # Get the annotation of the current service in the current namespace
    annotation=$(kubectl get svc $service -n $namespace -o jsonpath='{.metadata.annotations.external-dns\.alpha\.kubernetes\.io/hostname}')

    # Check if the annotation exists
    if [ -n "$annotation" ]; then

      # Replace the annotation if it matches "*.dev.tel.internal"
      new_annotation="${annotation//dev.tel.internal/wfm.pt.internal}"
      if [ "$new_annotation" != "$annotation" ]; then
        kubectl annotate svc $service -n $namespace "external-dns.alpha.kubernetes.io/hostname=$new_annotation" --overwrite=true
        echo -e "Annotation updated for service $service in namespace $namespace:\n$new_annotation\n"
      else
        echo -e "Annotation found for service $service in namespace $namespace:\n$annotation\n"
      fi

    fi


  done

#done