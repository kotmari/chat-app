# Stage 1: build the SPA (Vite)
FROM node:22-bookworm-slim AS frontend-build
WORKDIR /app/frontend

# Копіюємо файли залежностей
COPY frontend/package.json frontend/package-lock.json ./

# 🌟 Оновлюємо npm та чистимо кеш для запобігання exit code 254
RUN npm install -g npm@latest && npm cache clean --force

# Ставимо залежності
RUN npm install --no-audit --no-fund --legacy-peer-deps

# Копіюємо решту коду фронтенду
COPY frontend/ ./

ENV VITE_API_URL=
ARG VITE_CLERK_PUBLISHABLE_KEY
ENV VITE_CLERK_PUBLISHABLE_KEY=$VITE_CLERK_PUBLISHABLE_KEY

RUN npm run build


# Stage 2: build the API bundle
FROM node:22-bookworm-slim AS backend-build
WORKDIR /app

COPY backend/package.json backend/package-lock.json ./

# 🌟 Оновлюємо npm і тут
RUN npm install -g npm@latest && npm cache clean --force

RUN npm install --no-audit --no-fund

COPY backend/ ./
RUN npm run build


# Stage 3: runtime image
FROM node:22-bookworm-slim AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3001

COPY backend/package.json backend/package-lock.json ./

# Оновлюємо npm для безпеки рантайму
RUN npm install -g npm@latest && npm cache clean --force
RUN npm install --omit=dev --no-audit --no-fund && npm cache clean --force

COPY --from=backend-build /app/dist ./dist
COPY --from=frontend-build /app/frontend/dist ./public

EXPOSE 3001
USER node

CMD ["node", "dist/index.js"]