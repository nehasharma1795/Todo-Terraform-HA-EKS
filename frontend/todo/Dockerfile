# Use Node.js as the base image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Install dependencies required for build
RUN apk add --no-cache python3 g++ make

# Copy dependency definitions
COPY package.json package-lock.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the frontend code
COPY . .

# Build the frontend (if it's a React app)
RUN npm run build

# Expose the default port
EXPOSE 3000

# Start the frontend
CMD ["npm", "start"]

