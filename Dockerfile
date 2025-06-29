# -------------------------------------------------------------------
# Fixed dockerfile for TimeOff Management with SQLite3 support
# -------------------------------------------------------------------
FROM alpine:latest as dependencies

# Install Node.js, npm, Python, and build tools needed for SQLite3
RUN apk add --no-cache \
    nodejs npm \
    python3 \
    make \
    g++ \
    sqlite-dev

COPY package.json .
RUN npm install

FROM alpine:latest

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

# Install runtime dependencies including Python for SQLite3
RUN apk add --no-cache \
    nodejs npm \
    python3 \
    sqlite \
    vim

RUN adduser --system app --home /app
USER app
WORKDIR /app
COPY . /app
COPY --from=dependencies node_modules ./node_modules

CMD npm start

EXPOSE 3000
