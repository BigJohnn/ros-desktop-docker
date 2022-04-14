
# ROS Desktop on Docker
![Screenshot](/docs/screenshot.png)
1. Download and install [Docker](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows)
2. Download and install [docker-compose](https://docs.docker.com/compose/install/#install-compose)
3. Clone this repository using 
   ```
   git clone https://github.com/syanyong/ros-desktop-docker.git
   ```
4. docker-compose up
   ```
   cd ros-desktop-docker
   docker-compose up
   ```
5. Open webbrowser with URL localhost:6080
6. assign && source bash
   ```
   export ROS_MASTER_URI=http://172.17.0.2:11311
   export ROS_HOSTNAME=172.17.0.2 #这个是docker container's ip
   source /root/carto_ws/install_isolated/setup.bash
   source /root/mnpp_ws/devel/setup.bash
   export QT_DEBUG_PLUGINS=1
   export DISPLAY=:1 #使用了VNC， host机器上使用http://localhost:6080/访问
   ```
# Reference
- [Ubuntu VNC](https://github.com/fcwu/docker-ubuntu-vnc-desktop)


