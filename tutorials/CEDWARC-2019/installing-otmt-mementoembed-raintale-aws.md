# Installing the Off-Topic Memento Toolkit (OTMT), MementoEmbed, and Raintale on an AWS instance

The exercises in this tutorial were developed for use with an [Amazon Web Services EC2](https://aws.amazon.com/ec2/) instance.

## Preparation

1. Create an instance from the AWS AMI Canonical, Ubuntu, 18.04 LTS, amd64 bionic image build on 2019-10-02
  * the OTMT has high memory requirements for installation, we used a t2.xlarge when preparing these tutorials
  * web archive collections take up a lot of space when downloaded, thus we ensured that our t2.xlarge had 16 GB of storage
  * if you want to access MementoEmbed from outside of the AWS container, you will need to allow port 5550 inbound in your EC2 security group and apply that group to the EC2 instance you create
2. Log into the AWS instance via SSH
3. Type the following:
```
  sudo apt-get update
  sudo apt-get install -y python3 git python3-pip redis-server build-essential nodejs libx11-xcb1 libxtst6 libnss3 libasound2 libatk-bridge2.0-0 libgtk-3-0 npm libxss1 libxml2-dev libxslt-dev python-dev lib32z1-dev
```
4. One of the Ubuntu Python packages has a conflict with the dependency installed via pip, so we remove the Ubuntu version
```
sudo apt-get remove python3-cryptography
```

## Installing the Off-Topic Memento Toolkit

5. Install the Off-Topic Memento Toolkit:
```
sudo pip3 install otmt
```
  * This will be fast on a t2.xlarge
  * This will lock up a t2.micro because the third-party `lxml` and `nltk` libraries need a lot of memory to install
  
## Installing MementoEmbed
 
6. Create the necessary directories for MementoEmbed:
```
sudo mkdir -p /app /app/logs /app/thumbnails /app/imagereels
```

7. Set permissions appropriately
```
sudo chown ubuntu:ubuntu /app
```

8. Install additional software needed for running MementoEmbed as a service
```
sudo pip3 install waitress
```

9. Install Puppeteer so that MementoEmbed can create thumbnails
```
sudo npm install puppeteer 
```

10. Install the latest version of MementoEmbed
```
git clone https://github.com/oduwsdl/MementoEmbed.git /app/MementoEmbed 
```

11. Install requirements for thumbnail work
```
cp /app/MementoEmbed/package-lock.json /app
cd /app
sudo npm install
```

12. Install Python requirements

```
cd /app/MementoEmbed
sudo pip3 install -r requirements.txt
sudo pip3 install .
```

13. Install the MementoEmbed configuration file
```
sudo cp /app/MementoEmbed/sample_appconfig.cfg /etc/mementoembed.cfg
```

14. Update the configuration for the AWS environment

```
sudo sed -i 's?DEFAULT_IMAGE_PATH = "mementoembed/static/images/96px-Sphere_wireframe.svg.png"?DEFAULT_IMAGE_PATH = "/app/MementoEmbed/mementoembed/static/images/96px-Sphere_wireframe.svg.png"?g' /etc/mementoembed.cfg

sudo sed -i 's?THUMBNAIL_SCRIPT_PATH = "mementoembed/static/js/create_screenshot.js"?THUMBNAIL_SCRIPT_PATH = "/app/MementoEmbed/mementoembed/static/js/create_screenshot.js"?g' /etc/mementoembed.cfg
```

15. Install the systemd configuration for MementoEmbed so that it starts when the computer is booted. Create a new file in your favorite editor named /etc/systemd/system/mementoembed.service and add the following content:

```
[Unit]
Description=MementoEmbed

[Service]
ExecStart=/app/MementoEmbed/dockerstart.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

16. Fix the permissions on the systemd configuration for MementoEmbed:
```
sudo chmod 0644 /etc/systemd/system/mementoembed.service
```

17. Start MementoEmbed
```
sudo systemctl enable mementoembed.service
sudo systemctl start mementoembed.service
```

## Installing Raintale

## Raintale Install

18. Install the latest version of raintale
```
git clone https://github.com/oduwsdl/raintale.git /app/raintale
```

19. Install Python requirements
```
cd /app/raintale
sudo pip3 install .
```

Now you are ready to find representative mementos and generate stories.
