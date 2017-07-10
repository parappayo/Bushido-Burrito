
CREATE DATABASE  `request_log` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `request_log`;

CREATE TABLE  `simple_log` (
 `uri` VARCHAR( 1024 ) NOT NULL ,
 `date` DATETIME NOT NULL ,
 `remote_ip` INT NOT NULL ,
 `user_agent` VARCHAR( 1024 ) NOT NULL
) ENGINE = INNODB;

CREATE TABLE  `user_agent` (
 `id` MEDIUMINT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
 `user_agent` VARCHAR( 512 ) NOT NULL
) ENGINE = INNODB;

CREATE TABLE  `smart_log` (
 `uri` VARCHAR( 1024 ) NOT NULL ,
 `date` DATETIME NOT NULL ,
 `remote_ip` INT NOT NULL ,
 `user_agent_id` MEDIUMINT NOT NULL ,
 INDEX ( `user_agent_id` ),
 FOREIGN KEY ( `user_agent_id`)
   REFERENCES user_agent(id)
) ENGINE = INNODB;
