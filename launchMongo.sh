docker run --name mongodb \
  -p 27017:27017 \
  -v /path_to_folder/data/:/data/db \
  -d mongo:latest
