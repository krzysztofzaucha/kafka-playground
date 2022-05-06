GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT
    ON *.* TO 'debezium' IDENTIFIED BY 'password';

CREATE DATABASE IF NOT EXISTS `example`;

USE `example`;

CREATE TABLE `primary`
(
    `id`      int(11) NOT NULL AUTO_INCREMENT,
    `value` varchar(62) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

CREATE TABLE `secondary`
(
    `id`      int(11) NOT NULL AUTO_INCREMENT,
    `value` varchar(62) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;

CREATE TABLE `tertiary`
(
    `id`      int(11) NOT NULL AUTO_INCREMENT,
    `value` varchar(62) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;
