## ngrokが接続できないエラーの解決方法
- 次のようなエラーが出て接続できない（Session Status  reconnecting (failed to dial ngrok server with address "connect.ngrok-agent.com:443": dial tcp: lookup connect.ngrok-agent.com on 1...）
- [こちらの掲示板を参照](https://github.com/inconshreveable/ngrok/issues/611#issuecomment-1182939695)して解決した
- /etc/resolv.confのnameserverは、DNS名前解決をする為のIPアドレスを指定するので、こちらでデフォルトゲートウェイだけでなく8.8.8.8（google public DNS）も指定しておくとngrokのサーバーにたどり着ける模様
- デフォルトゲートウェイでは名前解決できないという事か？（ngrokのバージョンが低ければ問題なかった為、ngrok固有の問題？？）
- なお、resolv.confは自動生成され、勝手に上書きされてしまう事がある。[こちらのページ](https://zenn.dev/restartr/articles/ff47d85da0a3f9)を参考に/etc/resolvconf.confを変更すると良い（かもしれない）

## nohupでバックグラウンド実行したい場合
- `nohup ngrok start --all > ngrok_nohup.out &`で可能
- curl http://localhost:4040/api/tunnelsでアドレスを調べる事が可能

