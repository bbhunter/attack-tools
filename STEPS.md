

1. Choose domain to attack
2. Create folder in `targets`
3. Create symlink called `target` in root to `targets/<domain>`
4. Use enum-domains tool:
    * ./enumall.py <domain> -a
    * Takes at least 8 hours to run
5. Transform results in pruner
    * Run `./prune`
      * generates domains.txt & ips.txt
    * Run `./ip_resolver`
      * uses domains.txt to append to ips.txt list
      * doesn't handle dynamic ips --> whois check on target?
      * doesn't eliminate non-<domain> targets -- whois checks?
        * anything with 10.<blah> -- reserved domains?
        * anything with "OrgName:        Internet Assigned Numbers Authority" on whois
    * Run `./domain_resolver`
      * Checks SNI for unique domains and eliminates redirect domains
6. Use nmap-domains tool:
  * TODO: Timeout flag to run: `nmap -T4 -A -v -Pn <domain>`


