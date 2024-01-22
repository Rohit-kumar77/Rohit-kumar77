from nvcr.io/nvidia/tensorrt:19.10-py3
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y build-essential checkinstall cmake pkg-config yasm git gfortran libjpeg8-dev libpng-dev software-properties-common libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2-dev libv4l-dev libgtk2.0-dev libtbb-dev qt5-default libatlas-base-dev libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev libavresample-dev x264 v4l-utils libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen gcc libtinfo-dev zlib1g-dev build-essential cmake libedit-dev libxml2-dev g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev vim git htop libjsoncpp-dev openjdk-8-jdk-headless

RUN apt-get update && \
    apt-get install -y libssl1.0.0 libgstreamer1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav libgstrtspserver-1.0-0 libjansson4 libgstrtspserver-1.0-0 libgstreamer-plugins-base1.0-dev libgstrtspserver-1.0-dev libboost-all-dev openssl libssl-dev net-tools

RUN python3 -m pip --version
RUN python3 -m pip install cython==0.29.15
RUN python3 -m pip install cherryPy==18.6.0
#RUN python3 -m pip install dlib==19.19.0
RUN python3 -m pip install image-quality==1.2.3
RUN python3 -m pip install imutils==0.5.3
RUN python3 -m pip install jsonpickle==1.2
RUN python3 -m pip install onnx==1.4.0
RUN python3 -m pip install onnxruntime-gpu==1.1.2
RUN python3 -m pip install pika==1.1.0
RUN python3 -m pip install pillow==7.1.2
RUN python3 -m pip install pycuda==2019.1.2
RUN python3 -m pip install scikit-image==0.15.0
RUN python3 -m pip install scikit-learn==0.21.3
RUN python3 -m pip install scipy==1.3.2
RUN python3 -m pip install simplejson==3.13.2
RUN python3 -m pip install sqlitedict==1.6.0
RUN python3 -m pip install mxnet-cu101
RUN python3 -m pip install opencv-python==4.1.2.30
RUN python3 -m pip install easydict==1.9
RUN python3 -m pip install matplotlib==2.2.4
RUN python3 -m pip install scikit-image==0.15
RUN python3 -m pip install faiss-cpu==1.6.1
RUN python3 -m pip install requests==2.22.0

RUN mkdir /opt/softwares/
COPY llvm-10.zip /opt/softwares/
COPY tvm_i.zip /opt/softwares/
RUN cd /opt/softwares && unzip llvm-10.zip
RUN cd /opt/softwares && unzip tvm_i.zip
COPY project.zip /opt/
RUN cd /opt/ && unzip project.zip

RUN python3 -m pip install numpy==1.17.2
RUN python3 -m pip install attrs==20.3.0
RUN python3 -m pip install decorator==4.4.2
RUN python3 -m pip install tornado==6.1
RUN python3 -m pip install psutil==5.8.0
RUN python3 -m pip install xgboost==1.3.3
RUN python3 -m pip install cloudpickle==1.6.0
RUN python3 -m pip install PyMuPDF==1.18.6

RUN cd /opt/softwares/tvm/python/ && python3 setup.py install 
WORKDIR /opt/_project/code/
EXPOSE 8888
#ENTRYPOINT ["nohup","python3","server.py"]
#ENTRYPOINT ["nohup","python3","server.py","&"]
ENTRYPOINT ["/opt/project/code/run.sh"]

