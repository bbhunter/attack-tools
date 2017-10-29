A Small Set of Customized Tools for Merry Making

Install:
  [Gopass for bug bounties](https://github.com/justwatchcom/gopass)

Steps:

* Discovery / Mapping:
  * Linked Resources:
    * Find inscope domains with enum-domains
      * Try to eliminate cloudflare:
        * Use enum-domains `csv` list for non-cloudflair ips
        * historical lookup: http://toolbar.netcraft.com/site_report?url=example.com
        * dig: `dig ANY example.com`
        * get them to send an email & check headers
        * https://rhinosecuritylabs.com/cloud-security/cloudflare-bypassing-cloud-security/
        * Signup & look at email headers for ip
      * Reverse IP lookup: https://github.com/darkoperator/dnsrecon
        * haven't tried ^ yet
      * Recon in social networks:
        * Figure out tech stack and the like using job posting, people's experience, etc.
        * Reddit / github / monster / LinkedIn / indeed / etc
    * via: virustotal => `https://virustotal.com/en/domain/<domain>/information/`
      * Observed subdomains
    * via: similarweb
    * Scan subdomains for popular services / plugins
      * curl subdomain, then cat response & grep for service strings
        * eg: facebook, wordpress, surveygizmo, aws, shopify, unbounce, fastly, heroku, github, desk, tumblr
      * Save so that you can go back historically if you find vulns
      * TODO: write that tool
    * nmap scans:
      * Port scan: `nmap -sS -A -PN -p- --script=http-title example.com`
        * Alternatives: `nmap -T4 -A -v -Pn example.com`
        * `nmap-domains/scan.rb` to scan
      * Attack individual targets as available
  * Unlinked Resources:
    * `dir-buster` to brute force
      * use seclists to augment:
        * RAFT lists
        * Git digger
        * svn digger
    * Try spidering deeper:
```
acme.com - 200
acme.com/backlog/ - 404
acme.com/controlpanel/ - 401 <-- dig deeper
acme.com/controlpanel/[bruteforce here now]
```
  * Tech stack -- check for CVEs against results here:
    * Wappalyzer (chrome)
    * Builtwith (chrome)
    * [retire.js](https://retirejs.github.io/retire.js/)
  * Custom engines
    * [WPScan](https://wpscan.org/)
      * plugins are more insecure than the platform!
    * [CMSmap](https://github.com/Dionach/CMSmap)
  * OSINT:
    * Use past flaws to pivot into new flaws
      * xssed.com
      * reddit xss
      * punkspider
      * xss.cx
      * xssposed.org
      * twitter search
  * SWFs search:
    * Google dorks: `site:url.com ext:swf`
  * Login w/ Facebook connect
    * look for `redirect_uri` & open redirects
      * Links to learn, I don't understand open redirect:
        * want to get tokens / access tokens
        * http://homakov.blogspot.se/2013/02/hacking-facebook-with-oauth2-and-chrome.html 
        * http://www.breaksec.com/?p=6039 Facebook Connect
  * 3rd Party Scripts
    * look for url downloads in scripts
      * are there url query parameters used in scripts?
    * `(get)?(query|url|qs|hash)param`
    * `location\.(hash|href|search)\.match`
    * bypass Content Security Policy
      * Look at CSP domains, use those as attack vector
      * eg: `<script src="mixpanel.com?callback=alert(1)">`
* Initial Assessment
  1. Visit the search, registration, contact, password reset, and comment forms and hit them with your polyglot strings
  2. Scan those specific functions with Burp’s built-in scanner
  3. Check your cookie, log out, check cookie, log in, check cookie. Submit old cookie, see if access.
  4. Perform user enumeration checks on login, registration, and password reset.
  5. Do a reset and see if; the password comes plaintext, uses a URL based token, is predictable, can be used multiple times, or logs you in automatically
  6. Find numeric account identifiers anywhere in URLs and rotate them for context change
  7. Find the security-sensitive function(s) or files and see if vulnerable to non-auth browsing (idors), lower-auth browsing, CSRF, CSRF protection bypass, and see if they can be done over HTTP.
  8. Directory brute for top short list on SecLists
  9. Check upload functions for alternate file types that can execute code (xss or php/etc/etc)

# Attacking Services:

### FTP:

* FTP-Brute: `nmap --script=ftp* -p 21 target.com`

### SSH:

* SSH-Brute: `nmap --script=ssh* -p 22 target.com`

### SMTP:

* Enum users: `nmap –script=smtp-enum-users target.com`
* http://pentestmonkey.net/tools/user-enumeration/smtp-user-enum

### EPMD (aka rabbbitmq):

* `nmap -p 4369 --script epmd-info <target>`

# Attacking Websites

### User Enumeration / Authentication

* Try to chain attacks in auth:
  * reset password + brute force tokens
* Timing Attack: Try to register / reset password / etc
  * Time how long it takes for known success vs known failed
  * Ref: http://cwe.mitre.org/data/definitions/208

### Brute Force

* TFA backup codes
* TFA codes
* Password reset tokens

### XSS

* polyglot payloads:

```
1. <PLAINTEXT>
2. "><img src=x onerror=confirm(1);>
3. jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert()//>\x3e
4. ';alert(String.fromCharCode(88,83,83))//';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>
5. '">><marquee><img src=x onerror=confirm(1)></marquee>"></plaintext\></|\><plaintext/onmouseover=prompt(1)><script>prompt(1)</script>@gmail.com<isindex formaction=javascript:alert(/XSS/) type=submit>'-->"></script><script>alert(1)</script>"><img/id="confirm&lpar;1)"/alt="/"src="/"onerror=eval(id&%23x29;>'"><img src="http://i.imgur.com/P8mL8.jpg">
6. " onclick=alert(1)//<button ' onclick=alert(1)//> */ alert(1)//
7. javascript://'/</title></style></textarea></script>--><p" %0A onclick=alert()//>*/alert()/*
```

* 3rd party vectors:
  * facebook login, google login, etc.
* dynamic anchor tags in url: `http://example.com#<xss-here>`
* in redirects
* js embedded in swf: have parameters that can be injected
  * cure53/flashbang
* XSS'd username + password reset
* event / meeting names
* File upload names

### SQLi

* polyglots:

```
1. SLEEP(10) /*' or SLEEP(10) or '" or SLEEP(10) or "*/
```

* git:danielmiessier/SecLists -> fuzzing
* blind is most common; error based rarer
* Sqlmap is the best tool
  * Use fuzz string, then sqlmap
* Take burp logfile & run sqlmap with `-l`
  * Burp plugin: SQLiPy right click to send to sqlmap
* Common injections:
  * id, currency values, item numbers, sorting/ordering params, json & xml values, cookie values, custom headers

* Platform Specific:
  * mySQL
    * PentestMonkey's mySQL injection cheat sheet
    * Reiners mySQL injection Filter Evasion Cheatsheet
  * MSSQL
    * EvilSQL's Error/Union/Blind MSSQL Cheatsheet
    * PentestMonkey's MSSQL SQLi injection Cheat Sheet
  * ORACLE
    * PentestMonkey's Oracle SQLi Cheatsheet
  * POSTGRESQL
    * PentestMonkey's Postgres SQLi Cheatsheet
  * Others
    * Access SQLi Cheatsheet
    * PentestMonkey's Ingres SQL Injection Cheat Sheet
    * pentestmonkey's DB2 SQL Injection Cheat Sheet
    * pentestmonkey's Informix SQL Injection Cheat Sheet
    * SQLite3 Injection Cheat sheet
    * Ruby on Rails (Active Record) SQL Injection Guide

### Local File Inclusion

* Find file polyglots
* Manipulate meta-data
* To watch: http://goo.gl/VCXPh6
* git:danielmiessier/SecLists -> LFI
* common params:
  * file=, location=, locale=, path=, display=, load=, read=, retrieve=
* hard to get right for devs

### Remote File Inclusion

* Common params:
  * dest, continue, redirect, url, uri, window, next
  * file, folder, path, style, template, php_path, doc, document, root, pg, pdf
  * LFI params too
* git:danielmiessier/SecLists -> LFI

### CSRF

* Use burp!
* Bypasses:
  * remove CSRF token from request
  * remove CSRF token parameter value
  * Add bad control characters
  * use a second identical CSRF param
  * change POST to GET
* Burpy Tool (Debasish Mandal)
  * Run against a burp log file

### Privledge Escalation

* Autorize burp plugin:
  * git:quitten/autorize
* Insecure Direct Object Reference
  * UIDs: ++, --, negative values
  * Check files with/without auth

### Transport

* HTTPS everywhere
  * https://github.com/arvinddoraiswamy/mywebappscripts/tree/master/ForceSSL

# Tools to investigate

* https://intrigue.io/
