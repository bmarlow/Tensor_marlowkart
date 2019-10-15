FROM nvidia/cuda:latest

#add my files
ADD reqs.txt /root
RUN mkdir /root/tensor
ADD tensor/play.py /root/tensor/
ADD tensor/record.py /root/tensor/
ADD tensor/train.py /root/tensor/
ADD tensor/utils.py /root/tensor/
RUN mkdir /root/uploads/
RUN chmod 777 /root/uploads
RUN mkdir /root/flask
ADD flask/app.py root/flask/
ADD flask/main.py root/flask/
RUN mkdir /root/tensor/data
RUN chmod -R 777 /root/tensor

RUN mkdir /root/downloads
RUN chmod 777 /root/downloads
RUN mkdir /root/results
RUN chmod 777 /root/results
RUN mkdir /root/processing
RUN chmod 777 /root/processing
RUN mkdir /root/processed
RUN chmod 777 /root/processed

#used to avoid interactive tzdata config
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

#install pre-reqs
RUN apt-get update
RUN apt-get install -y pkg-config libfreetype6-dev libpng-dev gcc g++ wget dkms make python3 python3-dev python3-tk python3-pip

#RUN yum -y install freetype-devel libpng gcc gcc-c++ wget epel-release dkms grub2 make centos-release-scl python3 python3-devel python3-tkinter shutil
#RUN yum -y groupinstall 'Development Tools'


#install python pre-reqs
RUN pip3 install --upgrade pip
RUN pip3 install numpy flask kafka app requests
RUN pip3 install -r /root/reqs.txt




#install cuda 10.0 libs
#RUN wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux -O /root/cuda_10.0.130_410.48_linux --quiet
#RUN sh /root/cuda_10.0.130_410.48_linux --silent --toolkit --toolkitpath=/usr/local/cuda-10.0

#Get cudnn libs from NVIDIA
#RUN wget https://www.dropbox.com/s/l5t159ily3m10sg/cudnn-10.0-linux-x64-v7.6.4.38.tgz?dl=0 -O /root/cudnn-10.0-linux-x64-v7.6.4.38.tgz --quiet
#RUN tar -C /usr/local/ -xzf /root/cudnn-10.0-linux-x64-v7.6.4.38.tgz



RUN mkdir /root/tensor/data
RUN wget https://www.dropbox.com/s/x0orqhrfihf6hsz/x.npy?dl=0 -O /root/tensor/data/X.npy --quiet
RUN wget https://www.dropbox.com/s/w7ckfpjac9ckkuw/y.npy?dl=0 -O /root/tensor/data/y.npy --quiet



CMD python3 -u /root/flask/main.py
