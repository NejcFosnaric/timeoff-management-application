# -------------------------------------------------------------------
# Fixed dockerfile for TimeOff Management with SQLite3 support
# -------------------------------------------------------------------
FROM node:16-alpine as dependencies

# Install Python, and build tools needed for native modules
RUN apk add --no-cache \
    python3 \
    python2 \
    make \
    g++ \
    sqlite-dev

FROM node:16-alpine

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

# Install runtime dependencies including Python for native modules
RUN apk add --no-cache \
    python3 \
    python2 \
    make \
    g++ \
    sqlite \
    sqlite-dev \
    vim

RUN adduser --system app --home /app
USER app
WORKDIR /app
COPY . /app

# Install dependencies as the app user
RUN npm install

CMD npm start

EXPOSE 3000
