FROM nvcr.io/nvidia/l4t-base:r32.2

############################ USER ###############################
# setup environment
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash \
    USER=argduckiepond \
    NB_UID=1000 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV HOME=/home/${USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${USER}

RUN echo "root:root" | chpasswd
RUN echo "${USER}:111111" | chpasswd


############################################# install bootstrap tools #############################################
RUN apt-get update && apt-get install --no-install-recommends -y \
    libusb-1.0 \
    gtk+-3.0 \
    build-essential \
    make \
    cmake \
    g++ \
    tzdata \
    dirmngr \
    lsb-release \
    gnupg2 \
    libpcap-dev \
    libglfw3-dev \
    python3-pip \
    python3-opencv  \
    python3-scipy   \
    python-vcstools \
    python-scipy \
    python-gobject \
    python-gtk2 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libfltk1.3-dev \ 
    freeglut3-dev \ 
    libpng-dev \ 
    libjpeg-dev \
    libxft-dev \ 
    libxinerama-dev \ 
    libtiff5-dev \ 
    netbase \ 
    fluid \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

######################################### ROS ##################################################################
# setup keys and source.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y \ 
    ros-${ROS_DISTRO}-desktop-full \
    ros-$ROS_DISTRO-serial \
    ros-$ROS_DISTRO-soem \
    ros-$ROS_DISTRO-openslam-gmapping \
    ros-$ROS_DISTRO-geodesy \
    ros-$ROS_DISTRO-cartographer-* \
    ros-$ROS_DISTRO-ddynamic-reconfigure \
    ros-$ROS_DISTRO-perception \
    ros-$ROS_DISTRO-rgbd-launch \
    ros-$ROS_DISTRO-joystick-drivers \
    ros-$ROS_DISTRO-pointcloud-to-laserscan \
    ros-$ROS_DISTRO-robot-localization \
    ros-$ROS_DISTRO-spacenav-node \
    ros-$ROS_DISTRO-tf2-sensor-msgs \
    ros-$ROS_DISTRO-controller-manager \
    ros-$ROS_DISTRO-twist-mux \
    ros-$ROS_DISTRO-velodyne-simulator \
    ros-$ROS_DISTRO-gazebo-ros \
    ros-$ROS_DISTRO-move-base-msgs \
    ros-$ROS_DISTRO-lms1xx \
    ros-$ROS_DISTRO-rviz-imu-plugin \
    ros-$ROS_DISTRO-interactive-marker-twist-server \
    ros-$ROS_DISTRO-teleop-twist-joy \
    ros-$ROS_DISTRO-rosserial-arduino \
    ros-$ROS_DISTRO-rosserial \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

##################################### PIP ######################################

RUN pip3 install --upgrade pip setuptools

RUN pip3 install \
    numpy \
    rospkg \
    catkin-tools\
    cython \
    pandas \
    image \
    Pillow \
    pandas \
    pypozyx \
    empy \
    gdown 


#################################### Pytorch ####################################
WORKDIR /tmp
RUN wget https://nvidia.box.com/shared/static/phqe92v26cbhqjohwtvxorrwnmrnfx1o.whl -O \
    torch-1.4.0-cp36-cp36m-linux_aarch64.whl \
    && pip3 install torch-1.4.0-cp36-cp36m-linux_aarch64.whl torchvision \
    && rm -rf  torch-1.4.0-cp36-cp36m-linux_aarch64.whl 


######################################## MOOS ########################################

# INSTALLING MOOS-IVP
WORKDIR ${HOME}
RUN svn co --trust-server-cert --non-interactive https://oceanai.mit.edu/svn/moos-ivp-aro/trunk/ moos-ivp\
    && cd moos-ivp\
    && svn update --trust-server-cert --non-interactive

WORKDIR ${HOME}/moos-ivp
RUN ./build.sh


##################################### setting #####################################

RUN chown -R ${USER}:${USER} ${HOME}/
RUN echo "${USER} ALL=(ALL)  ALL" > /etc/sudoers

# Support of nvidia-docker 2.0
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all

# setup entrypoint
COPY ./ros_entrypoint.sh /
RUN chmod 777 /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]

USER ${USER}

WORKDIR ${HOME}
CMD ["bash"]
