# -------------------------------
# Stage 1: Build dependencies
# -------------------------------
FROM node:18-alpine3.18 AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm ci --omit=dev --silent && \
    npm cache clean --force

# Copy application source
COPY . .

# -------------------------------
# Stage 2: Runtime
# -------------------------------
FROM node:18-alpine3.18

# Create non-root user
RUN addgroup -S nodegroup && adduser -S nodeuser -G nodegroup

WORKDIR /app

# Copy built app from builder
COPY --from=builder /app /app

# Ensure correct ownership
RUN chown -R nodeuser:nodegroup /app

# Use non-root user
USER nodeuser

# Expose application port
EXPOSE 3000

# Healthcheck to verify app is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000', res => process.exit(res.statusCode === 200 ? 0 : 1))"

# Start the application
CMD ["node", "index.js"]
