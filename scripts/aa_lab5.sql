-- Author: Joel ÅKerblom
use lab5;

/* Lab 5 - 1
Skriv queries för att skapa en databas och tabeller för att hantera personer som har konton med pengar. Konton ska kunna ha en eller flera innehavare, värdet av pengar på kontot får aldrig hamna på mindre än noll. Använd lämpliga datatyper, nycklar, index och foreign keys där det passar. Tabellerna och kolumner ska vara:
a) Users (id, name)
b) Accounts (id, amount)
c) Transfers (id, from_account_id, to_account_id, amount, note, datetime)
d) Owners (user_id, account_id)
*/
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS transfers;
DROP TABLE IF EXISTS owners;

create table users (
	id 			int primary key auto_increment,
	name 	    varchar(50)
);

create table accounts (
    id          int primary key auto_increment,
    amount      int
)

create table transfers (
    id          int primary key auto_increment,
    from_account_id     int,
    to_account_id       int,
    amount              int,
    note                text,
    datetime            datetime
)

create table owners (
    user_id         int primary key,
    account_id      int
)

-- Lab 5 - 1 - Usage:
SHOW create table users;
SHOW create table accounts;
SHOW create table transfers;
SHOW create table owners;

