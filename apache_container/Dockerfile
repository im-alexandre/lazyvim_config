# Use the official Apache HTTP server image as a parent image
FROM httpd:2.4

# Set the working directory
WORKDIR /usr/local/apache2/htdocs/

# Copy the current directory contents into the container at /usr/local/apache2/htdocs/
COPY . /usr/local/apache2/htdocs/

# Expose port 80
EXPOSE 80

