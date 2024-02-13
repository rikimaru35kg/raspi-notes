## ngrokが接続できないエラーの解決方法
- 次のようなエラーが出て接続できない（Session Status  reconnecting (failed to dial ngrok server with address "connect.ngrok-agent.com:443": dial tcp: lookup connect.ngrok-agent.com on 1...）
- [こちらの掲示板を参照](https://github.com/inconshreveable/ngrok/issues/611#issuecomment-1182939695)して解決した
- /etc/resolv.confのnameserverは、DNS名前解決をする為のIPアドレスを指定するので、こちらでデフォルトゲートウェイだけでなく8.8.8.8（google public DNS）も指定しておくとngrokのサーバーにたどり着ける模様
- デフォルトゲートウェイでは名前解決できないという事か？（ngrokのバージョンが低ければ問題なかった為、ngrok固有の問題？？）

