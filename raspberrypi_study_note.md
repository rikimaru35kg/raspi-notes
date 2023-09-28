# はじめに・・・

最初は英語で書いていたが途中から日本語で書いた為、読みにくい日英混合文書となってしまっている。

# Start-up programs
Put your own programs under the following directory.

/etc/rc.local

# Continue program execution after log-off
```nohup <command> &```

# Specify *.sh as bash script
Add `#! /bin/bash` at the top of the script.

こうすることで、shellスクリプトファイルであるとbashが認識してくれる。

# Boot configurations 1
Modify /boot/config.txt
```
hdmi_force_hotplug:0=1
hdmi_group=2
hdmi_mode=82  # 720pなので画面が小さいが、raspiのScreen Settingから大解像度を選んだら結局VNCでも大きくすることができた
dtoverlay=vc4-fkms-v3d
dtparam=act_led_trigger=timer
dtparam=pwr_led_triger=mmc0
gpu_mem=512
```

# Boot configuration 2
Modify /boot/cmdline.txt

If mouse motion is weird (add at the end of the line)
```
usbhid.mousepoll=0
```

# Vim settings
~./.vimrc (see Web information)

# bash settings
~./.bashrc

Important line
```
alias rm='rm -i'
```

# SD card protection

## Zero swap
no swap setting to make SD card life longer (see Web information)

## Less writing into log file
Comment out some lines of /etc/rsyslog.conf
```
###############
#### RULES ####
###############
(omit)
#auth,authpriv.*    /var/log/auth.log
(omit)
# Emergencies are sent to everybody logged in.
#
.emerg    :omusrmsg:*
```
Do not comment out the last line.

# NTP server (time synchronization)

/etc/systemd/timesyncd.confにNTPサーバのIPアドレスを記入すると時刻同期可能。

# rootユーザーのsshログイン禁止
Modify /etc/ssh/sshd_config
```
PermitRootLogin no
```

# マウント設定（HDD, USB memory, etc.）

## 起動時に自動マウント
/etc/fstabに記述をする事で、起動時にHDD等のマウントポイントを指定できる。下記はその例である。
```
LABEL=HDD1 /mnt/hdd1 ntfs defaults 0 0
```
/etc/fatabに記述後、`sudo mount -a`で反映させる事が可能。
ユーザー専用マウント（例えば/media/pi/）を避けたい場合に便利である。

## 一般ユーザーでも後からマウントできるようにしておく方法
/mnt/tmpディレクトリを作成した上で/etc/fstabに下記を記述。
```
/dev/sdc1 /mnt/tmp auto user,noauto,rw,iocharset=utf8 0 0
```
こうする事で、sdc1にUSBメモリ等を挿してから`mount /dev/sdc1`と打ち込めば、一般ユーザーでもマウントできるようになる。
なお、Windowsで使用したFAT32のUSBメモリは、ファイル名がSJISとなっている為、`iocharset=utf8`の指定が必要となる。NTFSの場合はWindowsでもUTF8である。

## Prohibit automatic mount (HDD, USB memory, etc.)

### Default設定
/etc/xdg/pcmanfm/LXDE-pi/pcmanfm.confを書き換え
```
[volumne]
mount_on_startup=1
mount_removable=1
autoran=1
```
を
```
[volumne]
mount_on_startup=0
mount_removable=0
autoran=0
```
へ変更する

### User設定
Default設定と異なるuser設定をしている場合、user設定が優先される
(GUIのファイルマネージャー->編集->設定で変更可能)

## VNC関連
RealVNCは商用利用は有償との情報あり。

TightVNCは仮想デスクトップを提供するので、複数ユーザーの同時ログインを想定する場合に便利で、しかも描画速度が速い。ただし、ウィンドウの閉じるボタンが出てこなかったりする。また、opencvの画面も表示できないとの情報あり。

x11vncは物理デスクトップそのものを操作できる為、操作には問題が生じない。ただし、描画測度は遅い。以下、x11vncのインストール方法を説明する。

```
# Install
sudo apt install x11vnc
# Set password
x11vnc -storepasswd
```

x11vncをsystemdに登録して、自動起動するには、/etc/systemd/system配下にx11vnc.serviceというファイルを作り下記を記述。
```
[Unit]
Description=X11vnc
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -loop -forever -auth guess -rfbauth /home/pi/.vnc/passwd

[Install]
WantedBy=multi-user.target
```

その後、systemdに反映させ、起動させる。
```
# Read .service file
sudo systemctl daemon-reload
# Start x11vnc service
sudo systemctl start x11vnc
# Enable auto start (after connection is confirmed)
sudo systemctl enable x11 vnc
```
デフォルトのポート番号は5900である。
