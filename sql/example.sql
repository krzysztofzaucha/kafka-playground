CREATE
DATABASE IF NOT EXISTS `example`;

CREATE TABLE `example`
(
    `id`      int(11) NOT NULL AUTO_INCREMENT,
    `example` varchar(62) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COLLATE = utf8_unicode_ci;
