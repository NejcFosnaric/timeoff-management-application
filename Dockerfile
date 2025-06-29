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

# Install dependencies (production mode)
RUN npm ci --only=production

# Copy application code
COPY . .

# Create app user and set permissions
RUN adduser --system --no-create-home app && \
    chown -R app /app

USER app

EXPOSE 3000

CMD ["npm", "start"]
