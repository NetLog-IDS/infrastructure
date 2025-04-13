sudo docker run -d \
    --name monitoring \
    --hostname monitoring \
    -p 8000:8000 \
    -e KAFKA_BROKER="localhost:9092" \
    -e CONNECTION_STRING="mongodb://mongoadmin:secret@localhost:27017" \
    -e MAIL_USERNAME="to be added" \
    -e MAIL_PASSWORD="to be added (google email token)" \
    -e MAIL_FROM="to be added" \
    -e MAIL_PORT="587" \
    -e MAIL_SERVER="smtp.gmail.com" \
    johannessetiawan/monitoring-netlog