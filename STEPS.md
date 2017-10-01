

1. Choose domain to attack
2. Create folder in `targets`
3. Create symlink called `target` in root to `targets/<domain>`
4. Use enum-domains tool:
    * ./enumall.py <domain> -a
    * Takes at least 8 hours to run
5. Transform results in pruner
    * Run `./prune`
      * generates domains.txt & ips.txt
    * Run `./resolve`
      * uses domains.txt to append to ips.txt list
    * Run `./ip_prune`
      * removes reserved domains & other non-attackable targets
    * Run `./expander`
      * Looks at ip addresses in list and expands to other spaces
      * Can run ip_prune again but likely won't turn up anything
    * Run `./redirect_prune`
      * Removes redirect domains for redirection path
    * TODO:
      * Bucket into forbidden ??
      * Checks SNI for unique domains and eliminates redirect domains
6. Use nmap-domains tool:
  * Don't dump:
    * Timeouts
    * All 65535 scanned ports on 166.78.192.71 are filtered
    * All 1000 scanned ports on 59.19.2fa9.ip4.static.sl-reverse.com (169.47.25.89) are filtered
    * Anything with mail in it?
    * Filter out traceroute?
7. Review nmap:
  * Search for `https?://` remove https://nmap.org, http://eclipse.org,
  * Search for http-title: add 400s, 500s to a list
  * Redirects: `grep http-title nmap.txt | grep redirect > redirects.txt`
  * Search for open ports
  * Distill down to a list of domains / interesting points to hit


