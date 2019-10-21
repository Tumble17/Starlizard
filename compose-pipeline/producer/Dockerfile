FROM python:3.5-alpine
RUN python -m pip install --upgrade pip
COPY . .
RUN pip3 install -r requirements.txt
RUN sleep 10
RUN . producer_process.sh
