
FROM  node:17-bullseye
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -qy locales \
    && echo "en_US ISO-8859-1" >> /etc/locale.gen && locale-gen
RUN npm i -g esy