--Create Database
CREATE DATABASE books_db
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       CONNECTION LIMIT = -1;


--Creating Tables

create table Authorr
(
-- 	ID integer,
	author VARCHAR(50) not null,
	gender VARCHAR(10),
	check (Gender in ('M', 'F', 'MALE', 'FEMALE'))
--  primary key (ID)
);

-- drop table Authorr;

INSERT INTO Authorr (author, gender)
VALUES ('Yismake', 'M');

INSERT INTO Authorr (author, gender)
VALUES ('Yeshi', 'F');


CREATE TABLE genres
(
--  ID integer,
    genre VARCHAR(50) 
--  genre character varying NOT NULL

--  primary key (ID)
);
-- drop table genres;

INSERT INTO genres (genre)
VALUES ('Fiction');

INSERT INTO genres (genre)
VALUES ('Scientific');


CREATE TABLE publisher
(
--  ID integer,
    publishedby VARCHAR(50) ,
--  publishedby character varying NOT NULL,
    publication_date date DEFAULT CURRENT_DATE
--  primary key (ID)
);
-- drop table publisher;

INSERT INTO publisher (publishedby)
VALUES ('Yismake PLC');

INSERT INTO publisher (publishedby)
VALUES ('Birhan Ena Selam');


CREATE TABLE books
(
 id serial NOT NULL,
 name VARCHAR(10) NOT NULL,
--  author character varying,
 pages integer,
--  publication_date date,
--  CONSTRAINT pk_books PRIMARY KEY (id )
 PRIMARY KEY (id ) 
)INHERITS (Authorr, genres, publisher);

-- drop table books;

INSERT INTO books (name, pages, author, gender, genre, publishedby)
VALUES ('Book1', 56, 'Faniman', 'M', 'Fiction', 'Fanimans');

INSERT INTO books (name, pages, author, gender, genre, publishedby)
VALUES ('Book2', 15, 'Daniman', 'F', 'SciFi', 'Daniman');

INSERT INTO books (name, pages, author, gender, genre, publishedby)
VALUES ('Book3', 24, 'Fani', 'M', 'Advent', 'Fannn');

INSERT INTO books (name, pages, author, gender, genre, publishedby)
VALUES ('Book4', 556, 'FanimanFek', 'M', 'Fiction', 'Faniman');

INSERT INTO books (name, pages, author, gender, genre, publishedby)
VALUES ('Book5', 175, 'DanimanFik', 'F', 'SciFi', 'Danimman');

INSERT INTO books (name, pages, author, gender, genre, publishedby)
VALUES ('Book6', 424, 'FaniDem', 'M', 'Advent', 'Fann');

select * from books;


CREATE TABLE entities (
   created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE person (
  first_name VARCHAR(30) NOT NULL,
  last_name VARCHAR(30) NOT NULL,
  address VARCHAR(30)	
);

CREATE TABLE users (
  user_name VARCHAR(30) NOT NULL,
  password VARCHAR(30) NOT NULL
) INHERITS (entities, person);


create table librarian
(
id integer primary key,
salary real
) INHERITS (users) ;

INSERT INTO librarian (id, first_name, last_name, address, user_name, password, salary)
VALUES (1, 'Tsehay', 'Mit', '6K', 'Ts', 'ffff', 5000);

INSERT INTO librarian (id, first_name, last_name, address, user_name, password, salary)
VALUES (2, 'Fan', 'Li', '5K', 'Fa', 'Yoo', 8000);

select * from librarian;



create table libadmin
(
libname VARCHAR(10)
)
inherits (librarian);

-- drop table libadmin;

INSERT INTO libadmin (id, first_name, last_name, address, user_name, password, libname, salary)
VALUES (2, 'Fan', 'Li', '5K', 'Fa', 'Yoo', 'Kenedy', 8000);

INSERT INTO libadmin (id, first_name, last_name, address, user_name, password, libname, salary)
VALUES (3, 'Mot', 'Lijo', '6K', 'Mo', 'Yooman', 'Law', 8000);

select * from libadmin;


--Function Overriding and Overloading

create or replace function calculateIncomeTax( librarian ) returns real as 
$$
declare
	lib alias for $1;
begin
	return lib.salary * 0.15;
end;
$$ language 'plpgsql';



create or replace function calculateIncomeTax( libadmin ) returns real as 
$$
declare
	adm alias for $1;
begin
	return adm.salary * 0.20;
end;
$$ language 'plpgsql';

-- drop function calculateIncomeTax(libadmin);

select calculateIncomeTax( librarian ), first_name from librarian;
select calculateIncomeTax( libadmin ), first_name from libadmin;


create or replace function getbook(pagess integer) 
returns table (
	iden integer,
    nam VARCHAR(50)
)
AS 
$info$
begin
return query select id, name from books where pages = pagess;
end;
$info$ 
language 'plpgsql';

-- DROP FUNCTION getbook(integer);
select getbook(15);


--Function Overloading

create or replace function getbook(pagess integer, authr VARCHAR(50)) 
returns table (
	iden integer,
	auth VARCHAR(50)
)
AS 
$$
begin
return query select id, name from books where pages = pagess and author = authr;
end;
$$ 
language 'plpgsql';

select getbook(24, 'Fani');


create or replace function allbooks() 
returns table(
	iden integer,
	nam VARCHAR(50),
	auth VARCHAR(50),
	pag integer,
	pubdate date
) 
AS 
$$
begin
return query SELECT id, name, author, pages, publication_date FROM books order by id;
end;
$$ 
language 'plpgsql';

select allbooks();



create or replace function insertBook(name varchar(50), author varchar(50), pages integer, publicationDate date) 
returns void
AS 
$$
begin
INSERT INTO books(name, author, pages, publication_date) VALUES($1, $2, $3, $4);
end;
$$ 
language 'plpgsql';

DROP FUNCTION insertbook(character varying,character varying,integer,date)
select insertBook('Faaan', 'Fafa', 54, '2016-06-14');

select * from books;




create or replace function updateBook(idd integer, name varchar(50), author varchar(50), pages integer, publicationDate date) 
returns void
AS 
$$
begin
UPDATE books set name=$2, author=$3, pages=$4, publication_date=$5 where id=$1;
end;
$$ 
language 'plpgsql';

-- DROP FUNCTION updatebook(integer,character varying,character varying,integer,date);
select updateBook(8, 'Faaan', 'Faan', 54, '2016-11-14');

select * from books;



create or replace function removeBook(idd integer) 
returns void
AS 
$$
begin
delete from books where id = $1;
end;
$$ 
language 'plpgsql';

select removeBook(7);

select * from books;


--control structures

create or replace function ifstat (date) 
RETURNS text 
AS 
$$ 
BEGIN 
   IF EXTRACT(DAY FROM current_date) = 1 
   THEN   
      RETURN 'Received today'; 
   ELSE 
      RETURN 'Received Other day'; 
   END IF; 
END; 
$$ 
LANGUAGE plpgsql;

SELECT ifstat(current_date);


create or replace function no_book(integer,integer) RETURNS integer AS '
  DECLARE
    bk_id ALIAS FOR $1;
    tot_bk ALIAS FOR $2;
    tmp_id integer;
    no_bk integer;
  BEGIN
    SELECT INTO tmp_id pages FROM books WHERE
      pages = bk_id;
    IF tmp_id IS NULL THEN
      RETURN -1;
    END IF;
    SELECT INTO no_bk count(*) FROM books WHERE id=tot_bk;
    RETURN no_emp;
  
  END;
' LANGUAGE 'plpgsql';


create or replace function  calcday(dt DATE) 
RETURNS INTEGER 
AS 
$$ 
DECLARE ddt DATE; 
        num  INTEGER; 
        x  INTEGER; 
BEGIN 
   ddT := dt; 
   x := EXTRACT(MONTH FROM dt); 
   FOR i IN 1 .. 31 
   LOOP  
      num := i;          
      EXIT WHEN EXTRACT(MONTH FROM ddt + i * INTERVAL '1 DAY') <> x; 
   END LOOP; 
   RETURN num-1;    
END; 
$$ 
LANGUAGE PLPGSQL

SELECT myfunction(current_date);








CREATE DATABASE mydatabase;
create table users
(
 	id SERIAL NOT NULL PRIMARY KEY,
	username VARCHAR(255) not null,
	email VARCHAR(255) not null,
	password VARCHAR(255) not null,
	role VARCHAR(255) not null DEFAULT 'member',
	status integer not null DEFAULT 1
);

 
create table comments (
  id SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR(255) not null,
  email VARCHAR(255) not null,
  subject VARCHAR(255) not null,
  filename VARCHAR(255) not null,
  fromuser VARCHAR(255) not null
) 



