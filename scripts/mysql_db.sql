DROP DATABASE IF EXISTS benchmark;
CREATE DATABASE benchmark;

CREATE TABLE benchmark.`cache` (
  `key` varchar(255) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`key`) USING HASH
) ENGINE=MEMORY DEFAULT CHARSET=utf8;

CREATE TABLE benchmark.`cache_innodb` (
  `key` varchar(255) NOT NULL,
  `value` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) CHARSET=utf8 ENGINE=InnoDB;
