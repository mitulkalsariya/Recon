#! /bin/sh

# This Script Was Written by mitttulll

# install Script Languages

sudo apt-get install golang;
sudo apt-get install python3;
sudo apt-get install python3-pip;
sudo apt-get install python-pip;
sudo apt-get install ruby;
sudo apt-get install screen;
sudo apt-get install git;
pip install requests;
pip3 install requests;
pip install subprocess;
pip install termcolor;

************
 Tools Used
************

mkdir Tools;

cd Tools;

# Subdomain finder Tools

#install subfinder
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder;


#install findomain
wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux;
chmod +x findomain-linux;
./findomain-linux;


#install assetfinder
go get -u github.com/tomnomnom/assetfinder;


#install httpx
GO111MODULE=on go get -v github.com/projectdiscovery/httpx/cmd/httpx#3klcon/tools/


#install httprobe
go get -u github.com/tomnomnom/httprobe; 


#install waybackurls
go get github.com/tomnomnom/waybackurls; 


#install nuclei
GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei;


#install nuclei-templets
git clone https://github.com/projectdiscovery/nuclei-templates.git;

cp ~/go/bin/* /usr/local/bin; 
cd ../ ;
