# simple-and-fast
Simple and Fast Highly Available Web App on DigitalOcean

This is a script to compliment a demo given for using DigitalOcean

###The script:
- Creates 3 Droplets
- Each Droplet has a LAMP stack pre-installed
- An unique web page is put on each Droplet
- The Droplets are associated with the tag 'web'
- A CloudFirewall rule is created for the web tag to only allow HTTP traffic
- A Load Balancer is created to direct traffic to the 3 Droplets
