# Description

I was tired of having to configure manually the disposition of my monitors when I plugged them in.

So I decided to write this script that define custom behaviour when monitor are plugged in

You might want to adapt the script to your needs ./usr/local/bin/monitor-hotplug.sh

I was inspired by http://stackoverflow.com/questions/5469828/how-to-create-a-callback-for-monitor-plugged-on-an-intel-graphics

## Installation
  ```
  git clone https://github.com/codingtony/udev-monitor-hotplug.git
  sudo chmod +x ./install.sh
  sudo ./install.sh
  ```

## Debuging
  ```
  sudo journalctl -f
  ```

  OR

  ```
  sudo service udev stop
  sudo udevd --debug 2>&1 | tee /tmp/udev.log
  check what's happening when you plug/unplug your monitor
  ```

## License

I'm not responsible of the effect of this script on your computer

Feel free to do whatever you want with it :-)
