FROM tensorflow/tensorflow:latest-gpu
#FROM nvidia/cuda:latest

#add my files
ADD reqs.txt /root
RUN chmod 777 /root/
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
RUN chmod -R 777 /root/flask

RUN mkdir /root/tensor/downloads
RUN chmod 777 /root/tensor/downloads
RUN mkdir /root/tensor/results
RUN chmod 777 /root/tensor/results
RUN mkdir /root/tensor/processing
RUN chmod 777 /root/tensor/processing
RUN mkdir /root/tensor/processed
RUN chmod 777 /root/tensor/processed

#used to avoid interactive tzdata config
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

#install pre-reqs
RUN apt-get update
RUN apt-get install -y pkg-config libfreetype6-dev libpng-dev gcc g++ wget dkms make python3 python3-dev python3-tk python3-pip vim



#install python pre-reqs
RUN pip3 install --upgrade pip
RUN pip3 install numpy flask kafka app requests
RUN pip3 install -r /root/reqs.txt


RUN wget https://www.dropbox.com/s/x0orqhrfihf6hsz/x.npy?dl=0 -O /root/tensor/data/X.npy --quiet
RUN wget https://www.dropbox.com/s/w7ckfpjac9ckkuw/y.npy?dl=0 -O /root/tensor/data/y.npy --quiet



CMD python3 -u /root/flask/main.py
