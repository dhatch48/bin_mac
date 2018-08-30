#!/usr/bin/env python3

import os
import random
import re
import time
import argparse
from selenium import webdriver
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import ElementNotInteractableException
from selenium.common.exceptions import ElementNotVisibleException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver import ActionChains
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.firefox_binary import FirefoxBinary


# Check for argument and set iteration amount
parser = argparse.ArgumentParser()
parser.add_argument('t', metavar='N', type=int, nargs='?', default=40, help='An int for the number of searches to try')
parser.add_argument('-s', '--search', help='A string to use for the current search term')
args = parser.parse_args()
t = args.t

def slowtype(myelement, mysearchTermring):
    for c in mysearchTermring:
        myelement.send_keys(c)
        time.sleep(random.randint(1, 5)*.03)

def fp_proxy(PROXY_HOsearchTerm,PROXY_PORT,USER_AGENT):
    fp = webdriver.FirefoxProfile()
    # Direct = 0, Manual = 1, PAC = 2, AUTODETECT = 4, SYsearchTermEM = 5
    print(PROXY_HOsearchTerm)
    fp.set_preference("network.proxy.type", 1)
    fp.set_preference("network.proxy.http",PROXY_HOsearchTerm)
    fp.set_preference("network.proxy.http_port",int(PROXY_PORT))
    fp.set_preference("network.proxy.ssl",PROXY_HOsearchTerm)
    fp.set_preference("network.proxy.ssl_port",int(PROXY_PORT))
    fp.set_preference("network.proxy.ftp",PROXY_HOsearchTerm)
    fp.set_preference("network.proxy.ftp_port",int(PROXY_PORT))
    fp.set_preference("network.proxy.socks",PROXY_HOsearchTerm)
    fp.set_preference("network.proxy.socks_port",int(PROXY_PORT))
    fp.set_preference("general.useragent.override", USER_AGENT)
    fp.update_preferences()
    return fp

def random_index(arr):
    if len(arr) > 1:
        return random.randrange(0,(len(arr)-1))
    else:
        return 0

# Get searchTerm from wordlist
if args.search:
    searchTerm = args.search
else:
    wordlist = os.path.realpath(os.path.expanduser('~')+'/bin/tech_wordlist.txt')
    with open(wordlist) as fp:
        for i, line in enumerate(fp):
            if i == 0:
                wordIndex = int(line.strip())
            elif i == wordIndex-1:
                searchTerm = line.strip()
                break

relatedRightSelector = '.b_ans .b_rrsr a[href]'
relatedBottomSelector = '.b_ans .b_rich a[href]'
relatedAllSelector = '.b_ans a[href^="/search?"]'

### Browser Setup
myHosearchTerm = "185.218.151.148"  # 198.55.110.178, 198.55.110.133
myProxyPort = 8800
useragent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0"
# useragent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:58.0) Gecko/20100101 Firefox/58.0"

# fp = webdriver.FirefoxProfile()
# fp = fp_proxy(myHosearchTerm,myProxyPort,useragent)
fp="/Users/david/Library/Application Support/Firefox/Profiles/g78nzr07.2016-12-14"

if os.uname()[1] == 'david-pc':
    binaryPath = FirefoxBinary("C:\\Program Files\\Mozilla Firefox\\firefox.exe")
else:
    binaryPath = FirefoxBinary("/Applications/Firefox.app/Contents/MacOS/firefox")

driver = webdriver.Firefox(firefox_profile=fp, firefox_binary=binaryPath)

# Bring firefox window to foreground
driver.fullscreen_window()
driver.set_window_size(1200,900)
driver.set_window_position(1920-1200,3)
# print(driver.get_window_position())
# print(driver.get_window_size())
# print(driver.get_window_rect())

driver.get("https://www.bing.com")
WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME,"q")))
time.sleep(random.gauss(2, 0.4))

searchbox = driver.find_element(By.NAME, "q")
slowtype(searchbox, searchTerm)

searchbox.submit()
WebDriverWait(driver, 10).until(EC.title_contains(searchTerm))
print(driver.title)


while t > 0:

    time.sleep(random.gauss(5, 1))
    relatedLinks1 = driver.find_elements(By.CSS_SELECTOR, relatedRightSelector)
    relatedLinks2 = driver.find_elements(By.CSS_SELECTOR, relatedAllSelector)
    # Filter out links that aren't clickable
    relatedLinks1 = list(filter(lambda x: x.is_displayed() == True, relatedLinks1))
    relatedLinks2 = list(filter(lambda x: x.is_displayed() == True, relatedLinks2))
    relatedSearchTerm = ''
    fail = 0

    if relatedLinks1:
        i = random_index(relatedLinks1)
        element = relatedLinks1[i]
        relatedSearchTerm = element.text
        print(t, i, relatedSearchTerm, element.is_displayed(), element.location, sep=' - ')
        # ActionChains(driver).move_to_element(element).click().perform()
        element.click()

    elif relatedLinks2:
        i = random_index(relatedLinks2)
        element = relatedLinks2[i]
        relatedSearchTerm = element.text
        print(t, i, relatedSearchTerm, element.is_displayed(), element.location, sep=' - ')
        driver.execute_script('arguments[0].scrollIntoView({bahavior: "smooth", block: "start", inline: "nearest"});', element)
        time.sleep(random.gauss(2, 0.4))
        try:
            # ActionChains(driver).move_to_element(element).click().perform()
            element.click()
        except(ElementNotInteractableException, ElementNotVisibleException) as err:
            print(type(err))
            print(err)
            continue

    elif fail:
        print("Try new search term")
        print(t, "iterations left")
        break

    else:
        print("No related links found. Going back 2 pages")
        driver.back()
        time.sleep(random.gauss(2, 0.4))
        driver.back()
        fail = 1


    # WebDriverWait(driver, 10).until(EC.title_contains(relatedSearchTerm))
    t -= 1


hitenter = input("Press Enter to continue...")
driver.quit()
