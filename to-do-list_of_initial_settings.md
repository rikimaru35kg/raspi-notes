**ラズパイOSを初期化した際にやるべきことを記載しておく。偶にしかやらず、毎回忘れるので・・・**

# SDカードにOSイメージを焼く
Webページ見ながら焼けば難しい事はない

# ラズパイ起動 & VNC初期設定
- IPアドレス固定（GUIから固定するとstatic ip_addressがinformになったりしてうまくいかない場合があるので、CUI推奨。やり方は[こちらのページ](https://qiita.com/Antareskkudo/items/782e4e94b8d04d95645d)などを参照）
- VNC接続を許可。これがないと後の作業が面倒
- /boot/config.txtの編集。hdmi系の設定をしておかないと、rebootしてディスプレイを電源投入後につないだ時に画面が写らないので忘れずに
- 以降はVNC接続してリモート操作する

# SSHの設定
- PC側からSSH接続できると何かと便利
- ssh-keygenで鍵を作り、公開鍵をraspiの~/.ssh/配下に置く
- 正確には、公開鍵の中身をauthorized_keysにコピペする
- PC側の~/.ssh/configファイルに設定を書いておけば、ssh raspiなどと打つだけでログイン可能になる

# 入力系の設定
- ibus-mozをインストール、再起動後、設定からJapanese-Mozcを加える（他のアプリの方が良いという噂もある）
- vim-tinyとvim-***をpurgeして、vimをインストール。参考に、適当に設定した.vimrcは本プロジェクトにも入れてある

# sambaの設定
- 本プロジェクトのmy_sambaを見ながら設定すれば、特に難しい事はないと思う
- まずはsambaサーバとするHDDを接続
- その後、/etc/samba/smb.confを設定
- PCやスマホからanonymousと特定ユーザーからの接続テストをする

# rsyncの設定
- 本プロジェクトのmy_crontabを見ながら設定すれば、特に難しい事はないと思う
- crontab -eでスケジュールを設定
- 実行ファイルは分けておいた方が管理しやすい
- 次の日、きちんと実行されていたかどうかチェックした方が良い

# Open VPNの設定
- Open VPNを使うと、外部からでもローカルネットワークにつないだようにしてくれる。これを使うと外部からsambaサーバにアクセス可能
- ngrokも使うならこちらのサイトも事前に見ておく事 [ルータの設定を変更できない環境でVPNを構築する方法](https://contentsviewer.work/Master/Network/SetupVPNWithoutRouterSettings)
- 解説としてはこちらの動画が神 [PiVPN : How to Run a VPN Server on a $35 Raspberry Pi!](https://www.youtube.com/watch?v=15VjDVCISj0)
- ただし、結構古いので設定画面が結構違う
- ホームルーターでポートフォワードできる場合はOpen VPNの設定だけでOKだが、マンションなどでできない場合は次のngrok設定が必要になる（実際はいずれの場合でもngrok使った方が楽という話はある・・・）
- 特に注意すべきは、UDPでくTCPを選ぶ事と、DNSサービスはないので、Public IPを選ぶ事（固定Public IPは所有していないが、どのみちngrokでremote IPというかアドレスを設定しなおすのでこれでOK）
- イメージとしては、ngrokが公開アドレス＆ポートを設定してくれて、それをopenvpnの設定ポート（TCPなら443）につないでくれる
- openvpnのユーザー設定ファイルでは、remote行にngrokのアドレス＆ポートを記載する。（ngrokは443で待ち受けていて、ngrokが443につなぐ。openvpn側でも設定ファイルに記載のアドレスからしか受け付けないという仕組み）

# ngrokの設定
- 超単純なはずのここが実は最難関だった・・・（最新バージョンだとなぜかエラーがでる）
- [ngrok releases](https://dl.equinox.io/ngrok/ngrok/stable/archive)のversion2.2.8のARM64の.TAR.GZをダウンロードしてラズパイに送ってあげる
- 解凍してできたngrokディレクトリを/usr/local/bin/にコピーして終わり（参考サイト: [【Raspberry Pi】ngrokのインストールからローカル環境の公開まで](https://qiita.com/sunaga70/items/6821772a9bcbdbbc2c03)）
- ngrokにはGoogleアカウント（35kg）でログインする。authtokenをコピーして、`ngrok authtoken [authtoken]`でymlファイルに書き込む。ymlファイルは、今回は~/.ngrok2/の下にあった。最新バージョンだと.configの下にあるので要注意
- できたymlファイルに複数トンネルの情報を書き込み、`ngrok start --all`で全トンネルをスタートできる
- 最後に、openvpnの設定ファイルにngrokのtcpアドレスとポート番号を記載してあげるのを忘れずに
- 参考に、ymlファイルを本プロジェクトにも載せておく

# mjpg-streamer
- こちらのサイトが神がかってわかりやすい [Raspberry PiでMJPG-Streamerを使って監視カメラを作ってみよう](https://ponkichi.blog/mjpg-streamer/#st-toc-h-3)
- 今回は設定でハマる事はなかったが、詳しく記載があるので、何かと役に立ちそう
- 自分で苦しんで発見したopencvとmjpg-streamerの共有方法も載っている

# gitの設定
- gitのuser名やメールアドレスなどは消えているはずなので再度登録
- githubへの公開鍵再登録も必要になる
- これらはgitを使おうとした際に自然と必要になるので、慌ててやる必要はない

# その他
- PC側のvscodeからSSH接続して作業すると色々捗る
