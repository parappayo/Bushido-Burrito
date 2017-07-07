
CREATE DATABASE  `request_log` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE TABLE  `simple_log` (
 `uri` VARCHAR( 1024 ) NOT NULL ,
 `date` DATETIME NOT NULL ,
 `remote_ip` INT NOT NULL ,
 `user_agent` VARCHAR( 1024 ) NOT NULL
) ENGINE = INNODB;
