FROM dorowu/ubuntu-desktop-lxde-vnc:bionic-arm64

COPY ./.bashrc /home/ubuntu/.bashrc
COPY ./sources.list /etc/apt/sources.list
VOLUME /home/ubuntu/ros_ws
WORKDIR /home/ubuntu/ros_ws

RUN apt update
RUN apt install dirmngr --install-recommends -y

RUN sh -c 'echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

ENV CERES_VERSION="1.12.0"
ENV CATKIN_WS=/home/ubuntu/ros_ws
ENV ROS_DISTRO=melodic
RUN mkdir -p $CATKIN_WS/src
      # set up thread number for building
RUN apt-get update && apt-get install -y \
	  git \
	  vim \
      cmake \
      libatlas-base-dev \
      libeigen3-dev \
      libgoogle-glog-dev \
      libsuitesparse-dev \
      python-catkin-tools \
      ros-${ROS_DISTRO}-rosbash \
      ros-${ROS_DISTRO}-cv-bridge \
      ros-${ROS_DISTRO}-rviz \
      ros-${ROS_DISTRO}-image-transport \
      ros-${ROS_DISTRO}-message-filters \
      ros-${ROS_DISTRO}-navigation \
      ros-${ROS_DISTRO}-tf && \
      rm -rf /var/lib/apt/lists/* && \
      # Build and install Ceres
      git clone https://ceres-solver.googlesource.com/ceres-solver && \
      cd ceres-solver && \
      git checkout tags/${CERES_VERSION} && \
      mkdir build && cd build && \
      cmake .. && \
      make -j3 install && \
      rm -rf ../../ceres-solver

RUN catkin config \
      --extend /opt/ros/$ROS_DISTRO \
      --cmake-args \
        -DCMAKE_BUILD_TYPE=Release 
RUN catkin build

RUN apt install -y ros-melodic-navigation

ENV USER=ubuntu
ENV PASSWORD=ubuntu

# authorize SSH connection with root account
RUN apt update
RUN apt install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN useradd -rm -d /home/test -s /bin/bash -g root -G sudo -u 1000 test
RUN echo 'test:test' | chpasswd
RUN sed -i '/^#/!s/PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN service ssh start
RUN echo 'root:ubuntu' | chpasswd

COPY ./supervisord-user.conf /etc/supervisor/conf.d/supervisord-user.conf

EXPOSE 80 22
