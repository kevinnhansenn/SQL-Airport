

/* Number 3 */

/*Create jbmanager table with id bonus attribute*/
CREATE TABLE jbmanager (id int, bonus int DEFAULT 0, CONSTRAINT pk_manager PRIMARY KEY (id));

/*Establish connection between jbmanager and jbemployee*/
ALTER TABLE jbmanager ADD CONSTRAINT fk_manager_employee FOREIGN KEY (id) REFERENCES jbemployee(id);

/*Migrate the manager in employee into jbmanager*/
INSERT INTO jbmanager (id) SELECT id FROM jbemployee WHERE id IN (SELECT manager FROM jbdept) UNION SELECT id FROM jbemployee WHERE id IN (SELECT manager FROM jbemployee);

/*Set the foreign key on jbmanager*/
ALTER TABLE jbemployee ADD CONSTRAINT fk_manager FOREIGN KEY (manager) REFERENCES jbmanager(id);

/*Drop jbdept foreign key if any*/
ALTER TABLE jbdept DROP FOREIGN KEY fk_dept_mgr;

/*Set the foreign key on jbdept*/
ALTER TABLE jbdept ADD CONSTRAINT fk_dept_mgr FOREIGN KEY (manager) REFERENCES jbmanager(id);

/*We need to initialize bonus attribute to a value, if initial value was not added, we do not know where to start and continue the counting*/


/* Number 4 */

/*Update the bonus of managers*/
UPDATE jbmanager SET bonus = bonus+10000 WHERE id IN (SELECT manager FROM jbdept);


/* Number 5 */

/*Inialize customer table*/
CREATE TABLE jbcustomer (id int, name varchar(20), address varchar(20), city int, CONSTRAINT pk_customer PRIMARY KEY (id));

/*Inialize account table*/
CREATE TABLE jbaccount (id int, balance double, owner int, CONSTRAINT pk_account PRIMARY KEY(id));

/*Inialize transaction table*/
CREATE TABLE jbtransaction (id int, amount double, sdate timestamp DEFAULT CURRENT_TIMESTAMP, employee int, account  int, CONSTRAINT pk_transaction PRIMARY KEY(id));

/*Inialize deposit table*/
CREATE TABLE jbdeposit (id int, constraint pk_deposit PRIMARY KEY(id));
ALTER TABLE jbdeposit ADD CONSTRAINT fk_deposit_transaction FOREIGN KEY (id) REFERENCES jbtransaction(id);

/*Inialize withdrawal table*/
CREATE TABLE jbwithdrawal (id int, CONSTRAINT pk_deposit PRIMARY KEY(id));
ALTER TABLE jbwithdrawal ADD CONSTRAINT fk_withdrawal_transaction FOREIGN KEY (id) REFERENCES jbtransaction(id);

/*Drop foreign key of jbdebit and jbsale*/
ALTER TABLE jbdebit DROP FOREIGN KEY fk_debit_employee;
ALTER TABLE jbsale DROP FOREIGN KEY fk_sale_debit;

/*Drop jbdebit*/
DROP TABLE jbdebit;

/*Recreate debit table*/
CREATE TABLE jbdebit (id int, constraint pk_deposit primary key (id));
ALTER TABLE jbdebit ADD CONSTRAINT fk_debit_transaction FOREIGN KEY (id) REFERENCES jbtransaction(id);

/*Clear jbsale table*/
DELETE from jbsale;

/*Assign all the neccessary foreign keys*/
ALTER TABLE jbsale ADD CONSTRAINT fk_sale_debit FOREIGN KEY (debit) REFERENCES jbdebit(id);

ALTER TABLE jbtransaction ADD CONSTRAINT fk_transaction_employee FOREIGN KEY (employee) REFERENCES jbemployee(id);

ALTER TABLE jbtransaction ADD CONSTRAINT fk_transaction_account FOREIGN KEY (account) REFERENCES jbaccount(id);

ALTER TABLE jbaccount ADD CONSTRAINT fk_account_customer FOREIGN KEY (owner) REFERENCES jbcustomer(id);

ALTER TABLE jbcustomer ADD CONSTRAINT fk_customer_city FOREIGN KEY (city) REFERENCES jbcity(id);
