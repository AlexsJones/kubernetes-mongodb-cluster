echo 'Generating self signed certificate'
KEY="Test1234"
openssl genrsa -des3 -passout pass:$KEY -out server.pass.key 2048
openssl rsa -passin pass:$KEY -in server.pass.key -out server.key
rm server.pass.key
openssl req -new -key server.key -out server.csr -subj "/C=US/ST=Ohio/L=Atlanta/O=Self/OU=Platform&Infrastructure/CN=localhost"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
cat server.key server.crt > mongodb.pem
rm server.key server.crt server.csr
kubectl --namespace=mongodb delete secret mongodb-secret || true
kubectl --namespace=mongodb create secret generic mongodb-secret --from-file=./mongodb.pem
rm mongodb.pem
