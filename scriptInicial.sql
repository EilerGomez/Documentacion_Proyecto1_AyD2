DROP DATABASE IF EXISTS proyecto1AyD2;

CREATE DATABASE proyecto1AyD2
CHARACTER SET utf8mb4
COLLATE utf8mb4_spanish_ci;

USE proyecto1AyD2;
DROP USER IF EXISTS 'proyecto1AyD2'@'localhost';
CREATE USER 'proyecto1AyD2'@'localhost'identified by '123456';
grant select on proyecto1AyD2.* to 'proyecto1AyD2'@'localhost';
grant update on proyecto1AyD2.* to 'proyecto1AyD2'@'localhost';
grant delete on proyecto1AyD2.* to 'proyecto1AyD2'@'localhost';
grant insert on proyecto1AyD2.* to 'proyecto1AyD2'@'localhost';