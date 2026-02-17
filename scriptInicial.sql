DROP DATABASE IF EXISTS proyecto1AyD2;

CREATE DATABASE proyecto1AyD2
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

USE proyecto1AyD2;
DROP USER IF EXISTS 'proyecto1AyD2'@'localhost';
CREATE USER 'proyecto1AyD2'@'localhost'identified WITH mysql_native_password BY '123456';
GRANT ALL PRIVILEGES ON proyecto1AyD2.* TO 'proyecto1AyD2'@'localhost';
FLUSH PRIVILEGES;



