docker build -t saltsni .

docker build -t tcpdump - <<EOF 
FROM alpine:3.8 
RUN apk add --no-cache tcpdump 
CMD tcpdump -i eth0 
EOF
