FROM python:3.7-alpine

MAINTAINER Anton Salman <anton.salman@gmail.com>

LABEL version="1.0"
LABEL description="django app base image"
LABEL maintainer "anton.salmana@gmail.com"

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# copy entrypoint.sh
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY ./Pipfile* /
RUN apk add --no-cache --virtual .build-deps \
    ca-certificates gcc postgresql-dev linux-headers musl-dev \
    libffi-dev jpeg-dev zlib-dev \
    && pip install --upgrade pip \
    && pip install pipenv \
    && pipenv install --deploy --system --dev \
    && find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
    && apk add --virtual .rundeps $runDeps \
    && apk del .build-deps \
    && python -c "import django; print(django.get_version())" \
    && adduser -D django

# Set work directory
RUN mkdir --parent /app/src
WORKDIR /app/src

# copy entrypoint.sh
#ADD ./entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#RUN chown django /entrypoint.sh
#RUN pipenv install --skip-lock --system --dev

# Copy project
COPY --chown=django ./src /app/src
#RUN chown -R django /app/src
#RUN chown -R django /app/src/logs
#RUN python manage.py makemigrations && python manage.py migrate
USER django
EXPOSE 8000
# run entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
