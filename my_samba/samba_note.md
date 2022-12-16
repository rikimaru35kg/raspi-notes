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

## 社内NWなど、認証なし接続が許可されていない場合
`workgroup`を念のためWindows側に合わせた上で、
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


