#FROM python:3.8-slim

#WORKDIR /web

#COPY server.py .
#COPY certificate.crt .
#COPY private.key .

#COPY anti_patrola/build/web .

#RUN ls

#EXPOSE 443

#CMD ["python", "server.py"]

FROM nginx:alpine

WORKDIR /app

COPY web/nginx.conf /etc/nginx/nginx.conf
COPY web/anti_patrola/build/web .

COPY web/anti_patrola/build/web /var/www
COPY certificate.crt /etc/letsencrypt/live/antipatrola/certificate.crt
COPY private.key /etc/letsencrypt/live/antipatrola/private.key
COPY dhparams.pem /etc/letsencrypt/dhparams.pem

RUN ls -l /etc/letsencrypt/live/antipatrola/

EXPOSE 443
EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]