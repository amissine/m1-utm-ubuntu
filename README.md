# m1-utm-ubuntu
Ubuntu VM on a mac with M1

1. Create [Ubuntu VM](https://ubuntu.com/download/server/arm "ubuntu-20.04.2-live-server-arm64.iso") with [UTM](https://mac.getutm.app/).
2. Start the server.
3. Login to the server and set it up with
    ```bash
    sudo apt-get install sudo
    sudo echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER
    sudo chmod 0440 /etc/sudoers.d/$USER
    git clone https://github.com/amissine/m1-utm-ubuntu.git
    cd m1-utm-ubuntu; ./setup.sh
    ```

Run `cd ~/m1-utm-ubuntu; ./reset.sh` to reset the server to its original configuration.
