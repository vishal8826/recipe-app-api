FROM python:3.9-alpine3.13
LABEL maintainer="vishal"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
#creates a python virtual environment, installs the dependencies, removes the /tmp dir and creates a new user django-user
RUN python3 -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV="true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# adding the path to the linux environment so that we don't have to type /py/bin everytime
ENV PATH="/py/bin:$PATH"

#container will run with the last user we switch to
USER django-user
