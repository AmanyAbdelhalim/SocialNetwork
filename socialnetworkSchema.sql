-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema socialnetwork
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema socialnetwork
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `socialnetwork` DEFAULT CHARACTER SET latin1 ;
USE `socialnetwork` ;

-- -----------------------------------------------------
-- Table `socialnetwork`.`maritalstatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`maritalstatus` (
  `idmaritalstatus` INT(11) NOT NULL,
  `maritalstatus` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idmaritalstatus`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`occupation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`occupation` (
  `idoccupation` INT(11) NOT NULL,
  `occupation` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idoccupation`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`member`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`member` (
  `memerid` INT(11) NOT NULL,
  `membername` VARCHAR(45) NULL DEFAULT NULL,
  `memberdob` VARCHAR(45) NULL DEFAULT NULL,
  `membergender` CHAR(1) NULL DEFAULT NULL,
  `occupation` INT(11) NULL DEFAULT NULL,
  `maritalstat` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`memerid`),
  INDEX `occupation_idx` (`occupation` ASC),
  INDEX `maritalstatus_idx` (`maritalstat` ASC),
  CONSTRAINT `maritalstatus`
    FOREIGN KEY (`maritalstat`)
    REFERENCES `socialnetwork`.`maritalstatus` (`idmaritalstatus`)
    ON DELETE CASCADE,
  CONSTRAINT `occupation`
    FOREIGN KEY (`occupation`)
    REFERENCES `socialnetwork`.`occupation` (`idoccupation`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`friends`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`friends` (
  `idmember` INT(11) NOT NULL,
  `idfriend` INT(11) NOT NULL,
  PRIMARY KEY (`idmember`, `idfriend`),
  INDEX `f8_idx` (`idfriend` ASC),
  CONSTRAINT `f7`
    FOREIGN KEY (`idmember`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE CASCADE,
  CONSTRAINT `f8`
    FOREIGN KEY (`idfriend`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`hobbies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`hobbies` (
  `idhobbies` INT(11) NOT NULL,
  `hobby` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idhobbies`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`language`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`language` (
  `idlanguage` INT(11) NOT NULL,
  `language` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`idlanguage`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`memberhobby`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`memberhobby` (
  `idmember` INT(11) NOT NULL,
  `idhobby` INT(11) NOT NULL,
  PRIMARY KEY (`idmember`, `idhobby`),
  INDEX `idhobby_idx` (`idhobby` ASC),
  CONSTRAINT `idhobby`
    FOREIGN KEY (`idhobby`)
    REFERENCES `socialnetwork`.`hobbies` (`idhobbies`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idmember`
    FOREIGN KEY (`idmember`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`memberlanguage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`memberlanguage` (
  `idmember` INT(11) NOT NULL,
  `idlanguage` INT(11) NOT NULL,
  PRIMARY KEY (`idmember`, `idlanguage`),
  INDEX `f2_idx` (`idlanguage` ASC),
  CONSTRAINT `f1`
    FOREIGN KEY (`idmember`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `f2`
    FOREIGN KEY (`idlanguage`)
    REFERENCES `socialnetwork`.`language` (`idlanguage`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`memberposts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`memberposts` (
  `postid` INT(11) NOT NULL,
  `idmember` INT(11) NOT NULL,
  `post` VARCHAR(45) NULL DEFAULT NULL,
  `description` VARCHAR(45) NULL DEFAULT NULL,
  `datetime` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`postid`),
  INDEX `idmember_idx` (`idmember` ASC),
  CONSTRAINT `f3`
    FOREIGN KEY (`idmember`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`postcomments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`postcomments` (
  `idpost` INT(11) NOT NULL,
  `idmember` INT(11) NOT NULL,
  `comment` VARCHAR(45) NULL DEFAULT NULL,
  `datetime` DATETIME NOT NULL,
  PRIMARY KEY (`idpost`, `idmember`, `datetime`),
  INDEX `idmember_idx` (`idmember` ASC),
  CONSTRAINT `f4`
    FOREIGN KEY (`idmember`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idpost`
    FOREIGN KEY (`idpost`)
    REFERENCES `socialnetwork`.`memberposts` (`postid`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `socialnetwork`.`recommendedfriends`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `socialnetwork`.`recommendedfriends` (
  `idmember` INT(11) NOT NULL,
  `idfriend` INT(11) NOT NULL,
  PRIMARY KEY (`idmember`, `idfriend`),
  INDEX `f6_idx` (`idfriend` ASC),
  CONSTRAINT `f5`
    FOREIGN KEY (`idmember`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE CASCADE,
  CONSTRAINT `f6`
    FOREIGN KEY (`idfriend`)
    REFERENCES `socialnetwork`.`member` (`memerid`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
