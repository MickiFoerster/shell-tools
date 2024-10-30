#!/bin/bash -x

set -ex 

cd /tmp

sudo apt update
sudo apt install python3 python3-pip python3-venv -y
python3 -m venv selenium_env
source selenium_env/bin/activate

pip install selenium webdriver-manager

# install chrome if not already there
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

cat <<EOM >test.py
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import time

# Step 1: Initialize the WebDriver and open the website
options = webdriver.ChromeOptions()
options.add_argument("--headless")  # Run in headless mode
options.add_argument("--no-sandbox")  # Recommended for running headless on Linux
options.add_argument("--disable-dev-shm-usage")  # Prevents errors on Ubuntu

# Initialize the driver with the downloaded ChromeDriver
print("initializing headless chrome browser")
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

# Set the window size to 1920x1080
driver.set_window_size(1920, 1080)

# Open the website
print("open example page ...")
driver.get("https://www.sueddeutsche.de")

# Optional: Wait for the page to load fully
print("sleeping for 5 seconds to give browser time to fully load the page ...")
time.sleep(5)
print("now, continue ...")

# Step 2: Save the Page Source
print("save page")
with open("sueddeutsche_page.html", "w", encoding="utf-8") as file:
    file.write(driver.page_source)

# Step 3: Take a Screenshot (optional)
print("save screenshot")
driver.save_screenshot("sueddeutsche_screenshot.png")

# Step 4: Close the WebDriver
print("done")
driver.quit()

EOM

python3 test.py 

# show HTML in vim 
vim sueddeutsche_page.html

# open screenshot with eog
eog sueddeutsche_screenshot.png 

set +ex 
