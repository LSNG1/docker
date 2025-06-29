#!/bin/sh

set -e 

echo "Starting Laravel application setup..."

cd /var/www

echo "Setting proper permissions..."
chown -R www-data:www-data /var/www
chmod -R 755 /var/www/storage /var/www/bootstrap/cache

if [ ! -f vendor/autoload.php ]; then
    echo "Installing Composer dependencies..."
    composer install --no-interaction --optimize-autoloader --no-dev
    composer dump-autoload --optimize
    chown -R www-data:www-data /var/www/vendor
    echo "Composer dependencies installed successfully."
else
    echo "Composer dependencies already installed."
fi

if [ ! -d node_modules ] || [ ! -f public/build/manifest.json ]; then
    echo "Installing Node.js dependencies..."
    npm ci --only=production
    echo "Building frontend assets..."
    npm run build
    echo "Frontend assets built successfully."
else
    echo "Frontend assets already built."
fi

if [ ! -f .env ]; then
    echo "Creating .env file..."
    cp .env.example .env
fi

if ! grep -q "APP_KEY=base64:" .env; then
    echo "Generating application key..."
    php artisan key:generate --no-interaction
    echo "Application key generated."
else
    echo "Application key already set."
fi

php artisan migrate --force

USER_COUNT=$(php artisan tinker --execute="echo App\\Models\\User::count();" 2>/dev/null || echo "0")
if [ "$USER_COUNT" -eq 0 ]; then
    echo "Seeding database..."
    php artisan db:seed --force
    echo "Database seeded successfully."
else
    echo "Database already contains data ($USER_COUNT users)."
fi

echo "Optimizing Laravel..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
echo "Laravel optimized."

chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

echo "Laravel application ready!"
echo "Starting PHP-FPM..."

exec php-fpm
