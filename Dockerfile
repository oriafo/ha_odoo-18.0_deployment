# Stage 1: Build stage
FROM python:3.12-slim AS builder

ENV ODOO_HOME=/opt/odoo

WORKDIR $ODOO_HOME
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libsasl2-dev \
    libldap2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip3 install --timeout=60 --retries=5 -r requirements.txt


# Stage 2: Runtime stage
FROM python:3.12-slim

ENV ODOO_HOME=/opt/odoo
ENV ODOO_CONF=/etc/odoo

WORKDIR $ODOO_HOME

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libsasl2-dev \
    libldap2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy Odoo from the builder stage
# COPY --from=builder $ODOO_HOME $ODOO_HOME
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

RUN mkdir -p $ODOO_CONF
COPY . .
COPY ./odoo.conf $ODOO_CONF
# Expose the necessary ports
EXPOSE 8069 8069

# Start Odoo
CMD ["python3", "/opt/odoo/odoo-bin", "-c", "/etc/odoo.conf", "-i", "all"]

