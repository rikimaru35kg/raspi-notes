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

## 一般ユーザーにsambaパスワード変更を許可したい場合
一般ユーザーでもsmbpasswdでパスワード変更できるはずだが、/etc/samba/smb.confで
```
   unix password sync = yes
```
となっている場合は、unixのパスワードも同時に変更しようとする。
しかしながら、NISパスワードの変更時にエラーが起きて失敗してしまうので、上記設定をnoに変更しておけば良い。
（NISパスワードが何者か、良く分かっていない・・・）

## その他注意点
sambaでユーザーを登録するには、事前にlinux側にもユーザー登録が必要

`pdbedit -a`でsambaユーザーを追加

globalで`browsable = no`にしておかないと
ユーザーフォルダまで共有フォルダとして見えてしまうので注意。各共有ディレクトリで`browseable = yes`とする。
綴り注意！

globalでincludeしたものだけ別設定にすることが可能
（あるユーザーにはフォルダを見せる事すらしたくない場合）
（アクセスできなかったとしても存在すら見せたくないとかあるので）
includeする前に前述の`browseable = no`を入れておかないと、includeしたユーザー設定まで上書きされてしまうので注意！


# Windows側の話
```
net use \\192.168.1.127 /user:[user name] [password]
```
で明示的にユーザーを指定してアクセス可能。
ただし、git bashから打つと失敗するので、コマンドプロンプトから打つ事。

cmdで
`net use`で確認した後
```
net use <name> /delete
```
して
klist purge
で明示ユーザーを消去可能。


