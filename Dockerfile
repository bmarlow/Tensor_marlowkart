FROM quay.io/bmarlow/brandon-tensorflow:latest

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

RUN mkdir /root/tensor/downloads
RUN chmod 777 /root/tensor/downloads
RUN mkdir /root/tensor/results
RUN chmod 777 /root/tensor/results
RUN mkdir /root/tensor/processing
RUN chmod 777 /root/tensor/processing
RUN mkdir /root/tensor/processed
RUN chmod 777 /root/tensor/processed

RUN apt-get -y install vim

RUN wget https://www.dropbox.com/s/x0orqhrfihf6hsz/x.npy?dl=0 -O /root/tensor/data/X.npy --quiet
RUN wget https://www.dropbox.com/s/w7ckfpjac9ckkuw/y.npy?dl=0 -O /root/tensor/data/y.npy --quiet



CMD python3 -u /root/flask/main.py
