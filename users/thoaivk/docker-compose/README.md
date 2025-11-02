# Docker Compose Services for Development

This directory contains Docker Compose configurations for various development services.

## Available Services

### Individual Services

- **postgresql.yml** - PostgreSQL 16
  ```bash
  docker-compose -f ~/docker-compose/postgresql.yml up -d
  ```
  Connection: `postgresql://dev:devpassword@localhost:5432/dev_database`

- **mysql.yml** - MySQL 8.0
  ```bash
  docker-compose -f ~/docker-compose/mysql.yml up -d
  ```
  Connection: `mysql://dev:devpassword@localhost:3306/dev_database`

- **redis.yml** - Redis 7
  ```bash
  docker-compose -f ~/docker-compose/redis.yml up -d
  ```
  Connection: `redis://localhost:6379`

- **kafka.yml** - Kafka + Zookeeper + Kafka UI
  ```bash
  docker-compose -f ~/docker-compose/kafka.yml up -d
  ```
  - Kafka: `localhost:9092`
  - Kafka UI: `http://localhost:8080`

### Full Stack

- **full-stack.yml** - All databases together
  ```bash
  docker-compose -f ~/docker-compose/full-stack.yml up -d
  ```

## Quick Commands

### Start Services
```bash
# PostgreSQL
pgstart

# MySQL
mysqlstart

# Redis
redisstart

# All services
docker-compose -f ~/docker-compose/full-stack.yml up -d
```

### Stop Services
```bash
# PostgreSQL
pgstop

# MySQL
mysqlstop

# Redis
redisstop

# All services
docker-compose -f ~/docker-compose/full-stack.yml down
```

### Connect to Databases

```bash
# PostgreSQL
pgcli postgresql://dev:devpassword@localhost:5432/dev_database

# MySQL
mycli -h localhost -u dev -pdevpassword dev_database

# Redis
redis-cli
```

## Default Credentials

### PostgreSQL
- User: `dev`
- Password: `devpassword`
- Database: `dev_database`
- Port: `5432`

### MySQL
- User: `dev`
- Password: `devpassword`
- Root Password: `rootpassword`
- Database: `dev_database`
- Port: `3306`

### MongoDB (full-stack only)
- User: `dev`
- Password: `devpassword`
- Port: `27017`

### Redis
- No authentication by default
- Port: `6379`

### Kafka
- Bootstrap Servers: `localhost:9092`
- Zookeeper: `localhost:2181`
- Kafka UI: `http://localhost:8080`

## Data Persistence

All services use Docker volumes for data persistence. Data will survive container restarts.

To completely remove data:
```bash
docker-compose -f ~/docker-compose/SERVICE.yml down -v
```

## Health Checks

All services include health checks. Check service health:
```bash
docker ps
```

Look for the "STATUS" column showing "(healthy)".
