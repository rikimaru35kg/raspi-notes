# USBカメラを刺したときに/dev/video*が変わってしまうのを防ぐ方法

Symbolic link（/dev/webcam -> /dev/video*）を作る事で解決可能

- `lsusb`でデバイス情報を取得（ID 045e:076dとなっていたら、045eがATTRS{idVendor}、076dがATTRS{idProduct}である）
- /etc/udev/rules.d/10-local.rulesを作成（おそらくファイル名は数字から始まれば何でもOK）
- 上記ファイルに以下を記述
```
ATTRS{idVendor}=="045e",ATTRS{idProduct}=="076d",ATTR{index}=="0",KERNEL=="video*",SYMLINK+="webcam"
```
- ATTR{index}は0で良い。1つのUSBにしか刺していないのに複数/dev/video*が作成される事があるので、0番目のvideoを指定する為のもの
