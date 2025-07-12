CREATE DATABASE IF NOT EXISTS railway;

CREATE USER IF NOT EXISTS 'railway_app'@'localhost' IDENTIFIED BY 'railway123';

GRANT ALL PRIVILEGES ON railway.* TO 'railway_app'@'localhost';

CREATE USER IF NOT EXISTS 'railway_app'@'%' IDENTIFIED BY 'railway123';
GRANT ALL PRIVILEGES ON railway.* TO 'railway_app'@'%';

FLUSH PRIVILEGES;

SHOW DATABASES;

SELECT User, Host FROM mysql.user WHERE User = 'railway_app';

USE railway;
SELECT 'Database connection successful!' as status;