# Use official NGINX image as base
FROM nginx:alpine

# Copy a simple index.html file into the NGINX web root
COPY index.html /usr/share/nginx/html/index.html

