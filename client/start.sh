#!/bin/bash

# Check if torsocks is installed
if ! command -v torsocks &> /dev/null
then
    echo "torsocks is not installed. Please install torsocks to run this script."
    exit
fi

# Check if Python is installed
if ! command -v python3 &> /dev/null
then
    echo "Python3 is not installed. Please install Python3 to run this script."
    exit
fi

# Check if necessary Python packages are installed
python3 - << 'EOF'
import sys

required_packages = ['requests', 'colorama']
for package in required_packages:
    try:
        __import__(package)
    except ImportError:
        print(f"{package} is not installed. Please install it using 'pip install {package}'.")
        sys.exit(1)
EOF

if [ $? -ne 0 ]; then
    exit
fi

# Prompt the user for input in the Bash script
echo "Welcome to NAPO Search :)"
read -p "Enter your search query: " query

# Run the Python script using a here document and pass the query as an argument
torsocks python3 - << EOF
import sys
import requests
from colorama import init, Fore, Style

# Initialize colorama
init(autoreset=True)

def search(query):
    url = 'http://ilkoovogownr2yxc2huml3bdcmvdbwnzj443rmc2kuyxeyo4bvwlrcqd.onion/search'
    params = {'query': query}
    response = requests.get(url, params=params)
    if response.status_code == 200:
        data = response.json()
        print_advertisements(data['advertisements'])
        print_results(data['results'])
    else:
        print(Fore.RED + 'Error:', response.json()['error'])

def print_advertisements(ads):
    print(Fore.YELLOW + Style.BRIGHT + 'Advertisements:')
    for ad in ads:
        print(Fore.YELLOW + 'Title:', ad['title'])
        print(Fore.YELLOW + 'URL:', ad['url'])
        print(Fore.YELLOW + '==' * 20)

def print_results(results):
    print(Fore.CYAN + Style.BRIGHT + 'Search Results:')
    for result in results:
        print(Fore.CYAN + 'Title:', result['title'])
        print(Fore.CYAN + 'URL:', result['url'])
        print(Fore.CYAN + 'Description:', result['description'])
        print(Fore.CYAN + 'Tags:', ', '.join(result['tags']))
        print(Fore.CYAN + '==' * 20)

if __name__ == '__main__':
    query = "$query".strip()
    if not query:
        print(Fore.RED + 'No query provided')
    elif len(query) < 2:
        print(Fore.RED + 'Query is too small')
    elif len(query) > 100:
        print(Fore.RED + 'Query is too long')
    else:
        search(query)
EOF
