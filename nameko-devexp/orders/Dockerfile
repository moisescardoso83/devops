FROM nameko-example-builder AS wheels

COPY . /application

RUN cd /application && pip wheel .

# ------------------------------------------------------------------------

FROM nameko-example-base AS install

COPY --from=wheels /application/wheelhouse /wheelhouse

RUN pip install --no-index -f /wheelhouse nameko_examples_orders
# ------------------------------------------------------------------------

FROM nameko-example-base AS service

RUN apt update -y && apt upgrade -y

COPY --from=install /appenv /appenv

RUN pip install nameko-sqlalchemy psycopg2-binary --force-reinstall

COPY config.yml /var/nameko/config.yml
COPY run.sh /var/nameko/run.sh
COPY alembic.ini /var/nameko/alembic.ini
ADD alembic /var/nameko/alembic

RUN chmod +x /var/nameko/run.sh

#USER nameko

WORKDIR /var/nameko/

EXPOSE 8000

CMD /var/nameko/run.sh;
