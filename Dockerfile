# Step 1: Build the React app
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# Install pnpm
RUN npm install -g pnpm

# Copy lockfile and package.json first for better caching
COPY pnpm-lock.yaml ./
COPY package.json ./

# Install dependencies
RUN pnpm install

# Copy the rest of the application code
COPY . .

# Build the app
RUN pnpm run build

# Step 2: Use NGINX to serve the build folder
FROM nginx:alpine

COPY --from=builder /usr/src/app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
