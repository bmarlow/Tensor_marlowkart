import os
import urllib.request, requests, subprocess
import shutil, kafka, logging, time, datetime


def main_loop():
    files = []
    print('Connected to AMQ Streams...')
    try:
        while True:
            consumer_received = kafka.KafkaConsumer('file-received', bootstrap_servers='my-cluster-kafka-bootstrap:9092', consumer_timeout_ms=10000)
            for message in consumer_received:
                str_message = bytes.decode(message.value)
                print(str_message)
                # if its stupid but it works...  well this is still stupid
                filename = str(str_message.split(': ')[1:])
                filename = filename.replace("'", '')
                filename = filename.replace('[', '')
                filename = filename.replace(']', '')
                files.append(filename)

                if len(files) == 2:
                    get_files(files)
                    files = []
    except Exception as e:
        print('Stream timed out, restarting...')
        pass


def get_files(files):
    for file in files:
        print('Retrieving file from dropoff pod(this may take a minute): ' + file)
        baseurl = "http://dropoff-marlowkart.apps.koopa.hosted.labgear.io/files/"
        url = baseurl + file
        dlpath = '/root/tensor/downloads/'
        dlpathwithfile = dlpath + file
        r = requests.get(url)
        open(dlpathwithfile, 'wb').write(r.content)

    process_training_files(files)
    pass


def process_training_files(files):
    dlpath = '/root/tensor/downloads/'
    processingpath = '/root/tensor/data/'
    for file in files:
        shutil.move(dlpath + file, processingpath + file)

    # for timestamping results file
    now = datetime.datetime.now()
    dt_string = now.strftime("%d%m%Y-%H%M%S")

    # issue ML commands
    subprocess.run('/root/tensor/train.py', shell=True)

    # delete old files
    os.remove('/root/tensor/data/X.npy')
    os.remove('/root/tensor/data/y.npy')

    # move results file to results
    long_results_filename = '/root/tensor/results/results--' + dt_string +'.h5'
    shutil.move('/root/tensor/results/model_weights.h5', long_results_filename)

    send_file(long_results_filename)
    pass


def send_file(longfilename):
    try:
        url = 'http://dropoff-marlowkart.apps.koopa.hosted.labgear.io/api-upload'

        values = {'DB': 'photcat', 'OUT': 'csv', 'SHORT': 'short'}
        files = {'file': open(longfilename, 'rb')}
        r = requests.post(url, files=files, data=values)

        if r.status_code == 201:
            print('Results successfully sent to dropoff pod.')

        else:
            print('File ' + longfilename + ' failed to send.')
            print('Error content below...')
            print(r.content)

    except Exception as e:
        print('There was a problem sending the file.')
        print(e)
        pass

    pass


if __name__ == "__main__":
    main_loop()

