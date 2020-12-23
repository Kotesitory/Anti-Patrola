FROM fluttersdk/fluttersdk

WORKDIR /web

COPY anti_patrola anti_patrola

WORKDIR /web/anti_patrola

RUN pwd

RUN flutter channel beta

RUN flutter upgrade

RUN flutter config --enable-web

RUN flutter build web

RUN flutter pub global activate dhttpd

EXPOSE 80

CMD ["flutter", "pub", "global", "run", "dhttpd", "-p", "80", "--path", "build/web"]