# Laravel Docker Development Environment

A complete Docker-based development environment for Laravel applications with MySQL database and dual Nginx load balancing setup.

## 🏗️ Architecture

This project uses a multi-container Docker setup with the following services:

- **PHP-FPM 8.3**: Laravel application server with all necessary extensions
- **MySQL 8.3**: Database server with persistent storage
- **Nginx (2 instances)**: Load balancing setup with two Nginx servers
- **Node.js**: For frontend asset compilation

## 📋 Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Git

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone git@github.com:LSNG1/docker.git
   cd docker
   ```

2. **Start the application**
   ```bash
   docker-compose up -d
   ```

3. **Access the application**
   - Primary server: http://localhost:8081
   - Secondary server: http://localhost:8082
   - Database: localhost:3306

## 🔧 Services Configuration

### PHP Service
- **Base Image**: php:8.3-fpm
- **Extensions**: PDO MySQL, mbstring, exif, pcntl, bcmath, gd
- **Tools**: Composer, Node.js, npm
- **Working Directory**: `/var/www`

### MySQL Service
- **Version**: 8.3
- **Database**: laravel
- **Username**: user
- **Password**: userpass
- **Root Password**: root
- **Port**: 3306

### Nginx Services
- **nginx1**: Port 8081
- **nginx2**: Port 8082
- Both configured to serve the Laravel application with PHP-FPM backend

## 📁 Project Structure

```
.
├── docker-compose.yml          # Docker services configuration
├── .dockerignore              # Docker ignore patterns
├── .gitignore                 # Git ignore patterns
├── laravel-app/               # Laravel application directory
├── nginx/                     # Nginx configuration files
│   ├── nginx1.conf           # Configuration for first Nginx instance
│   └── nginx2.conf           # Configuration for second Nginx instance
├── php/                       # PHP container configuration
│   ├── Dockerfile            # PHP-FPM container build instructions
│   └── entrypoint.sh         # Container startup script
└── logs/                      # Application and server logs
```

## 🛠️ Development Commands

### Container Management
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild containers
docker-compose up -d --build
```

### Laravel Commands
```bash
# Access PHP container
docker-compose exec php bash

# Run Artisan commands
docker-compose exec php php artisan migrate
docker-compose exec php php artisan tinker

# Install Composer dependencies
docker-compose exec php composer install

# Build frontend assets
docker-compose exec php npm run build
```

### Database Operations
```bash
# Access MySQL
docker-compose exec mysql mysql -u user -puserpass laravel

# Run migrations
docker-compose exec php php artisan migrate

# Seed database
docker-compose exec php php artisan db:seed
```

## 🔄 Automated Setup

The PHP container includes an automated setup script (`entrypoint.sh`) that:

1. Sets proper file permissions
2. Installs Composer dependencies
3. Installs Node.js dependencies and builds assets
4. Creates `.env` file from example
5. Generates application key
6. Runs database migrations
7. Seeds the database (if empty)
8. Optimizes Laravel (config, routes, views cache)

## 🗄️ Database Configuration

The Laravel application is configured to connect to MySQL with these default settings:

- **Host**: mysql (Docker service name)
- **Port**: 3306
- **Database**: laravel
- **Username**: user
- **Password**: userpass

## 📊 Health Checks

All services include health checks:

- **MySQL**: Checks database connectivity
- **PHP**: Verifies Laravel migration status
- **Nginx**: Depends on healthy PHP service

## 🔍 Troubleshooting

### Common Issues

1. **Port conflicts**
   ```bash
   # Check if ports are in use
   netstat -tulpn | grep :8081
   netstat -tulpn | grep :3306
   ```

2. **Permission issues**
   ```bash
   # Fix Laravel storage permissions
   docker-compose exec php chown -R www-data:www-data /var/www/storage
   docker-compose exec php chmod -R 755 /var/www/storage
   ```

3. **Database connection issues**
   ```bash
   # Check MySQL service status
   docker-compose ps mysql
   docker-compose logs mysql
   ```

4. **Clear Laravel cache**
   ```bash
   docker-compose exec php php artisan cache:clear
   docker-compose exec php php artisan config:clear
   docker-compose exec php php artisan route:clear
   docker-compose exec php php artisan view:clear
   ```

### Logs Location

- **Application logs**: `./logs/`
- **Nginx logs**: `./logs/nginx/`
- **Container logs**: `docker-compose logs [service-name]`

## 🔧 Customization

### Environment Variables

Modify the `.env` file in the `laravel-app` directory to customize:
- Database connections
- Application settings
- Third-party service configurations

### Nginx Configuration

Edit `nginx/nginx1.conf` or `nginx/nginx2.conf` to customize:
- Server blocks
- SSL settings
- Caching rules
- Load balancing

### PHP Configuration

Modify `php/Dockerfile` to:
- Add PHP extensions
- Install additional packages
- Change PHP settings

## 📝 Laravel Framework

This project uses **Laravel 9.x** with the following key packages:

- **Laravel Breeze**: Authentication scaffolding
- **Laravel Sanctum**: API authentication
- **Laravel Tinker**: REPL for Laravel
- **Tailwind CSS**: Utility-first CSS framework

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

## 🆘 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Docker and Laravel documentation
3. Create an issue in the repository

---

**Happy coding! 🚀**
