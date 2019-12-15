FROM alpine:3.10 AS build
ARG DEBUG=False
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /app

RUN apk add --no-cache python3 postgresql-libs
RUN if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi
RUN apk add --no-cache --virtual .build-deps python3-dev gcc musl-dev postgresql-dev make
RUN pip3 install --disable-pip-version-check --no-cache-dir pipenv

WORKDIR /app
COPY Pipfile Pipfile.lock /app/

RUN pipenv install --system --deploy --ignore-pipfile
RUN pip3 uninstall pipenv virtualenv virtualenv-clone certifi pip -y

RUN apk --purge del .build-deps

RUN rm -rf /root/.cache /root/.local \
    /etc/apk/ /usr/share/apk/ /lib/apk/ /sbin/apk \
    /media /usr/lib/terminfo /usr/share/terminfo \
    /usr/lib/python*/ensurepip \
    /usr/lib/python*/turtledemo \ 
    /usr/lib/python*/turtle.py /usr/lib/python*/__pycache__/turtle.*

RUN if [[ "$DEBUG" != "TRUE" ]] && [[ "$DEBUG" != "True" ]] && [[ "$DEBUG" != "1" ]]; then \
    find /usr/lib/python*/* | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf; \
    python3 -m compileall -b /usr/lib/python*; \
    find /usr/lib/python*/* -name "*.py"|xargs rm -rf; \
    fi

RUN rm -rf /app/Pipfile*
RUN find /usr/lib/python3.* -name '*.c' -delete
RUN find /usr/lib/python3.* -name '*.pxd' -delete
RUN find /usr/lib/python3.* -name '*.pyd' -delete


FROM scratch AS deploy
ARG DEBUG=False
ENV PYTHONUNBUFFERED 1
ENV DEBUG ${DEBUG}
EXPOSE 8000
COPY --from=build / /
WORKDIR /app
