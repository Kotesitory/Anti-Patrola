FROM python:3.8-slim

WORKDIR /web

COPY server.py .
COPY certificate.crt .
COPY private.key .

COPY anti_patrola/build/web .

RUN ls

EXPOSE 443

CMD ["python", "server.py"]