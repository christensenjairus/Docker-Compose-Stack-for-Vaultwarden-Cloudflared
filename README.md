# Docker-Compose Stack for Vaultwarden via a Cloudflare tunnel
Creates a Docker container stack of
1. Vaultwarden Server
2. Cloudflare tunnel

The cloudflare tunne allows for administration through Cloudflare to add a subdomain, HTTPS, access rules, and more, without the need for port forwarding, a firewall, or self-signed certs.
Vaultwarden won't let you log in anyway without an encrypted connection (HTTPS), so a docker-compose stack with Cloudflare is one of the easiest methods for obtaining an HTTPS connection.

# Setup
### Buy a Cloudflare domain
### Obtain a tunnel token
### Add the token into `docker-compose.yaml`
### Edit where the VaultWarden data will be stored
### Run the stack with `sudo docker-compose up -d`
### Verify the tunnel is working
### Set up HTTPS redirects in Cloudflare
### (Optional) ZeroTrust Access Rules
