# Linux側の話

## /mntにマウントしてある場合
/media/piなど、ユーザー専用マウントの場合は`force user = pi`で問題ないが、/mntにマウントしている場合は、記載法が異なる為、ここに示しておく。
```
[share]
   path = /mnt/hdd1/share
   writable = yes
   guest ok = yes
   browseable = yes
   create mode = 0777
   directory mode = 0777
```
なお、NETBIOSを使用する場合は以下のように書く。
```
   wins server = [IP address]
   wins proxy = yes
   netbios name = [使用したい名前]
```

## ログを取りたい場合
ログを取りたいフォルダの設定のところで、
以下を追加する
```
   vfs objects = full audit
   full_audit:facility = local1
   full_audit:prefix = %u|%m|%I|%S
   full_audit:failure = connect
   full_audit:success = connect disconnect mkdir rmdir pwrite rename unlink
```
忘れずにbashでsmbdとnmbdを再起動する。
```
sudo systemctl restart smbd
sudo systemctl restart nmbd
```

更に/etc/rsyslog.confに以下を追加することで、local1の書き込みファイルを/var/log/samba/audit.logに設定することができる。
```
local1.* /var/log/samba/audit.log
local1.none;\
```
最後にbashで次のコマンドを打つと、ログが開始される。
```
/etc/init.d/rsyslog restart
```

## 社内NWなど、認証なし接続が許可されていない場合
workgroupの名前を念のためWindows側に合わせた上で、
```
#   map to guest = bad user
```
とコメントアウトし、
```
   ntlm auth = yes
```
を追加する。理由は分かっていないが、これで接続できる時がある。

## その他注意点
sambaでユーザーを登録するには、事前にlinux側にもユーザー登録が必要

`pdbedit -a`でsambaユーザーを追加

globalで`browsable = no`にしておかないと
ユーザーフォルダまで共有フォルダとして見えてしまうので注意。各共有ディレクトリで`browsable = yes`とする。

globalでincludeしたものだけ別設定にすることが可能
（あるユーザーにはフォルダを見せる事すらしたくない場合）
（アクセスできなかったとしても存在すら見せたくないとかあるので）


# Windows側の話
```
net use "\\192.168.1.99" /user:ryo ryo
```
で明示的にユーザーを指定してアクセス可能。

cmdで
`net use`で確認した後
```
net use <name> /delete
```
して
klist purge
で明示ユーザーを消去可能。


