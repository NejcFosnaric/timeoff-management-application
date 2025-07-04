# -------------------------------------------------------------------
# Simple TimeOff Management Dockerfile for MySQL
# -------------------------------------------------------------------
FROM node:16-alpine

# Install build dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    vim

WORKDIR /app

# Copy package files first
COPY package*.json ./

# Set environment variables before npm install to avoid SQLite3 issues
ENV NODE_ENV=production
ENV MYSQL_HOST=localhost
ENV MYSQL_USER=timeoff
ENV MYSQL_DATABASE=timeoff

# Install dependencies including dev dependencies to get mysql
RUN npm ci

# Install MySQL driver for old Sequelize version
RUN npm install mysql

# Copy application code
COPY . .

# Create app user and ensure proper permissions
RUN adduser --disabled-password --gecos "" app && \
    chown -R app:app /app

USER app

EXPOSE 3000

CMD ["npm", "start"]
