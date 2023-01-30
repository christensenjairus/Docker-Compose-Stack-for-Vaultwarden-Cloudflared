# Docker-Compose Stack for Vaultwarden via a Cloudflare tunnel

![image](https://user-images.githubusercontent.com/58751387/215606494-8c5d30fe-10d9-4ec1-8061-6d1522b2dc74.png)

Creates a Docker container stack of
1. Vaultwarden Server
2. Cloudflare tunnel

The Cloudflare tunnel allows for administration through Cloudflare to add a subdomain, HTTPS,  access rules, and more, without the need for port forwarding, a firewall, or self-signed certs. 

This is important because Vaultwarden won't let you log in without an encrypted connection (HTTPS), so a docker-compose stack with Cloudflare is one of the easiest methods for obtaining an HTTPS connection to an otherwise non-encrypted system.

# Setup
### Buy a Cloudflare domain
This is out of scope of this documentation, however obtaining a cloudflare domain is super simple. Create a cloudflare account and buy a domain [here](https://www.cloudflare.com/products/registrar/). 

Following this README, you can run Vaultwarden on the root of this new domain or on a subdomain of your choice and have it be reachable to the outside world.

### Clone this repository
The following command will create a folder in your home folder titled `VaultWarden`. This will contain the files from this repository and hopefully soon contain Vaultwarden's data. 
*Note: Make sure to have `git` installed first.*
```bash
git clone https://github.com/christensenjairus/Docker-Compose-Stack-for-Vaultwarden-Cloudflared.git ~/VaultWarden && cd ~/VaultWarden
```

### Obtain a tunnel token
* Visit [Cloudflare’s Zerotrust Dashboard](https://dash.teams.cloudflare.com) and navigate via the left sidebar to `Access` > `Tunnels`. This page should look like this.

![image](https://user-images.githubusercontent.com/58751387/215606516-292461b1-b0a4-4721-8d64-69857db5f57e.png)

* Click `Create a Tunnel` and name it whatever you like. `Vaultwarden` is fine.
* Click `Save Tunnel`.
* Open the Tunnel configuration so you see a page that looks like this.

![image](https://user-images.githubusercontent.com/58751387/215606609-af0549fc-30fd-423c-92cf-9a6048f0acc7.png)

* Grab the token that is included in the command under `Install and run a connector`. In the above screenshot, the token starts with `eyJhI`. 
* Save this token in your clipboard for safekeeping. Keep this browser window open, we’ll come back to it.

### Add the token into `docker-compose.yaml`
In the docker-compose file, place the token on the following line.
```bash
    command: "tunnel --no-autoupdate run --token <token here!>"
```
Once done, it should look something like this
```bash
    command: "tunnel --no-autoupdate run --token eyJhIjoiYmNjMGFjZjYxZGM1Mzk2MzkxNjBhZjNhM2I4YTNjMTEiLCJ0IjoiYTg1YjczNWYtNTdjOC00ZGNmLTk2ZDgtMzkxNWEyNGI2OTAyIiwicyI6IllqRmxZV0ppTkRVdFlUazVNeTAwTlRjeExUZzNNekF0WWpZNFpqVm1NV1l5WldNNCJ9"
```

### Edit where the VaultWarden data will be stored
By default, Vaultwarden will use the vw-data folder created when cloning this repo, as long as you run `sudo docker-compose up -d` while in the same folder as the `docker-compose.yaml` file. 

If you’d like to store this data elsewhere, change the file path *to the left of the colon (:)* on the following line of `docker-compose.yaml`.
```bash
- ./vw-data:/data 
```
For example, this could be the following if I wanted it in Jacob’s Documents folder
```bash
- /home/jacob/Documents/VaultWarden_Data:/data
```

### Run the Stack
`cd` into the same folder as the `docker-compose.yaml` file and run the following to create and run the docker stack. The `-d` flag means ‘run in the background’ and can be omitted for debugging so you can see the vaultwarden and cloudflare logs.
```bash
sudo docker-compose up -d
```

### Verify the tunnel is working
* Go back to the Cloudflare Tunnel Page that we had grabbed the token from. There’s a space near the bottom of the page where you can verify your Tunnel is running. It looks like this

![image](https://user-images.githubusercontent.com/58751387/215606907-15cd8876-3b75-4ffd-8231-eafad885b1a8.png)

* When you tunnel is successfully set up, it will look like this

![image](https://user-images.githubusercontent.com/58751387/215606954-4ed8ba02-c119-46b9-bbd3-7a11fe58ce58.png)

* If this portion of the page isn’t visible, you can go back to `Access` > `Tunnels` and view the tunnel status from there. It will either say `Healthy` or `Down`.

![image](https://user-images.githubusercontent.com/58751387/215606983-c6e43555-352a-4af4-92b5-d50b89877777.png)

* Go back to the Tunnel configuration page and click `Public Hostname` at the top.  

![image](https://user-images.githubusercontent.com/58751387/215607025-54919f47-3789-4b3d-9646-7fb70c3ba226.png)

* Here you can add a public hostname to give Vaultwarden a URL of your choice on your subdomain. 
* Click `Add a public hostname`
* Add a subdomain (optional) and select your domain to craft Vaultwarden’s URL.
* Set the `Type` to be `HTTP` and the URL to be `vaultwarden:80`

![image](https://user-images.githubusercontent.com/58751387/215608263-52fbb225-591d-45d8-9692-c3e2cbf932c1.png)

* Click `Save hostname`.
Your vaultwarden instance should now be accessible from the internet on that URL. Try it!

### Set up HTTPS redirects in Cloudflare
Visit the [Cloudflare Dashboard](https://dash.cloudflare.com), click on your website, then navigate with the left side panel to `SSL/TLS` > `Overview`. This page will look like this

![image](https://user-images.githubusercontent.com/58751387/215607191-dea25891-ab4f-4774-bd0b-24f553dedbec.png)

* Select `Full (strict)` to ensure that the connection is always safely encrypted.
* Select `Edge Certificates` from the side menu. This page will look like this. 

![image](https://user-images.githubusercontent.com/58751387/215607241-21675706-ba8e-4599-b561-8d793ad5eabd.png)

* Turn on `Always use HTTPS` to ensure your traffic is never unencrypted.

### Cronjob to Backup Vaultwarden's Data
* Open the `backup.sh` file included in this repository
* Edit the file path on the following line to match where this folder is located on your computer.
```bash
cd /home/<username>/VaultWarden/
```
* Save and close this file.
* Run the following to view your scheduled jobs
```bash
sudo crontab -e
```
* Add the following to the bottom of the open crontab file. **Be sure to edit the file path this is using so it can find the right backup.sh file!** Verify that the command works by running the command yourself with `sudo` permissions. Once you know the command works, then put it into this file.
```bash
0 0 * * * /home/<username>/VaultWarden/backup.sh
```
* Save and exit this file. 
Your backups should now be running weekly. This will run the `backup.sh` file every night at midnight.  
