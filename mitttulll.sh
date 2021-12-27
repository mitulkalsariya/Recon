#!/bin/bash
echo "
  /---\/---\/---\  -   |     |     |    |   | |  |  |
  |   |    |    |  | --|-- --|-- --|--  |   | |  |  |
      |    |    |  |   |     |     |    |___| |  |  |....>V.1.0
                                        
"

help(){
  echo "
Usage: ./mitttulll.sh [options] -d domain.com
Options:
    -h            Display this help message.
    -k            Run Knockpy on the domain.
    -n            Run Nmap on all subdomains found.
    -p            Run Photon crawler on all subdomains found.
    -w            Run waybackurls on all subdomain found.

  Target:
    -d            Specify the domain to scan.

Example:
    ./mitttulll.sh -d example.com
"
}

POSITIONAL=()

if [[ "$*" != *"-d"* ]]
then
	help
  exit
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    help
    exit
    ;;
    -d|--domain)
    d="$2"
    shift
    shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "Starting SubEnum $d"

echo "Creating directory"
set -e
if [ ! -d $PWD/mitttulll ]; then
	mkdir mitttulll
fi
if [ ! -d $PWD/mitttulll/$d ]; then
	mkdir mitttulll/$d
fi
source tokens.txt

echo "Starting our subdomain enumeration force..."


if [[ "$*" = *"-k"* ]]
then
	echo "Starting KnockPy"
	mkdir mitttulll/$d/knock
	cd mitttulll/$d/knock; python ../../../knock/knockpy/knockpy.py "$d" -j; cd ../../..
fi
echo " starting subfinder"
./subfinder -d $d -o mitttulll/$d/fromsubfinder.txt -v --exclude-sources dnsdumpster

echo "starting assetfinder"
./assetfinder --subs-only $d > mitttulll/$d/fromassetfinder.txt

echo "starting sublist3r"
python3 Sublist3r/sublist3r.py -d "$d" -o mitttulll/$d/fromsublister.txt

echo "starting Amass"
amass enum --passive -d $d -o mitttulll/$d/fromamass.txt

echo "starting aquatone-discover"
aquatone-discover -d $d --disable-collectors dictionary -t 300
rm -rf amass_output
cat ~/aquatone/$d/hosts.txt | cut -f 1 -d ',' | sort -u >> mitttulll/$d/fromaquadiscover.txt
rm -rf ~/aquatone/$d/

echo "starting findomain"
export findomain_fb_token="$findomain_fb_token"
export findomain_spyse_token="$findomain_spyse_token"
export findomain_virustotal_token="$findomain_virustotal_token"

./findomain -t $d -r -u mitttulll/$d/fromfindomain.txt

fi
cat mitttulll/$d/*.txt | grep $d | grep -v '*' | sort -u  >> mitttulll/$d/alltogether.txt

echo "Deleting other(older) results"
rm -rf mitttulll/$d/from*


echo "Appending http/s to hosts"
for i in $(cat EchoPwn/$d/$d.txt); do echo "http://$i" && echo "https://$i"; done >> EchoPwn/$d/with-protocol-domains.txt
cat EchoPwn/$d/$d.txt | ~/go/bin/httprobe | tee -a EchoPwn/$d/alive.txt


if [[ "$*" = *"-n"* ]]
then
echo "Starting Nmap"
  if [ ! -d $PWD/mitttulll/$d/nmap ]; then
  	mkdir mitttulll/$d/nmap
  fi
	for i in $(cat mitttulll/$d/$d.txt); do nmap -sC -sV $i -o mitttulll/$d/nmap/$i.txt; done

#echo "Notifying you on slack"
#curl -X POST -H 'Content-type: application/json' --data '{"text":"EchoPwn finished scanning: '$d'"}' $slack_url

echo "Finished successfully."
