services=$(docker-compose config --services)

# Loop through each service and remove its image
for service in $services; do
  image=$(docker-compose config | grep "image:" | grep $service | awk '{print $2}')
  if [ ! -z "$image" ]; then
    docker rmi $image
  fi
done
