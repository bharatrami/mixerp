DROP SCHEMA IF EXISTS audit CASCADE;
DROP SCHEMA IF EXISTS core CASCADE;
DROP SCHEMA IF EXISTS office CASCADE;
DROP SCHEMA IF EXISTS policy CASCADE;
DROP SCHEMA IF EXISTS transactions CASCADE;
DROP SCHEMA IF EXISTS crm CASCADE;

CREATE SCHEMA audit;
CREATE SCHEMA core;
CREATE SCHEMA office;
CREATE SCHEMA policy;
CREATE SCHEMA transactions;
CREATE SCHEMA crm;


DROP DOMAIN IF EXISTS verification;
CREATE DOMAIN verification AS smallint
CHECK
(
	VALUE IN
	(
		-3,	--Rejected
		-2,	--Closed
		-1,	--Locked
		 0,	--Awaiting Approval
		 1	--Approved
	)
);

DROP DOMAIN IF EXISTS customer_type;
CREATE DOMAIN customer_type
AS char(1)
CHECK
(
	VALUE IN
	(
		'A', --Agent
		'C', --Customer
		'D'  --Dealer
	)
);


DROP DOMAIN IF EXISTS transaction_type;
CREATE DOMAIN transaction_type
AS char(2)
CHECK
(
	VALUE IN
	(
		'Dr', --Debit
		'Cr' --Credit
	)
);

/*******************************************************************
	MIXERP STRICT DATATYPES: NEGATIVES ARE NOT ALLOWED
*******************************************************************/

DROP DOMAIN IF EXISTS money_strict;
CREATE DOMAIN money_strict
AS money
CHECK
(
	VALUE > '0'
);

DROP DOMAIN IF EXISTS integer_strict;
CREATE DOMAIN integer_strict
AS integer
CHECK
(
	VALUE > 0
);

DROP DOMAIN IF EXISTS smallint_strict;
CREATE DOMAIN smallint_strict
AS smallint
CHECK
(
	VALUE > 0
);

DROP DOMAIN IF EXISTS decimal_strict;
CREATE DOMAIN decimal_strict
AS decimal
CHECK
(
	VALUE > 0
);

DROP DOMAIN IF EXISTS float_strict;
CREATE DOMAIN float_strict
AS float
CHECK
(
	VALUE > 0
);

DROP VIEW IF EXISTS db_stat;
CREATE VIEW db_stat
AS
select
    relname,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    vacuum_count,
    autovacuum_count,
    analyze_count,
    autoanalyze_count
from
   pg_stat_user_tables;

CREATE TABLE core.currencies
(
	currency_code varchar(12) NOT NULL PRIMARY KEY,
	currency_symbol national character varying(12) NOT NULL,
	currency_name national character varying(48) NOT NULL UNIQUE,
	hundredth_name national character varying(48) NOT NULL	
);

INSERT INTO core.currencies
SELECT 'NPR', 'Rs.', 'Nepali Rupees', 'paisa' UNION ALL
SELECT 'USD', '$ ', 'United States Dollar', 'cents';


CREATE FUNCTION office.is_parent_office(child integer_strict, parent integer_strict)
RETURNS boolean
AS
$$		
BEGIN
	IF $1!=$2 THEN
		IF EXISTS
		(
			WITH RECURSIVE office_cte(office_id, path) AS (
			 SELECT
				tn.office_id,  tn.office_id::TEXT AS path
				FROM office.offices AS tn WHERE tn.parent_office_id IS NULL
			UNION ALL
			 SELECT
				c.office_id, (p.path || '->' || c.office_id::TEXT)
				FROM office_cte AS p, office.offices AS c WHERE parent_office_id = p.office_id
			)
			SELECT * FROM
			(
				SELECT regexp_split_to_table(path, '->')
				FROM office_cte AS n WHERE n.office_id = $2
			) AS items
			WHERE regexp_split_to_table=$1::text
		) THEN
			RETURN TRUE;
		END IF;
	END IF;
	RETURN false;
END
$$
LANGUAGE plpgsql;


CREATE TABLE office.offices
(
	office_id SERIAL  NOT NULL PRIMARY KEY,
	office_code varchar(12) NOT NULL,
	office_name varchar(150) NOT NULL,
	nick_name varchar(50) NULL,
	registration_date date NOT NULL,
	currency_code varchar(12) NOT NULL 
					CONSTRAINT offices_currencies_fk REFERENCES core.currencies(currency_code)
					CONSTRAINT offices_currency_code_df DEFAULT('NPR'),
	street varchar(50) NULL,
	city varchar(50) NULL,
	state varchar(50) NULL,
	country varchar(50) NULL,
	zip_code varchar(24) NULL,
	phone varchar(24) NULL,
	fax varchar(24) NULL,
	email varchar(128) NULL,
	url varchar(50) NULL,
	registration_number varchar(24) NULL,
	pan_number varchar(24) NULL,
	parent_office_id integer NULL REFERENCES office.offices(office_id)
		CHECK
		(
			office.is_parent_office(office_id, parent_office_id) = FALSE
			AND
			parent_office_id != office_id
		)
);

CREATE UNIQUE INDEX offices_office_code_uix
ON office.offices(UPPER(office_code));

CREATE UNIQUE INDEX offices_office_name_uix
ON office.offices(UPPER(office_name));

CREATE UNIQUE INDEX offices_nick_name_uix
ON office.offices(UPPER(nick_name));

CREATE INDEX offices_parent_office_id_inx
ON office.offices(parent_office_id);


/*******************************************************************
	SAMPLE DATA FEED
	TODO: REMOVE THE BELOW BEFORE RELEASE
*******************************************************************/

INSERT INTO office.offices(office_code,office_name,nick_name,registration_date, street,city,state,country,zip_code,phone,fax,email,url,registration_number,pan_number)
SELECT 'PES','Planet Earth Solutions', 'PES Technologies', '06/06/1989', 'Tinkune','Kathmandu','Bagmati','Nepal','00977','4112387','4112442','info@planetearthsolution.com','http://planetearthsolution.com','0','0';


INSERT INTO office.offices(office_code,office_name,nick_name, registration_date, street,city,state,country,zip_code,phone,fax,email,url,registration_number,pan_number,parent_office_id)
SELECT 'PES-TIN','Tinkune Branch', 'PES Tinkune', '06/06/1989', 'Tinkune','Kathmandu','Bagmati','Nepal','00977','4112387','4112442','info@planetearthsolution.com','http://planetearthsolution.com','0','0',(SELECT office_id FROM office.offices WHERE office_code='PES');

INSERT INTO office.offices(office_code,office_name,nick_name, registration_date, street,city,state,country,zip_code,phone,fax,email,url,registration_number,pan_number,parent_office_id)
SELECT 'PES-KAV','Kavre Branch', 'PES Kav', '06/06/1989', 'Banepa', 'Kavre','Bagmati','Nepal','00977','4112387','4112442','info@planetearthsolution.com','http://planetearthsolution.com','0','0',(SELECT office_id FROM office.offices WHERE office_code='PES');


/*******************************************************************
	RETURNS MINI OFFICE TABLE
*******************************************************************/

CREATE TYPE office.office_type AS
(
	office_id	integer_strict,
	office_code varchar(12),
	office_name varchar(150),
	address text
);

CREATE FUNCTION office.get_offices()
RETURNS setof office.office_type
AS
$$
DECLARE "@record" office.office_type%rowtype;
BEGIN
	FOR "@record" IN SELECT office_id, office_code,office_name,street || ' ' || city AS Address FROM office.offices WHERE parent_office_id IS NOT NULL
	LOOP
		RETURN NEXT "@record";
	END LOOP;

	IF NOT FOUND THEN
		FOR "@record" IN SELECT office_id, office_code,office_name,street || ' ' || city AS Address FROM office.offices WHERE parent_office_id IS NULL
		LOOP
			RETURN NEXT "@record";
		END LOOP;
	END IF;

	RETURN;
END
$$
LANGUAGE plpgsql;


CREATE FUNCTION office.get_office_name_by_id(office_id integer_strict)
RETURNS text
AS
$$
BEGIN
	RETURN
	(
		SELECT office.offices.office_name FROM office.offices
		WHERE office.offices.office_id=$1
	);
END
$$
LANGUAGE plpgsql;

CREATE TABLE office.departments
(
	department_id SERIAL  NOT NULL PRIMARY KEY,
	department_code varchar(12) NOT NULL,
	department_name varchar(50) NOT NULL
);


CREATE UNIQUE INDEX departments_department_code_uix
ON office.departments(UPPER(department_code));

CREATE UNIQUE INDEX departments_department_name_uix
ON office.departments(UPPER(department_name));


INSERT INTO office.departments(department_code, department_name)
SELECT 'SAL', 'Sales & Billing' UNION ALL
SELECT 'MKT', 'Marketing & Promotion' UNION ALL
SELECT 'SUP', 'Support' UNION ALL
SELECT 'CC', 'Customer Care';


CREATE TABLE office.roles
(
	role_id SERIAL  NOT NULL PRIMARY KEY,
	role_code varchar(12) NOT NULL,
	role_name varchar(50) NOT NULL
);


CREATE UNIQUE INDEX roles_role_code_uix
ON office.roles(UPPER(role_code));

CREATE UNIQUE INDEX roles_role_name_uix
ON office.roles(UPPER(role_name));

INSERT INTO office.roles(role_code,role_name)
SELECT 'SYST', 'System' UNION ALL
SELECT 'ADMN', 'Administrators' UNION ALL
SELECT 'USER', 'Users' UNION ALL
SELECT 'EXEC', 'Executive' UNION ALL
SELECT 'MNGR', 'Manager' UNION ALL
SELECT 'SALE', 'Sales' UNION ALL
SELECT 'MARK', 'Marketing' UNION ALL
SELECT 'LEGL', 'Legal & Compliance' UNION ALL
SELECT 'FINC', 'Finance' UNION ALL
SELECT 'HUMR', 'Human Resources' UNION ALL
SELECT 'INFO', 'Information Technology' UNION ALL
SELECT 'CUST', 'Customer Service';


CREATE TABLE office.users
(
	user_id SERIAL NOT NULL PRIMARY KEY,
	role_id smallint NOT NULL REFERENCES office.roles(role_id),
	office_id integer NOT NULL REFERENCES office.offices(office_id),
	user_name varchar(50) NOT NULL,
	full_name varchar(100) NOT NULL,
	password text NOT NULL
);

CREATE INDEX users_role_id_inx
ON office.users(role_id);

CREATE INDEX users_office_id_inx
ON office.users(office_id);



CREATE FUNCTION office.get_office_id_by_user_id(user_id integer_strict)
RETURNS integer
AS
$$
BEGIN
	RETURN
	(
		SELECT office.users.office_id FROM office.users
		WHERE office.users.user_id=$1
	);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION office.get_office_id_by_office_code(office_code text)
RETURNS integer
AS
$$
BEGIN
	RETURN
	(
		SELECT office.offices.office_id FROM office.offices
		WHERE office.offices.office_code=$1
	);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION office.get_user_id_by_user_name(user_name text)
RETURNS integer
AS
$$
BEGIN
	RETURN
	(
		SELECT office.users.user_id FROM office.users
		WHERE office.users.user_name=$1
	);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION office.get_role_id_by_use_id(user_id integer_strict)
RETURNS integer
AS
$$
BEGIN
	RETURN
	(
		SELECT office.users.role_id FROM office.users
		WHERE office.users.user_id=$1
	);
END
$$
LANGUAGE plpgsql;


CREATE FUNCTION office.get_role_code_by_user_name(user_name text)
RETURNS text
AS
$$
BEGIN
	RETURN
	(
		SELECT office.roles.role_code FROM office.roles, office.users
		WHERE office.roles.role_id=office.users.role_id
		AND office.users.user_name=$1
	);
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION office.get_sys_user_id()
RETURNS integer
AS
$$
BEGIN
	RETURN
	(
		SELECT office.users.user_id 
		FROM office.roles, office.users
		WHERE office.roles.role_id = office.users.role_id
		AND office.roles.role_code='SYST' LIMIT 1
	);
END
$$
LANGUAGE plpgsql;


CREATE FUNCTION office.can_login(user_id integer_strict, office_id integer_strict)
RETURNS boolean
AS
$$
DECLARE "$office_id" integer;
BEGIN
	"$office_id":=office.get_office_id_by_user_id($1);

	IF $1 = office.get_sys_user_id() THEN
		RETURN false;
	END IF;

	IF $2="$office_id" THEN
		RETURN true;
	ELSE
		IF office.is_parent_office("$office_id",$2) THEN
			RETURN true;
		END IF;
	END IF;
	RETURN false;
END;
$$
LANGUAGE plpgsql;

CREATE FUNCTION office.create_user
(
	role_id integer_strict,
	office_id integer_strict,
	user_name text,
	password text,
	full_name text
)
RETURNS VOID
AS
$$
BEGIN
	INSERT INTO office.users(role_id,office_id,user_name,password, full_name)
	SELECT $1, $2, $3, $4,$5;
	RETURN;
END
$$
LANGUAGE plpgsql;



/*******************************************************************
	TODO: REMOVE THIS USER ON DEPLOYMENT
*******************************************************************/
SELECT office.create_user((SELECT role_id FROM office.roles WHERE role_code='ADMN'),(SELECT office_id FROM office.offices WHERE office_code='PES'),'binod','binod','Binod Nepal');


/*******************************************************************
	TODO: CREATE A TRIGGER IN OFFICE.OFFICES TO AUTOMATICALLY
	INSERT SYS USER AT THE PARENT LEVEL
*******************************************************************/
SELECT office.create_user((SELECT role_id FROM office.roles WHERE role_code='SYST'),(SELECT office_id FROM office.offices WHERE office_code='PES'),'sys','sys','System');


CREATE FUNCTION office.validate_login
(
	user_name text,
	password text
)
RETURNS boolean
AS
$$
BEGIN
	IF EXISTS(SELECT 1 FROM office.users WHERE office.users.user_name=$1 AND office.users.password=$2 AND office.users.role_id != (SELECT office.roles.role_id FROM office.roles WHERE office.roles.role_code='SYST')) THEN
		RETURN true;
	END IF;
	RETURN false;
END
$$
LANGUAGE plpgsql;



CREATE UNIQUE INDEX users_user_name_uix
ON office.users(UPPER(user_name));





CREATE TABLE audit.logins
(
	login_id BIGSERIAL NOT NULL PRIMARY KEY,
	user_id integer NOT NULL REFERENCES office.users(user_id),
	office_id integer NOT NULL REFERENCES office.offices(office_id),
	browser varchar(500) NOT NULL,
	ip_address varchar(50) NOT NULL,
	login_date_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(now()),
	remote_user varchar(50) NOT NULL
);

CREATE INDEX logins_user_id_inx
ON audit.logins(user_id);

CREATE INDEX logins_office_id_inx
ON audit.logins(office_id);




CREATE TABLE audit.failed_logins
(
	failed_login_id BIGSERIAL NOT NULL PRIMARY KEY,
	user_id integer NULL REFERENCES office.users(user_id),
	user_name varchar(50) NOT NULL,
	office_id integer NOT NULL REFERENCES office.offices(office_id),
	browser varchar(500) NOT NULL,
	ip_address varchar(50) NOT NULL,
	failed_date_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(now()),
	remote_user varchar(50) NOT NULL,
	details varchar(250) NULL
);

CREATE INDEX failed_logins_user_id_inx
ON audit.failed_logins(user_id);

CREATE INDEX failed_logins_office_id_inx
ON audit.failed_logins(office_id);



CREATE TABLE policy.lock_outs
(
	lock_out_id BIGSERIAL NOT NULL PRIMARY KEY,
	user_id integer NOT NULL REFERENCES office.users(user_id),
	lock_out_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(NOW()),
	lock_out_till TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(NOW() + '5 minutes'::interval)
);

CREATE INDEX lock_outs_user_id_inx
ON policy.lock_outs(user_id);



CREATE FUNCTION policy.perform_lock_out()
RETURNS TRIGGER
AS
$$
BEGIN
IF(
	SELECT COUNT(*) FROM audit.failed_logins
	WHERE audit.failed_logins.user_id=NEW.user_id
	AND audit.failed_logins.failed_date_time 
	BETWEEN NOW()-'5minutes'::interval 
	AND NOW())::integer>8 THEN
	INSERT INTO policy.lock_outs(user_id)SELECT NEW.user_id;
END IF;
RETURN NEW;
END
$$
LANGUAGE plpgsql;

CREATE FUNCTION policy.is_locked_out_till(user_id integer_strict)
RETURNS TIMESTAMP
AS
$$
BEGIN
	RETURN
	(
		SELECT MAX(policy.lock_outs.lock_out_till)::TIMESTAMP WITHOUT TIME ZONE FROM policy.lock_outs
		WHERE policy.lock_outs.user_id=$1
	);
END
$$
LANGUAGE plpgsql;




CREATE FUNCTION office.sign_in(office_id integer_strict,user_name text, Password text, browser text, ip_address text, remote_user text)
RETURNS integer
AS
$$
DECLARE "$user_id" integer;
 _LockOutTill TIMESTAMP;
BEGIN
	"$user_id":=office.get_user_id_by_user_name($2);

	IF "$user_id" IS NULL THEN
		INSERT INTO audit.failed_logins(user_name,browser,ip_address,remote_user,details)
		SELECT $2, $4, $5, $6, 'Invalid user name.';
	ELSE
		_LockOutTill:=policy.is_locked_out_till("$user_id");
		IF NOT ((_LockOutTill IS NOT NULL) AND (_LockOutTill>NOW())) THEN
			IF office.validate_login($2,$3) THEN
				IF office.can_login("$user_id",$1) THEN
					INSERT INTO audit.logins(office_id,user_id,browser,ip_address,remote_user)
					SELECT $1, "$user_id", $4, $5, $6;

					RETURN CAST(currval('audit.logins_login_id_seq') AS integer);
				ELSE
					INSERT INTO audit.failed_logins(office_id,user_id,user_name,browser,ip_address,remote_user,details)
					SELECT $1, "$user_id", $2, $4, $5, $6, 'User from ' || office.get_office_name_by_id(office.get_office_id_by_user_id("$user_id")) || ' cannot login to ' || office.get_office_name_by_id($1) || '.';
				END IF;
			ELSE
				INSERT INTO audit.failed_logins(office_id,user_id,user_name,browser,ip_address,remote_user,details)
				SELECT $1, "$user_id", $2, $4, $5, $6, 'Invalid login attempt.';
			END IF;
		END IF;
	END IF;

	RETURN 0;
END
$$
LANGUAGE plpgsql;



CREATE TABLE core.menus
(
	menu_id SERIAL NOT NULL PRIMARY KEY,
	menu_text varchar(250) NOT NULL,
	url varchar(250) NULL,
	menu_code varchar(12) NOT NULL,
	level smallint NOT NULL,
	parent_menu_id integer NULL REFERENCES core.menus(menu_id)
);

CREATE INDEX menus_parent_menu_id_inx
ON core.menus(parent_menu_id);

CREATE UNIQUE INDEX menus_menu_code_uix
ON core.menus(UPPER(menu_code));

CREATE FUNCTION core.get_menu_id(menu_code text)
RETURNS INTEGER
AS
$$
BEGIN
	RETURN
	(
		SELECT core.menus.menu_id
		FROM core.menus
		WHERE core.menus.menu_code=$1
	);
END
$$
LANGUAGE plpgsql;



CREATE FUNCTION core.get_root_parent_menu_id(text)
RETURNS int
AS
$$
	DECLARE retVal int;
BEGIN
	WITH RECURSIVE find_parent(menu_id_group, parent, parent_menu_id, recentness) AS
	(
			SELECT menu_id, menu_id, parent_menu_id, 0
			FROM core.menus
			WHERE url=$1
			UNION ALL
			SELECT fp.menu_id_group, i.menu_id, i.parent_menu_id, fp.recentness + 1
			FROM core.menus i
			JOIN find_parent fp ON i.menu_id = fp.parent_menu_id
	)

		SELECT parent INTO retVal
		FROM find_parent q 
		JOIN
		(
				SELECT menu_id_group, MAX(recentness) AS answer
				FROM find_parent
				GROUP BY menu_id_group 
		) AS ans ON q.menu_id_group = ans.menu_id_group AND q.recentness = ans.answer 
		ORDER BY q.menu_id_group;

	RETURN retVal;
END
$$
LANGUAGE plpgsql;


INSERT INTO core.menus(menu_text, url, menu_code, level)
SELECT 'Sales', '/Sales/Index.aspx', 'SA', 0 UNION ALL
SELECT 'Purchase', '/Purchase/Index.aspx', 'PU', 0 UNION ALL
SELECT 'Products & Items', '/Items/Index.aspx', 'ITM', 0 UNION ALL
SELECT 'Finance', '/Finance/Index.aspx', 'FI', 0 UNION ALL
SELECT 'CRM', '/CRM/Index.aspx', 'CRM', 0 UNION ALL
SELECT 'Setup Paramters', '/Setup/Index.aspx', 'SE', 0 UNION ALL
SELECT 'POS', '/POS/Index.aspx', 'POS', 0 UNION ALL
SELECT 'Account', '/Account/Index.aspx', 'AC', 0;


INSERT INTO core.menus(menu_text, url, menu_code, level, parent_menu_id)
SELECT 'Sales & Quotation', NULL, 'SAQ', 1, core.get_menu_id('SA')
UNION ALL SELECT 'Direct Sales', '/Sales/DirectSales.aspx', 'DRS', 2, core.get_menu_id('SAQ')
UNION ALL SELECT 'Sales Quotation', '/Sales/Quotation.aspx', 'SQ', 2, core.get_menu_id('SAQ')
UNION ALL SELECT 'Sales Order', '/Sales/Order.aspx', 'SO', 2, core.get_menu_id('SAQ')
UNION ALL SELECT 'Delivery for Sales Order', '/Sales/Delivery.aspx', 'DSO', 2, core.get_menu_id('SAQ')
UNION ALL SELECT 'Invoice for Sales Delivery', '/Sales/Invoice.aspx', 'ISD', 2, core.get_menu_id('SAQ')
UNION ALL SELECT 'Receipt from Customer', '/Sales/Receipt.aspx', 'RFC', 2, core.get_menu_id('SAQ')
UNION ALL SELECT 'Sales Return', '/Sales/Return.aspx', 'SR', 2, core.get_menu_id('SAQ')
UNION ALL SELECT 'Setup & Maintenance', NULL, 'SSM', 1, core.get_menu_id('SA')
UNION ALL SELECT 'Customer Accounts', '/Sales/Setup/Customers.aspx', 'CA', 2, core.get_menu_id('SSM')
UNION ALL SELECT 'Customer Types', '/Sales/Setup/CustomerTypes.aspx', 'CT', 2, core.get_menu_id('SSM')
UNION ALL SELECT 'Bonus Slab for Agents', '/Sales/Setup/AgentBonusSlabs.aspx', 'ABS', 2, core.get_menu_id('SSM')
UNION ALL SELECT 'Bonus Slab Details', '/Sales/Setup/AgentBonusSlabDetails.aspx', 'BSD', 2, core.get_menu_id('SSM')
UNION ALL SELECT 'Sales Agents', '/Sales/Setup/Agents.aspx', 'SSA', 2, core.get_menu_id('SSM')
UNION ALL SELECT 'Bonus Slab Assignment', '/Sales/Setup/BonusSlabAssignment.aspx', 'BSA', 2, core.get_menu_id('SSM')
UNION ALL SELECT 'Cashier Management', NULL, 'CM', 1, core.get_menu_id('POS')
UNION ALL SELECT 'Assign Cashier', '/POS/AssignCashier.aspx', 'ASC', 2, core.get_menu_id('CM')
UNION ALL SELECT 'POS Setup', NULL, 'POSS', 1, core.get_menu_id('POS')
UNION ALL SELECT 'Store Types', '/POS/Setup/StoreTypes.aspx', 'STT', 2, core.get_menu_id('POSS')
UNION ALL SELECT 'Stores', '/POS/Setup/Stores.aspx', 'STO', 2, core.get_menu_id('POSS')
UNION ALL SELECT 'Purchase & Quotation', NULL, 'PUQ', 1, core.get_menu_id('PU')
UNION ALL SELECT 'Direct Purchase', '/Purchase/DirectPurchase.aspx', 'DRP', 2, core.get_menu_id('PUQ')
UNION ALL SELECT 'Purchase Order', '/Purchase/Order.aspx', 'PO', 2, core.get_menu_id('PUQ')
UNION ALL SELECT 'GRN against PO', '/Purchase/GRN.aspx', 'GRN', 2, core.get_menu_id('PUQ')
UNION ALL SELECT 'Purchase Invoice Against GRN', '/Purchase/Invoice.aspx', 'PAY', 2, core.get_menu_id('PUQ')
UNION ALL SELECT 'Payment to Supplier', '/Purchase/Payment.aspx', 'PAS', 2, core.get_menu_id('PUQ')
UNION ALL SELECT 'Purchase Return', '/Purchase/Return.aspx', 'PR', 2, core.get_menu_id('PUQ')
UNION ALL SELECT 'Setup & Maintenance', NULL, 'PSM', 1, core.get_menu_id('PU')
UNION ALL SELECT 'Supplier Accounts', '/Purchase/Setup/Suppliers.aspx', 'SUA', 2, core.get_menu_id('PSM')
UNION ALL SELECT 'Inventory Movements', NULL, 'IIM', 1, core.get_menu_id('ITM')
UNION ALL SELECT 'Stock Transfer Journal', '/Items/Transfer.aspx', 'STJ', 2, core.get_menu_id('IIM')
UNION ALL SELECT 'Stock Adjustments', '/Items/Adjustment.aspx', 'STA', 2, core.get_menu_id('IIM')
UNION ALL SELECT 'Setup & Maintenance', NULL, 'ISM', 1, core.get_menu_id('ITM')
UNION ALL SELECT 'Stock Items', '/Items/Setup/Items.aspx', 'SSI', 2, core.get_menu_id('ISM')
UNION ALL SELECT 'Item Groups', '/Items/Setup/ItemGroups.aspx', 'SSG', 2, core.get_menu_id('ISM')
UNION ALL SELECT 'Brands', '/Items/Setup/Brands.aspx', 'SSB', 2, core.get_menu_id('ISM')
UNION ALL SELECT 'Units of Measure', '/Items/Setup/UOM.aspx', 'UOM', 2, core.get_menu_id('ISM')
UNION ALL SELECT 'Compound Units of Measure', '/Items/Setup/CUOM.aspx', 'CUOM', 2, core.get_menu_id('ISM')
UNION ALL SELECT 'Shipper Information', '/Items/Setup/Shipper.aspx', 'SHI', 2, core.get_menu_id('ISM')
UNION ALL SELECT 'Transactions & Templates', NULL, 'FTT', 1, core.get_menu_id('FI')
UNION ALL SELECT 'Journal Voucher Entry', '/Finance/JournalVoucher.aspx', 'JVN', 2, core.get_menu_id('FTT')
UNION ALL SELECT 'Template Transaction', '/Finance/TemplateTransaction.aspx', 'TTR', 2, core.get_menu_id('FTT')
UNION ALL SELECT 'Standing Instructions', '/Finance/StandingInstructions.aspx', 'STN', 2, core.get_menu_id('FTT')
UNION ALL SELECT 'Update Exchange Rates', '/Finance/UpdateExchangeRates.aspx', 'UER', 2, core.get_menu_id('FTT')
UNION ALL SELECT 'Reconcile Bank Account', '/Finance/BankReconcilation.aspx', 'RBA', 2, core.get_menu_id('FTT')
UNION ALL SELECT 'Voucher Verification', '/Finance/VoucherVerification.aspx', 'FVV', 2, core.get_menu_id('FTT')
UNION ALL SELECT 'Transaction Document Manager', '/Finance/TransactionDocumentManager.aspx', 'FTDM', 2, core.get_menu_id('FTT')
UNION ALL SELECT 'Setup & Maintenance', NULL, 'FSM', 1, core.get_menu_id('FI')
UNION ALL SELECT 'Chart of Accounts', '/Finance/Setup/COA.aspx', 'COA', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Currency Management', '/Finance/Setup/Currencies.aspx', 'CUR', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Cash & Bank Accounts', '/Finance/Setup/CashBankAccounts.aspx', 'CBA', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Product GL Mapping', '/Finance/Setup/ProductGLMapping.aspx', 'PGM', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Budgets & Targets', '/Finance/Setup/BudgetAndTarget.aspx', 'BT', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Ageing Slabs', '/Finance/Setup/AgeingSlabs.aspx', 'AGS', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Tax Types', '/Finance/Setup/TaxTypes.aspx', 'TTY', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Tax Setup', '/Finance/Setup/TaxSetup.aspx', 'TS', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Tax Form', '/Finance/Setup/TaxForms.aspx', 'TF', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Tax Form Details', '/Finance/Setup/TaxFormDetails.aspx', 'TFD', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'Cost Centers', '/Finance/Setup/CostCenters.aspx', 'CC', 2, core.get_menu_id('FSM')
UNION ALL SELECT 'CRM Main', NULL, 'CRMM', 1, core.get_menu_id('CRM')
UNION ALL SELECT 'Add a New Lead', '/CRM/Lead.aspx', 'CRML', 2, core.get_menu_id('CRMM')
UNION ALL SELECT 'Add a New Opportunity', '/CRM/Opportunity.aspx', 'CRMO', 2, core.get_menu_id('CRMM')
UNION ALL SELECT 'Convert Lead to Opportunity', '/CRM/ConvertLeadToOpportunity.aspx', 'CRMC', 2, core.get_menu_id('CRMM')
UNION ALL SELECT 'Lead Followup', '/CRM/LeadFollowup.aspx', 'CRMFL', 2, core.get_menu_id('CRMM')
UNION ALL SELECT 'Opportunity Followup', '/CRM/OpportunityFollowup.aspx', 'CRMFO', 2, core.get_menu_id('CRMM')
UNION ALL SELECT 'Setup & Maintenance', NULL, 'CSM', 1, core.get_menu_id('CRM')
UNION ALL SELECT 'Lead Sources Setup', '/CRM/Setup/LeadSources.aspx', 'CRMLS', 2, core.get_menu_id('CSM')
UNION ALL SELECT 'Lead Status Setup', '/CRM/Setup/LeadStatuses.aspx', 'CRMLST', 2, core.get_menu_id('CSM')
UNION ALL SELECT 'Opportunity Stages Setup', '/CRM/Setup/OpportunityStages.aspx', 'CRMOS', 2, core.get_menu_id('CSM')
UNION ALL SELECT 'Office Setup', NULL, 'SOS', 1, core.get_menu_id('SE')
UNION ALL SELECT 'Office & Branch Setups', '/Setup/Offices.aspx', 'SOB', 2, core.get_menu_id('SOS')
UNION ALL SELECT 'Department Setup', '/Setup/Departments.aspx', 'SDS', 2, core.get_menu_id('SOS')
UNION ALL SELECT 'Role Management', '/Setup/Roles.aspx', 'SRM', 2, core.get_menu_id('SOS')
UNION ALL SELECT 'User Management', '/Setup/Users.aspx', 'SUM', 2, core.get_menu_id('SOS')
UNION ALL SELECT 'Frequency & Fiscal Year Management', '/Setup/Frequency.aspx', 'SFY', 2, core.get_menu_id('SOS')
UNION ALL SELECT 'Cash Repository Setup', '/Setup/CashRepositories.aspx', 'SCR', 2, core.get_menu_id('SOS')
UNION ALL SELECT 'Counter Setup', '/Setup/Counters.aspx', 'SCS', 2, core.get_menu_id('SOS')
UNION ALL SELECT 'Policy Management', NULL, 'SPM', 1, core.get_menu_id('SE')
UNION ALL SELECT 'Voucher Verification Policy', '/Setup/Policy/VoucherVerification.aspx', 'SVV', 2, core.get_menu_id('SPM')
UNION ALL SELECT 'Automatic Verification Policy', '/Setup/Policy/AutoVerification.aspx', 'SAV', 2, core.get_menu_id('SPM')
UNION ALL SELECT 'Menu Access Policy', '/Setup/Policy/MenuAccess.aspx', 'SMA', 2, core.get_menu_id('SPM')
UNION ALL SELECT 'GL Access Policy', '/Setup/Policy/GLAccess.aspx', 'SAP', 2, core.get_menu_id('SPM')
UNION ALL SELECT 'Store Policy', '/Setup/Policy/Store.aspx', 'SSP', 2, core.get_menu_id('SPM')
UNION ALL SELECT 'Admin Tools', NULL, 'SAT', 1, core.get_menu_id('SE')
UNION ALL SELECT 'SQL Query Tool', '/Setup/Admin/Query.aspx', 'SQL', 2, core.get_menu_id('SAT')
UNION ALL SELECT 'Backup Database', '/Setup/Admin/Backup.aspx', 'BAK', 2, core.get_menu_id('SAT')
UNION ALL SELECT 'Restore Database', '/Setup/Admin/Restore.aspx', 'RES', 2, core.get_menu_id('SAT')
UNION ALL SELECT 'Change User Password', '/Setup/Admin/ChangePassword.aspx', 'PWD', 2, core.get_menu_id('SAT')
UNION ALL SELECT 'New Company', '/Setup/Admin/NewCompany.aspx', 'NEW', 2, core.get_menu_id('SAT')
UNION ALL SELECT 'General', NULL, 'AGEN', 1, core.get_menu_id('AC')
UNION ALL SELECT 'Sign Out', '/Acount/SignOut.aspx', 'SOFF', 2, core.get_menu_id('AGEN')
UNION ALL SELECT 'Change Password', '/Acount/ChangePassword.aspx', 'PASS', 2, core.get_menu_id('AGEN');



CREATE VIEW office.user_view
AS
SELECT 
  users.user_id, 
  roles.role_code || ' (' || roles.role_name || ')' AS role, 
	office.offices.office_id,
  offices.office_code || ' (' || offices.office_name || ')' AS office, 
  users.user_name, 
  users.full_name
FROM 
  office.users, 
  office.roles, 
  office.offices
WHERE 
  users.role_id = roles.role_id AND
  users.office_id = offices.office_id;


CREATE OR REPLACE VIEW office.role_view
AS
SELECT 
  roles.role_id, 
  roles.role_code, 
  roles.role_name
FROM 
  office.roles;


CREATE VIEW core.relationship_view
AS
SELECT
	tc.table_schema,
	tc.table_name,
	kcu.column_name,
	ccu.table_schema AS references_schema,
	ccu.table_name AS references_table,
	ccu.column_name AS references_field  
FROM
	information_schema.table_constraints tc  
LEFT JOIN
	information_schema.key_column_usage kcu  
		ON tc.constraint_catalog = kcu.constraint_catalog  
		AND tc.constraint_schema = kcu.constraint_schema  
		AND tc.constraint_name = kcu.constraint_name  
LEFT JOIN
	information_schema.referential_constraints rc  
		ON tc.constraint_catalog = rc.constraint_catalog  
		AND tc.constraint_schema = rc.constraint_schema  
		AND tc.constraint_name = rc.constraint_name    
LEFT JOIN
	information_schema.constraint_column_usage ccu  
		ON rc.unique_constraint_catalog = ccu.constraint_catalog  
		AND rc.unique_constraint_schema = ccu.constraint_schema  
		AND rc.unique_constraint_name = ccu.constraint_name  
WHERE
	lower(tc.constraint_type) in ('foreign key');

CREATE VIEW core.mixerp_table_view
AS
SELECT information_schema.columns.table_schema, 
       information_schema.columns.table_name, 
       information_schema.columns.column_name, 
       references_schema, 
       references_table, 
       references_field, 
       ordinal_position,
	   is_nullable,
       column_default, 
       data_type, 
       character_maximum_length, 
       character_octet_length, 
       numeric_precision, 
       numeric_precision_radix, 
       numeric_scale, 
       datetime_precision, 
       udt_name 
FROM   information_schema.columns 
       LEFT JOIN core.relationship_view 
              ON information_schema.columns.table_schema = 
                 core.relationship_view.table_schema 
                 AND information_schema.columns.table_name = 
                     core.relationship_view.table_name 
                 AND information_schema.columns.column_name = 
                     core.relationship_view.column_name 
WHERE  information_schema.columns.table_schema 
NOT IN 
	( 
		'pg_catalog', 'information_schema'
	);
    
    
CREATE TABLE core.frequencies
(
	frequency_id SERIAL NOT NULL PRIMARY KEY,
	frequency_code varchar(12) NOT NULL,
	frequency_name varchar(50) NOT NULL
);


CREATE UNIQUE INDEX frequencies_frequency_code_uix
ON core.frequencies(UPPER(frequency_code));

CREATE UNIQUE INDEX frequencies_frequency_name_uix
ON core.frequencies(UPPER(frequency_name));

INSERT INTO core.frequencies
--SELECT 1, 'EOD', 'End of Day' UNION ALL
--End of day is not required.
SELECT 2, 'EOM', 'End of Month' UNION ALL
SELECT 3, 'EOQ', 'End of Quarter' UNION ALL
SELECT 4, 'EOH', 'End of Half' UNION ALL
SELECT 5, 'EOY', 'End of Year';


CREATE TABLE core.frequency_setups
(
	frequency_setup_id SERIAL NOT NULL PRIMARY KEY,
	value_date date NOT NULL UNIQUE,
	frequency_id integer NOT NULL REFERENCES core.frequencies(frequency_id)
);

--TODO: Validation constraints for core.frequency_setups

CREATE TABLE core.units
(
	unit_id SERIAL NOT NULL PRIMARY KEY,
	unit_code varchar(12) NOT NULL,
	unit_name varchar(50) NOT NULL
);

CREATE UNIQUE INDEX units_unit_code_uix
ON core.units(UPPER(unit_code));

CREATE UNIQUE INDEX "units_unit_name_uix"
ON core.units(UPPER(unit_name));

CREATE TABLE core.compound_units
(
	compound_unit_id SERIAL NOT NULL PRIMARY KEY,
	base_unit_id integer NOT NULL REFERENCES core.units(unit_id),
	compare_unit_id integer NOT NULL REFERENCES core.units(unit_id),
	value smallint NOT NULL,
	CONSTRAINT compound_units_check CHECK(base_unit_id != compare_unit_id)
);

CREATE UNIQUE INDEX compound_units_info_uix
ON core.compound_units(base_unit_id, compare_unit_id);


CREATE TABLE core.account_masters
(
    account_master_id SERIAL NOT NULL PRIMARY KEY,
    account_master_code varchar(3) NOT NULL,
    account_master_name varchar(40) NOT NULL	
);

CREATE UNIQUE INDEX account_master_code_uix
ON core.account_masters(UPPER(account_master_code));

CREATE UNIQUE INDEX account_master_name_uix
ON core.account_masters(UPPER(account_master_name));



CREATE TABLE core.accounts
(
    account_id    SERIAL NOT NULL PRIMARY KEY,
    account_master_id  INTEGER NOT NULL REFERENCES core.account_masters(account_master_id),
    account_code  VARCHAR(12) NOT NULL,
    account_name  VARCHAR(100) NOT NULL,
    description      VARCHAR(200) NULL,
    sys_type BOOLEAN NOT NULL DEFAULT(FALSE),
    parent_account_id INTEGER NULL REFERENCES core.accounts(account_id)
);


CREATE UNIQUE INDEX accountsCode_uix
ON core.accounts(UPPER(account_code));

CREATE UNIQUE INDEX accounts_Name_uix
ON core.accounts(UPPER(account_name));

CREATE INDEX accounts_parent_inx
ON core.accounts(parent_account_id);

CREATE INDEX accountsMasterId_inx
ON core.accounts(account_master_id);


DELETE FROM core.accounts;DELETE FROM core.account_masters;
INSERT INTO core.account_masters(account_master_code, account_master_name) SELECT 'BSA', 'Balance Sheet A/C';
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10000', 'Assets', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Balance Sheet A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10001', 'Current Assets', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10100', 'Cash at Bank A/C', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10110', 'Regular Checking Account', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cash at Bank A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10120', 'Payroll Checking Account', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cash at Bank A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10130', 'Savings Account', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cash at Bank A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10140', 'Special Account', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cash at Bank A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10200', 'Cash in Hand A/C', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10210', 'Cash Float', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cash in Hand A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10220', 'Petty Cash A/C', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cash in Hand A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10300', 'Investments', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10310', 'Short Term Investment', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Investments');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10320', 'Other Investments', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Investments');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10321', 'Investments-Money Market', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Investments');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10322', 'Bank Deposit Contract (Fixed Deposit)', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Investments');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10323', 'Investments-Certificates of Deposit', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Investments');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10400', 'Accounts Receivable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10500', 'Other Receivables', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10600', 'Allowance for Doubtful Accounts', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10700', 'Inventory', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10720', 'Raw Materials Inventory', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Inventory');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10730', 'Supplies Inventory', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Inventory');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10740', 'Work in Progress Inventory', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Inventory');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10750', 'Finished Goods Inventory', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Inventory');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10800', 'Prepaid Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '10900', 'Employee Advances', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '11000', 'Notes Receivable-Current', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '11100', 'Prepaid Interest', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '11200', 'Accrued Incomes (Assets)', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '11300', 'Other Debtors', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '11400', 'Other Current Assets', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12001', 'Noncurrent Assets', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12100', 'Furniture and Fixtures', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12200', 'Plants & Equipments', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12300', 'Rental Property', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12400', 'Vehicles', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12500', 'Intangibles', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12600', 'Other Depreciable Properties', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12700', 'Leasehold Improvements', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12800', 'Buildings', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '12900', 'Building Improvements', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13000', 'Interior Decorations', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13100', 'Land', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13200', 'Long Term Investments', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13300', 'Trade Debtors', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13400', 'Rental Debtors', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13500', 'Staff Debtors', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13600', 'Other Noncurrent Debtors', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13700', 'Other Financial Assets', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13710', 'Deposits Held', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Financial Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13800', 'Accumulated Depreciations', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13810', 'Accumulated Depreciation-Furniture and Fixtures', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13820', 'Accumulated Depreciation-Equipment', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13830', 'Accumulated Depreciation-Vehicles', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13840', 'Accumulated Depreciation-Other Depreciable Properties', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13850', 'Accumulated Depreciation-Leasehold', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13860', 'Accumulated Depreciation-Buildings', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13870', 'Accumulated Depreciation-Building Improvements', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '13880', 'Accumulated Depreciation-Interior Decorations', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Accumulated Depreciations');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '14001', 'Other Assets', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '14100', 'Other Assets-Deposits', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '14200', 'Other Assets-Organization Costs', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '14300', 'Other Assets-Accumulated Amortization-Organization Costs', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '14400', 'Notes Receivable-Non-current', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '14500', 'Other Non-current Assets', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '14600', 'Nonfinancial Assets', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Assets');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20000', 'Liabilities', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Balance Sheet A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20001', 'Current Liabilities', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20100', 'Accounts Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20200', 'Accrued Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20300', 'Wages Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20400', 'Deductions Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20500', 'Health Insurance Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20600', 'Superannutation Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20700', 'Tax Payables', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20710', 'Sales Tax Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20720', 'Federal Payroll Taxes Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20730', 'FUTA Tax Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20740', 'State Payroll Taxes Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20750', 'SUTA Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20760', 'Local Payroll Taxes Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20770', 'Income Taxes Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20780', 'Other Taxes Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Tax Payables');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20800', 'Employee Benefits Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20810', 'Provision for Annual Leave', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefits Payable');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20820', 'Provision for Long Service Leave', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefits Payable');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20830', 'Provision for Personal Leave', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefits Payable');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20840', 'Provision for Health Leave', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefits Payable');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '20900', 'Current Portion of Long-term Debt', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21000', 'Advance Incomes', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21010', 'Advance Sales Income', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Advance Incomes');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21020', 'Grant Received in Advance', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Advance Incomes');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21100', 'Deposits from Customers', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21200', 'Other Current Liabilities', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21210', 'Short Term Loan Payables', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21220', 'Short Term Hirepurchase Payables', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21230', 'Short Term Lease Liability', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '21240', 'Grants Repayable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Current Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24001', 'Noncurrent Liabilities', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24100', 'Notes Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24200', 'Land Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24300', 'Equipment Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24400', 'Vehicles Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24500', 'Lease Liability', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24600', 'Loan Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24700', 'Hirepurchase Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24800', 'Bank Loans Payable', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '24900', 'Deferred Revenue', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '25000', 'Other Long-term Liabilities', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Noncurrent Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '25010', 'Long Term Employee Benefit Provision', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Other Long-term Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28001', 'Equity', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Liabilities');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28100', 'Stated Capital', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Equity');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28110', 'Founder Capital', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Stated Capital');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28120', 'Promoter Capital', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Stated Capital');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28130', 'Member Capital', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Stated Capital');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28200', 'Capital Surplus', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Equity');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28210', 'Share Premium', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Capital Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28220', 'Capital Redemption Reserves', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Capital Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28230', 'Statutory Reserves', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Capital Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28240', 'Asset Revaluation Reserves', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Capital Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28250', 'Exchange Rate Fluctuation Reserves', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Capital Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28260', 'Capital Reserves Arising From Merger', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Capital Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28270', 'Capital Reserves Arising From Acuisition', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Capital Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28300', 'Retained Surplus', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Equity');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28310', 'Accumulated Profits', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Retained Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28320', 'Accumulated Losses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Retained Surplus');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28400', 'Treasury Stock', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Equity');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28500', 'Current Year Surplus', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Equity');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28600', 'General Reserves', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Equity');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '28700', 'Other Reserves', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Equity');
INSERT INTO core.account_masters(account_master_code, account_master_name) SELECT 'PLA', 'Profit and Loss A/C';
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30000', 'Revenues', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Profit and Loss A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30100', 'Sales A/C', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Revenues');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30200', 'Interest Income', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Revenues');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30300', 'Other Income', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Revenues');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30400', 'Finance Charge Income', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Revenues');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30500', 'Shipping Charges Reimbursed', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Revenues');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30600', 'Sales Returns and Allowances', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Revenues');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '30700', 'Sales Discounts', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Revenues');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40000', 'Expenses', TRUE, (SELECT account_id FROM core.accounts WHERE account_name='Profit and Loss A/C');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40100', 'Purchase A/C', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40200', 'Cost of GoodS Sold', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40205', 'Product Cost', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40210', 'Raw Material Purchases', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40215', 'Direct Labor Costs', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40220', 'Indirect Labor Costs', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40225', 'Heat and Power', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40230', 'Commissions', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40235', 'Miscellaneous Factory Costs', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40240', 'Cost of Goods Sold-Salaries and Wages', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40245', 'Cost of Goods Sold-Contract Labor', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40250', 'Cost of Goods Sold-Freight', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40255', 'Cost of Goods Sold-Other', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40260', 'Inventory Adjustments', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40265', 'Purchase Returns and Allowances', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40270', 'Purchase Discounts', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Cost of GoodS Sold');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40300', 'General Purchase Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40400', 'Advertising Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40500', 'Amortization Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40600', 'Auto Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40700', 'Bad Debt Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40800', 'Bank Fees', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '40900', 'Cash Over and Short', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41000', 'Charitable Contributions Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41100', 'Commissions and Fees Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41200', 'Depreciation Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41300', 'Dues and Subscriptions Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41400', 'Employee Benefit Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41410', 'Employee Benefit Expenses-Health Insurance', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefit Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41420', 'Employee Benefit Expenses-Pension Plans', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefit Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41430', 'Employee Benefit Expenses-Profit Sharing Plan', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefit Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41440', 'Employee Benefit Expenses-Other', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Employee Benefit Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41500', 'Freight Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41600', 'Gifts Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41700', 'Income Tax Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41710', 'Income Tax Expenses-Federal', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Income Tax Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41720', 'Income Tax Expenses-State', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Income Tax Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41730', 'Income Tax Expenses-Local', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Income Tax Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41800', 'Insurance Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41810', 'Insurance Expenses-Product Liability', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Insurance Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41820', 'Insurance Expenses-Vehicle', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Insurance Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '41900', 'Interest Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42000', 'Laundry and Dry Cleaning Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42100', 'Legal and Professional Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42200', 'Licenses Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42300', 'Loss on NSF Checks', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42400', 'Maintenance Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42500', 'Meals and Entertainment Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42600', 'Office Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42700', 'Payroll Tax Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42800', 'Penalties and Fines Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '42900', 'Other Taxe Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43000', 'Postage Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43100', 'Rent or Lease Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43200', 'Repair and Maintenance Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43210', 'Repair and Maintenance Expenses-Office', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Repair and Maintenance Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43220', 'Repair and Maintenance Expenses-Vehicle', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Repair and Maintenance Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43300', 'Supplies Expenses-Office', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43400', 'Telephone Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43500', 'Training Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43600', 'Travel Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43700', 'Salary Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43800', 'Wages Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '43900', 'Utilities Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '44000', 'Other Expenses', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.accounts(account_master_id,account_code,account_name, sys_type, parent_account_id) SELECT (SELECT account_master_id FROM core.account_masters WHERE account_master_code='BSA'), '44100', 'Gain/Loss on Sale of Assets', FALSE, (SELECT account_id FROM core.accounts WHERE account_name='Expenses');
INSERT INTO core.account_masters(account_master_code, account_master_name) SELECT 'OBS', 'Off Balance Sheet A/C';

CREATE VIEW core.accounts_view
AS
SELECT
	core.accounts.account_id,
	core.accounts.account_code,
	core.accounts.account_name,
	core.accounts.description,
	core.accounts.sys_type,
	core.accounts.parent_account_id,
	parent_accounts.account_code AS parent_account_code,
	parent_accounts.account_name AS parent_account_name,
	core.account_masters.account_master_id,
	core.account_masters.account_master_code,
	core.account_masters.account_master_name
FROM
	core.account_masters
	INNER JOIN core.accounts 
	ON core.account_masters.account_master_id = core.accounts.account_master_id
	LEFT OUTER JOIN core.accounts AS parent_accounts 
	ON core.accounts.parent_account_id = parent_accounts.account_id;


CREATE TABLE core.cash_bank_accounts
(
	account_id integer NOT NULL CONSTRAINT cash_bank_accounts_pk PRIMARY KEY
								CONSTRAINT cash_bank_accounts_accounts_fk REFERENCES core.accounts(account_id),
	maintained_by_user_id integer NOT NULL CONSTRAINT cash_bank_accounts_users_fk REFERENCES office.users(user_id),
	is_cash boolean NOT NULL,
	bank_name national character varying(128) NOT NULL,
	bank_branch national character varying(128) NOT NULL,
	bank_contact_number national character varying(128) NULL,
	bank_address text NULL,
	bank_account_code national character varying(128) NULL,
	bank_account_type national character varying(128) NULL,
	relationship_officer_name national character varying(128) NULL
);

--TODO: Index this table.

CREATE VIEW core.cash_bank_account_view
AS
SELECT
	core.accounts.account_id,
	core.accounts.account_code,
	core.accounts.account_name,
	core.cash_bank_accounts.is_cash,
	office.users.user_name AS maintained_by,
	core.cash_bank_accounts.bank_name,
	core.cash_bank_accounts.bank_branch,
	core.cash_bank_accounts.bank_contact_number,
	core.cash_bank_accounts.bank_address,
	core.cash_bank_accounts.bank_account_code,
	core.cash_bank_accounts.bank_account_type,
	core.cash_bank_accounts.relationship_officer_name AS relation_officer
FROM
	core.cash_bank_accounts
INNER JOIN core.accounts ON core.accounts.account_id = core.cash_bank_accounts.account_id
INNER JOIN office.users ON core.cash_bank_accounts.maintained_by_user_id = office.users.user_id;

CREATE TABLE core.agents
(
	agent_id SERIAL NOT NULL PRIMARY KEY,
	agent_code varchar(12) NOT NULL,
	agent_name varchar(100) NOT NULL,
	address varchar(100) NOT NULL,
	contact_number varchar(50) NOT NULL,
	commission_rate float_strict NOT NULL DEFAULT(0),
	account_id integer NOT NULL REFERENCES core.accounts(account_id)
);


CREATE UNIQUE INDEX agents_agent_name_uix
ON core.agents(UPPER(agent_name));


CREATE TABLE core.bonus_slabs
(
	bonus_slab_id SERIAL NOT NULL PRIMARY KEY,
	bonus_slab_code varchar(12) NOT NULL,
	bonus_slab_name varchar(50) NOT NULL,
	checking_frequency_id integer NOT NULL REFERENCES core.frequencies(frequency_id)
);

CREATE UNIQUE INDEX bonus_slabs_bonus_slab_code_uix
ON core.bonus_slabs(UPPER(bonus_slab_code));


CREATE UNIQUE INDEX bonus_slabs_bonus_slab_name_uix
ON core.bonus_slabs(UPPER(bonus_slab_name));

CREATE TABLE core.bonus_slab_details
(
	bonus_slab_detail_id SERIAL NOT NULL PRIMARY KEY,
	bonus_slab_id integer NOT NULL REFERENCES core.bonus_slabs(bonus_slab_id),
	amount_from money_strict NOT NULL,
	amount_to money_strict NOT NULL,
	bonus_rate float_strict NOT NULL,
	CONSTRAINT bonus_slab_details_amounts_chk CHECK(amount_to>amount_from)
);

CREATE TABLE core.agent_bonus_setups
(
	agent_bonus_setup_id SERIAL NOT NULL PRIMARY KEY,
	agent_id integer NOT NULL REFERENCES core.agents(agent_id),
	bonus_slab_id integer NOT NULL REFERENCES core.bonus_slabs(bonus_slab_id)
);

CREATE UNIQUE INDEX agent_bonus_setups_uix
ON core.agent_bonus_setups(agent_id,bonus_slab_id);


CREATE TABLE core.ageing_slabs
(
	ageing_slab_id SERIAL NOT NULL PRIMARY KEY,
	ageing_slab_name varchar(24) NOT NULL,
	from_days integer NOT NULL,
	to_days integer NOT NULL CHECK(to_days > 0)
);

CREATE UNIQUE INDEX ageing_slabs_ageing_slab_name_uix
ON core.ageing_slabs(UPPER(ageing_slab_name));

INSERT INTO core.ageing_slabs(ageing_slab_name,from_days,to_days)
SELECT 'SLAB 1',0, 30 UNION ALL
SELECT 'SLAB 2',31, 60 UNION ALL
SELECT 'SLAB 3',61, 90 UNION ALL
SELECT 'SLAB 4',91, 365 UNION ALL
SELECT 'SLAB 5',366, 999999;


CREATE TABLE core.customer_types
(
	customer_type_id serial NOT NULL PRIMARY KEY,
	customer_type_code customer_type NOT NULL DEFAULT('C'), 
	customer_type_name varchar(50) NOT NULL
);

INSERT INTO core.customer_types(customer_type_code, customer_type_name) SELECT 'A', 'Agent';
INSERT INTO core.customer_types(customer_type_code, customer_type_name) SELECT 'C', 'Customer';
INSERT INTO core.customer_types(customer_type_code, customer_type_name) SELECT 'D', 'Dealer';


CREATE TABLE core.customers
(
	customer_id BIGSERIAL NOT NULL PRIMARY KEY,
	customer_type_id smallint NOT NULL REFERENCES core.customer_types(customer_type_id),
	customer_code varchar(12) NULL,
	first_name varchar(50) NOT NULL,
	middle_name varchar(50) NULL,
	last_name varchar(50) NOT NULL,
	customer_name text NULL,
	date_of_birth date NULL,
	street varchar(50) NULL,
	city varchar(50) NULL,
	state varchar(50) NULL,
	country varchar(50) NULL,
	shipping_address varchar(250) NULL,
	phone varchar(24) NULL,
	fax varchar(24) NULL,
	cell varchar(24) NULL,
	email varchar(128) NULL,
	url varchar(50) NULL,
	contact_person varchar(50) NULL,
	contact_street varchar(50) NULL,
	contact_city varchar(50) NULL,
	contact_state varchar(50) NULL,
	contact_country varchar(50) NULL,
	contact_email varchar(128) NULL,
	contact_phone varchar(50) NULL,
	contact_cell varchar(50) NULL,
	pan_number varchar(50) NULL,
	sst_number varchar(50) NULL,
	cst_number varchar(50) NULL,
	allow_credit boolean NULL,
	maximum_credit_period smallint NULL,
	maximum_credit_amount money NULL,
	charge_interest boolean NULL,
	interest_rate float NULL,
	interest_compounding_frequency_id smallint NULL REFERENCES core.frequencies(frequency_id),
	account_id bigint NOT NULL REFERENCES core.accounts(account_id)
);


CREATE UNIQUE INDEX customers_customer_code_uix
ON core.customers(UPPER(customer_code));

/*******************************************************************
	GET UNIQUE EIGHT-TO-TEN DIGIT CUSTOMER CODE
	TO IDENTIFY A CUSTOMER.
	BASIC FORMULA:
		1. FIRST TWO LETTERS OF FIRST NAME
		2. FIRST LETTER OF MIDDLE NAME (IF AVAILABLE)
		3. FIRST TWO LETTERS OF LAST NAME
		4. CUSTOMER NUMBER
*******************************************************************/

CREATE OR REPLACE FUNCTION core.get_customer_code
(
	text, --first_name
	text, --Middle Name
	text  --Last Name
)
RETURNS text AS
$$
	DECLARE __customer_code TEXT;
BEGIN
	SELECT INTO 
		__customer_code 
			customer_code
	FROM
		core.customers
	WHERE
		customer_code LIKE 
			UPPER(left($1,2) ||
			CASE
				WHEN $2 IS NULL or $2 = '' 
				THEN left($3,3)
			ELSE 
				left($2,1) || left($3,2)
			END 
			|| '%')
	ORDER BY customer_code desc
	LIMIT 1;

	__customer_code :=
					UPPER
					(
						left($1,2)||
						CASE
							WHEN $2 IS NULL or $2 = '' 
							THEN left($3,3)
						ELSE 
							left($2,1)||left($3,2)
						END
					) 
					|| '-' ||
					CASE
						WHEN __customer_code IS NULL 
						THEN '0001'
					ELSE 
						to_char(CAST(right(__customer_code,4) AS integer)+1,'FM0000')
					END;
	RETURN __customer_code;
END;
$$
LANGUAGE 'plpgsql';


CREATE FUNCTION core.update_customer_code()
RETURNS trigger
AS
$$
BEGIN
	UPDATE core.customers
    SET 
		customer_code=core.get_customer_code(NEW.first_name, NEW.middle_name, NEW.last_name),
		customer_name= TRIM(NEW.last_name || ', ' || NEW.first_name || ' ' || COALESCE(NEW.middle_name, ''))
    WHERE core.customers.customer_id=NEW.customer_id;
    
    RETURN NEW;
END
$$
LANGUAGE plpgsql;



CREATE TRIGGER update_customer_code
AFTER INSERT
ON core.customers
FOR EACH ROW EXECUTE PROCEDURE core.update_customer_code();



CREATE TABLE core.brands
(
	brand_id SERIAL NOT NULL PRIMARY KEY,
	brand_code varchar(12) NOT NULL,
	brand_name varchar(150) NOT NULL
);

CREATE UNIQUE INDEX brands_brand_code_uix
ON core.brands(UPPER(brand_code));

CREATE UNIQUE INDEX brands_brand_name_uix
ON core.brands(UPPER(brand_name));



CREATE TABLE core.suppliers
(
	supplier_id BIGSERIAL NOT NULL PRIMARY KEY,
	supplier_code varchar(12) NOT NULL,
	first_name varchar(50) NOT NULL,
	middle_name varchar(50) NULL,
	last_name varchar(50) NOT NULL,
	supplier_name varchar(150) NOT NULL,
	street varchar(50) NULL,
	city varchar(50) NULL,
	state varchar(50) NULL,
	country varchar(50) NULL,
	phone varchar(50) NULL,
	fax varchar(50) NULL,
	cell varchar(50) NULL,
	email varchar(128) NULL,
	url varchar(50) NULL,
	contact_person varchar(50) NULL,
	contact_street varchar(50) NULL,
	contact_city varchar(50) NULL,
	contact_state varchar(50) NULL,
	contact_country varchar(50) NULL,
	contact_email varchar(128) NULL,
	contact_phone varchar(50) NULL,
	contact_cell varchar(50) NULL,
	factory_address varchar(250) NULL,
	pan_number varchar(50) NULL,
	sst_number varchar(50) NULL,
	cst_number varchar(50) NULL,
	account_id bigint NOT NULL REFERENCES core.accounts(account_id)
);


CREATE UNIQUE INDEX suppliers_supplier_code_uix
ON core.suppliers(UPPER(supplier_code));



/*******************************************************************
	GET UNIQUE EIGHT-TO-TEN DIGIT SUPPLIER CODE
	TO IDENTIFY A SUPPLIER.
	BASIC FORMULA:
		1. FIRST TWO LETTERS OF FIRST NAME
		2. FIRST LETTER OF MIDDLE NAME (IF AVAILABLE)
		3. FIRST TWO LETTERS OF LAST NAME
		4. SUPPLIER NUMBER
*******************************************************************/

CREATE OR REPLACE FUNCTION core.get_supplier_code
(
	text, --first_name
	text, --Middle Name
	text  --Last Name
)
RETURNS text AS
$$
	DECLARE __supplier_code TEXT;
BEGIN
	SELECT INTO 
		__supplier_code 
			supplier_code
	FROM
		core.suppliers
	WHERE
		supplier_code LIKE 
			UPPER(left($1,2) ||
			CASE
				WHEN $2 IS NULL or $2 = '' 
				THEN left($3,3)
			ELSE 
				left($2,1) || left($3,2)
			END 
			|| '%')
	ORDER BY supplier_code desc
	LIMIT 1;

	__supplier_code :=
					UPPER
					(
						left($1,2)||
						CASE
							WHEN $2 IS NULL or $2 = '' 
							THEN left($3,3)
						ELSE 
							left($2,1)||left($3,2)
						END
					) 
					|| '-' ||
					CASE
						WHEN __supplier_code IS NULL 
						THEN '0001'
					ELSE 
						to_char(CAST(right(__supplier_code,4) AS integer)+1,'FM0000')
					END;
	RETURN __supplier_code;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION core.update_supplier_code()
RETURNS trigger
AS
$$
BEGIN
	UPDATE core.suppliers
    SET 
		supplier_code=core.get_supplier_code(NEW.first_name, NEW.middle_name, NEW.last_name),
		supplier_name= TRIM(NEW.last_name || ', ' || NEW.first_name || ' ' || COALESCE(NEW.middle_name, ''))
    WHERE core.suppliers.supplier_id=NEW.supplier_id;
    
    RETURN NEW;
END
$$
LANGUAGE plpgsql;

CREATE TRIGGER update_supplier_code
AFTER INSERT
ON core.suppliers
FOR EACH ROW EXECUTE PROCEDURE core.update_supplier_code();


CREATE TABLE core.shippers
(
	shipper_id BIGSERIAL NOT NULL PRIMARY KEY,
	shipper_code varchar(12) NOT NULL,
	first_name varchar(50) NOT NULL,
	middle_name varchar(50) NULL,
	last_name varchar(50) NOT NULL,
	shipper_name varchar(150) NOT NULL,
	street varchar(50) NULL,
	city varchar(50) NULL,
	state varchar(50) NULL,
	country varchar(50) NULL,
	phone varchar(50) NULL,
	fax varchar(50) NULL,
	cell varchar(50) NULL,
	email varchar(128) NULL,
	url varchar(50) NULL,
	contact_person varchar(50) NULL,
	contact_street varchar(50) NULL,
	contact_city varchar(50) NULL,
	contact_state varchar(50) NULL,
	contact_country varchar(50) NULL,
	contact_email varchar(128) NULL,
	contact_phone varchar(50) NULL,
	contact_cell varchar(50) NULL,
	factory_address varchar(250) NULL,
	pan_number varchar(50) NULL,
	sst_number varchar(50) NULL,
	cst_number varchar(50) NULL,
	account_id bigint NOT NULL REFERENCES core.accounts(account_id)
);


CREATE UNIQUE INDEX shippers_shipper_code_uix
ON core.shippers(UPPER(shipper_code));



/*******************************************************************
	GET UNIQUE EIGHT-TO-TEN DIGIT shipper CODE
	TO IDENTIFY A shipper.
	BASIC FORMULA:
		1. FIRST TWO LETTERS OF FIRST NAME
		2. FIRST LETTER OF MIDDLE NAME (IF AVAILABLE)
		3. FIRST TWO LETTERS OF LAST NAME
		4. shipper NUMBER
*******************************************************************/

CREATE OR REPLACE FUNCTION core.get_shipper_code
(
	text, --first_name
	text, --Middle Name
	text  --Last Name
)
RETURNS text AS
$$
	DECLARE __shipper_code TEXT;
BEGIN
	SELECT INTO 
		__shipper_code 
			shipper_code
	FROM
		core.shippers
	WHERE
		shipper_code LIKE 
			UPPER(left($1,2) ||
			CASE
				WHEN $2 IS NULL or $2 = '' 
				THEN left($3,3)
			ELSE 
				left($2,1) || left($3,2)
			END 
			|| '%')
	ORDER BY shipper_code desc
	LIMIT 1;

	__shipper_code :=
					UPPER
					(
						left($1,2)||
						CASE
							WHEN $2 IS NULL or $2 = '' 
							THEN left($3,3)
						ELSE 
							left($2,1)||left($3,2)
						END
					) 
					|| '-' ||
					CASE
						WHEN __shipper_code IS NULL 
						THEN '0001'
					ELSE 
						to_char(CAST(right(__shipper_code,4) AS integer)+1,'FM0000')
					END;
	RETURN __shipper_code;
END;
$$
LANGUAGE 'plpgsql';

CREATE FUNCTION core.update_shipper_code()
RETURNS trigger
AS
$$
BEGIN
	UPDATE core.shippers
    SET 
		shipper_code=core.get_shipper_code(NEW.first_name, NEW.middle_name, NEW.last_name),
		shipper_name= TRIM(NEW.last_name || ', ' || NEW.first_name || ' ' || COALESCE(NEW.middle_name, ''))
    WHERE core.shippers.shipper_id=NEW.shipper_id;
    
    RETURN NEW;
END
$$
LANGUAGE plpgsql;

CREATE TRIGGER update_shipper_code
AFTER INSERT
ON core.shippers
FOR EACH ROW EXECUTE PROCEDURE core.update_shipper_code();


CREATE TABLE core.tax_types
(
	tax_type_id SERIAL  NOT NULL PRIMARY KEY,
	tax_type_code varchar(12) NOT NULL,
	tax_type_name varchar(50) NOT NULL
);

CREATE UNIQUE INDEX tax_types_tax_type_code_uix
ON core.tax_types(UPPER(tax_type_code));

CREATE UNIQUE INDEX tax_types_tax_type_name_uix
ON core.tax_types(UPPER(tax_type_name));

CREATE TABLE core.taxes
(
	tax_id SERIAL  NOT NULL PRIMARY KEY,
	tax_type_id smallint NOT NULL REFERENCES core.tax_types(tax_type_id),
	tax_code varchar(12) NOT NULL,
	tax_name varchar(50) NOT NULL,
	rate float NOT NULL,
	account_id integer NOT NULL REFERENCES core.accounts(account_id)
);


CREATE UNIQUE INDEX taxes_tax_code_uix
ON core.taxes(UPPER(tax_code));

CREATE UNIQUE INDEX taxes_tax_name_uix
ON core.taxes(UPPER(tax_name));


/*******************************************************************
	TAX FORMS SIMPLIFY LENGHTY TAX CALCULATION FORMULA BY SAVING
	THE FORMULA FOR FUTURE USE. THE SAVED TAX CALCULATION FORMULA
	CAN BE REFERRED TO AS TAX FORM.
*******************************************************************/

CREATE TABLE core.tax_forms
(
	tax_form_id SERIAL NOT NULL PRIMARY KEY,
	tax_form_code varchar(12) NOT NULL,
	tax_form_name varchar(50) NOT NULL,
	allow_edit boolean NOT NULL DEFAULT(true)
);


CREATE UNIQUE INDEX tax_forms_tax_form_code_uix
ON core.tax_forms(UPPER(tax_form_code));

CREATE UNIQUE INDEX tax_forms_tax_form_name_uix
ON core.tax_forms(UPPER(tax_form_name));

CREATE TABLE core.tax_form_details
(
	tax_form_detail_id SERIAL NOT NULL PRIMARY KEY,
	tax_form_id integer NOT NULL REFERENCES core.tax_forms(tax_form_id),
	ordinal_poisition smallint NOT NULL,
	tax_id integer NOT NULL REFERENCES core.taxes(tax_id),
	tax_on_toal boolean NOT NULL DEFAULT(false)
);


CREATE UNIQUE INDEX tax_form_details_tax_form_id_ordinal_poisition_uix
ON core.tax_form_details(tax_form_id,ordinal_poisition);


CREATE TABLE core.item_groups
(
	item_group_id SERIAL NOT NULL PRIMARY KEY,
	item_group_code varchar(12) NOT NULL,
	item_group_name varchar(50) NOT NULL,
	parent_item_group_id integer NULL REFERENCES core.item_groups(item_group_id),
	tax_id smallint NOT NULL REFERENCES core.taxes(tax_id)
);


CREATE UNIQUE INDEX item_groups_item_group_code_uix
ON core.item_groups(UPPER(item_group_code));

CREATE UNIQUE INDEX item_groups_item_group_name_uix
ON core.item_groups(UPPER(item_group_name));

CREATE TABLE core.items
(
	item_Id BIGSERIAL NOT NULL PRIMARY KEY,
	item_code varchar(12) NOT NULL,
	item_name varchar(150) NOT NULL,
	item_group_id integer NOT NULL REFERENCES core.item_groups(item_group_id),
	brand_id integer NOT NULL REFERENCES core.brands(brand_id),
	preferred_supplier_id integer NULL REFERENCES core.suppliers(supplier_id),
	unit_id integer NOT NULL REFERENCES core.units(unit_id),
	hot_item boolean NOT NULL,
	tax_inclusive boolean NOT NULL,
	reorder_level integer NOT NULL,
	cost_price money NOT NULL,
	selling_price money NOT NULL,
	agent_selling_price money NOT NULL,
	dealer_selling_price money NOT NULL,
	max_retail_price money NOT NULL,
	item_image bytea NOT NULL,
	maintain_stock boolean NOT NULL DEFAULT(true),
	CONSTRAINT check_items_agent_selling_price_chk CHECK(agent_selling_price <= selling_price),
	CONSTRAINT check_items_dealer_selling_price_chk CHECK(dealer_selling_price <= selling_price),
	CONSTRAINT check_items_MRP_chk CHECK(selling_price <= max_retail_price)
);

CREATE UNIQUE INDEX items_item_name_uix
ON core.items(UPPER(item_name));


/*******************************************************************
	PLEASE NOTE :

	THESE ARE THE MOST EFFECTIVE STOCK ITEM PRICES.
	THE PRICE IN THIS CATALOG IS ACTUALLY
	PICKED UP AT THE TIME OF PURCHASE AND SALES.

	A STOCK ITEM PRICE MAY BE DIFFERENT FOR DIFFERENT units.
	FURTHER, A STOCK ITEM WOULD BE SOLD AT A HIGHER PRICE
	WHEN SOLD LOOSE THAN WHAT IT WOULD ACTUALLY COST IN A
	COMPOUND UNIT.

	EXAMPLE, ONE CARTOON (20 BOTTLES) OF BEER BOUGHT AS A UNIT
	WOULD COST 25% LESS FROM THE SAME STORE.

*******************************************************************/

CREATE TABLE core.item_prices
(
	price_id BIGSERIAL NOT NULL PRIMARY KEY,
	bar_code_id varchar(50) NOT NULL,
	unit_id integer NOT NULL REFERENCES core.units(unit_id),
	item_id bigint NOT NULL REFERENCES core.items(item_id),
	user_id integer NOT NULL REFERENCES office.users(user_id),
	entry_ts TIMESTAMP WITH TIME ZONE NOT NULL,
	cost_price money NOT NULL,
	selling_price money NOT NULL,
	agent_selling_price money NOT NULL,
	dealer_selling_price money NOT NULL,
	max_retail_price money NOT NULL,
	CONSTRAINT check_itemCosts_agent_selling_price_chk CHECK(agent_selling_price <= selling_price),
	CONSTRAINT check_itemCosts_dealer_selling_price_chk CHECK(dealer_selling_price <= selling_price),
	CONSTRAINT check_itemCosts_MRP_chk CHECK(selling_price <= max_retail_price)
);

CREATE UNIQUE INDEX item_prices_bar_code_id_uix
ON core.item_prices(UPPER(bar_code_id));



CREATE TABLE office.store_types
(
	store_type_id SERIAL NOT NULL PRIMARY KEY,
	store_type_code varchar(12) NOT NULL,
	store_type_name varchar(50) NOT NULL
);

CREATE UNIQUE INDEX store_types_Code_uix
ON office.store_types(UPPER(store_type_code));


CREATE UNIQUE INDEX store_types_Name_uix
ON office.store_types(UPPER(store_type_name));

INSERT INTO office.store_types(store_type_code,store_type_name)
SELECT 'GOD', 'Godown' UNION ALL
SELECT 'SAL', 'Sales Center' UNION ALL
SELECT 'WAR', 'Warehouse' UNION ALL
SELECT 'PRO', 'Production';


CREATE TABLE office.stores
(
	store_id SERIAL  NOT NULL PRIMARY KEY,
	office_id integer NOT NULL REFERENCES office.offices(office_id),
	store_code varchar(12) NOT NULL,
	store_name varchar(50) NOT NULL,
	address varchar(50) NULL,
	store_type_id integer NOT NULL REFERENCES office.store_types(store_type_id),
	allow_sales boolean NOT NULL DEFAULT(true)
);


CREATE UNIQUE INDEX stores_store_code_uix
ON office.stores(UPPER(store_code));

CREATE UNIQUE INDEX stores_store_name_uix
ON office.stores(UPPER(store_name));


CREATE TABLE office.cash_repositories
(
	cash_repository_id BIGSERIAL NOT NULL PRIMARY KEY,
	cash_repository_code varchar(12) NOT NULL,
	cash_repository_name varchar(50) NOT NULL,
	parent_cash_repository_id integer NULL REFERENCES office.cash_repositories(cash_repository_id),
	description varchar(100) NULL
);


CREATE UNIQUE INDEX cash_repositories_cash_repository_code_uix
ON office.cash_repositories(UPPER(cash_repository_code));

CREATE UNIQUE INDEX cash_repositories_cash_repository_name_uix
ON office.cash_repositories(UPPER(cash_repository_name));

CREATE TABLE office.counters
(
	counter_id SERIAL NOT NULL PRIMARY KEY,
	store_id smallint NOT NULL REFERENCES office.stores(store_id),
	cash_repository_id integer NOT NULL REFERENCES office.cash_repositories(cash_repository_id),
	counter_code varchar(12) NOT NULL,
	counter_name varchar(50) NOT NULL
);


CREATE UNIQUE INDEX counters_counter_code_uix
ON office.counters(UPPER(counter_code));

CREATE UNIQUE INDEX counters_counter_name_uix
ON office.counters(UPPER(counter_name));


CREATE TABLE office.cost_centers
(
	cost_center_id SERIAL NOT NULL PRIMARY KEY,
	cost_center_code varchar(24) NOT NULL,
	cost_center_name varchar(50) NOT NULL,
	parent_cost_center_id integer NULL REFERENCES office.cost_centers(cost_center_id)
);

CREATE UNIQUE INDEX cost_centers_cost_center_code_uix
ON office.cost_centers(UPPER(cost_center_code));

CREATE UNIQUE INDEX cost_centers_cost_center_name_uix
ON office.cost_centers(UPPER(cost_center_name));

CREATE TABLE office.cashiers
(
	cashier_id BIGSERIAL NOT NULL PRIMARY KEY,
	counter_id integer NOT NULL REFERENCES office.counters(counter_id),
	user_id integer NOT NULL REFERENCES office.users(user_id),
	assigned_by_user_id integer NOT NULL REFERENCES office.users(user_id),
	transaction_date date NOT NULL,
	closed boolean NOT NULL
);

CREATE UNIQUE INDEX Cashiers_user_id_TDate_uix
ON office.cashiers(user_id ASC, transaction_date DESC);


/*******************************************************************
	STORE policy DEFINES THE RIGHT OF USERS TO ACCESS A STORE.
	AN ADMINISTRATOR CAN ACCESS ALL THE stores, BY DEFAULT.
*******************************************************************/


CREATE TABLE policy.store_policies
(
	store_policy_id BIGSERIAL NOT NULL PRIMARY KEY,
	written_by_user_id integer NOT NULL REFERENCES office.users(user_id),
	entry_ts TIMESTAMP WITH TIME ZONE NOT NULL,
	status boolean NOT NULL
);

CREATE TABLE policy.store_policy_details
(
	store_policy_detail_id BIGSERIAL NOT NULL PRIMARY KEY,
	store_policy_id integer NOT NULL REFERENCES policy.store_policies(store_policy_id),
	user_id integer NOT NULL REFERENCES office.users(user_id),
	store_id smallint NOT NULL REFERENCES office.stores(store_id)
);

CREATE TABLE core.item_opening_inventory
(
	item_opening_inventory_id BIGSERIAL NOT NULL PRIMARY KEY,
	entry_ts TIMESTAMP WITH TIME ZONE NOT NULL,
	item_id bigint NOT NULL REFERENCES core.items(item_id),
	store_id smallint NOT NULL REFERENCES office.stores(store_id),
	unit_id integer NOT NULL REFERENCES core.units(unit_id),
	quantity integer NOT NULL,
	amount money_strict NOT NULL,
	base_unit_id integer NOT NULL REFERENCES core.units(unit_id),
	base_quantity integer NOT NULL
);


CREATE TABLE audit.history
(
	activity_id BIGSERIAL NOT NULL PRIMARY KEY,
	event_ts TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(NOW()),
	principal_user varchar(50) NOT NULL DEFAULT(current_user),
	user_id integer /*NOT*/ NULL REFERENCES office.users(user_id),
	type varchar(50) NOT NULL,
	table_schema varchar(50) NOT NULL,
	table_name varchar(50) NOT NULL,
	primary_key_id varchar(50) NOT NULL,
	column_name varchar(50) NOT NULL,
	old_val text NULL,
	new_val text NULL,
	CONSTRAINT audit_history_val_chk 
		CHECK(
				(old_val IS NULL AND new_val IS NOT NULL) OR
				(old_val IS NOT NULL AND new_val IS NULL) OR
				(old_val IS NOT NULL AND new_val IS NOT NULL)
			)
);



CREATE TABLE transactions.transaction_master
(
	transaction_master_id BIGSERIAL NOT NULL PRIMARY KEY,
	transaction_counter integer NOT NULL, --Sequence of transactions of a date
	transaction_code varchar(50) NOT NULL,
	book varchar(50) NOT NULL, --Transaction book. Ex. Sales, Purchase, Journal
	value_date date NOT NULL,
	transaction_ts TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(now()),
	login_id integer NOT NULL REFERENCES audit.logins(login_id),
	sys_user_id integer NULL REFERENCES office.users(user_id),
	office_id integer NOT NULL REFERENCES office.offices(office_id),
	cost_center_id integer NULL REFERENCES office.cost_centers(cost_center_id),
	ref_no varchar(24) NULL,
	verification verification NOT NULL DEFAULT(0/*Awaiting verification*/),
	CONSTRAINT transaction_master_login_id_sys_user_id
		CHECK
		(
			(
				login_id IS NULL AND sys_user_id IS NOT NULL
			)

			OR

			(
				login_id IS NOT NULL AND sys_user_id IS NULL
			)
		)
);

CREATE UNIQUE INDEX transaction_master_transaction_code_uix
ON transactions.transaction_master(UPPER(transaction_code));



/*******************************************************************
	THIS FUNCTION RETURNS A NEW INCREMENTAL COUNTER SUBJECT 
	TO BE USED TO GENERATE TRANSACTION CODES
*******************************************************************/

CREATE FUNCTION transactions.get_new_transaction_counter(date)
RETURNS integer
AS
$$
	DECLARE _ret_val integer;
BEGIN
	SELECT INTO _ret_val
		COALESCE(MAX(transaction_counter),0)
	FROM transactions.transaction_master
	WHERE value_date=$1;

	IF _ret_val IS NULL THEN
		RETURN 1::integer;
	ELSE
		RETURN (_ret_val + 1)::integer;
	END IF;
END;
$$
LANGUAGE plpgsql;

CREATE FUNCTION transactions.get_transaction_code(value_date date, office_id bigint, user_id integer, login_id bigint)
RETURNS text
AS
$$
	DECLARE _office_id bigint:=$1;
	DECLARE _user_id integer:=$2;
	DECLARE _login_id bigint:=$3;
	DECLARE _ret_val text;	
BEGIN
	_ret_val:= transactions.get_new_transaction_counter($1)   || '-' || TO_CHAR($1, 'YYYY-MM-DD') || '-' || CAST(_office_id as text) || '-' || CAST(_user_id as text) || '-' || CAST(_login_id as text)   || '-' ||  TO_CHAR(now(), 'HH24-MI-SS');
	RETURN _ret_val;
END
$$
LANGUAGE plpgsql;



CREATE TABLE transactions.transaction_details
(
	transaction_detail_id BIGSERIAL NOT NULL PRIMARY KEY,
	transaction_master_id bigint NOT NULL REFERENCES transactions.transaction_master(transaction_master_id),
	transaction_type transaction_type NOT NULL,
	account_id bigint NOT NULL REFERENCES core.accounts(account_id),
	amount money_strict NOT NULL
);

CREATE TABLE transactions.stock_master
(
	stock_master_id BIGSERIAL NOT NULL PRIMARY KEY,
	transaction_master_id bigint NOT NULL REFERENCES transactions.transaction_master(transaction_master_id),
	customer_id bigint NULL REFERENCES core.customers(customer_id),
	supplier_id bigint NULL REFERENCES core.suppliers(supplier_id)
);


CREATE TABLE transactions.stock_master_details
(
	stock_master_detail_id BIGSERIAL NOT NULL PRIMARY KEY,
	stock_master_id bigint NOT NULL REFERENCES transactions.stock_master(stock_master_id),
	type transaction_type NOT NULL,
	item_id bigint NOT NULL REFERENCES core.items(item_id),
	unit_id integer NOT NULL REFERENCES core.units(unit_id),
	quantity integer NOT NULL,
	base_unit_id integer NOT NULL REFERENCES core.units(unit_id),
	base_quantity integer NOT NULL,
	store_id integer NULL REFERENCES office.stores(store_id)
);


CREATE TABLE transactions.stock_master_rates
(
	stock_master_rate_id BIGSERIAL NOT NULL PRIMARY KEY,
	stock_master_detail_id bigint NOT NULL REFERENCES transactions.stock_master_details(stock_master_detail_id),
	rate_per_quantity integer NOT NULL,
	rate_per_base_quantity integer NOT NULL,
	amount money_strict NOT NULL,
	tax_id integer NOT NULL REFERENCES core.taxes(tax_id),
	tax_rate integer NOT NULL,
	tax_amount money_strict NOT NULL
);

CREATE TABLE crm.lead_sources
(
	lead_source_id    SERIAL NOT NULL PRIMARY KEY,
	lead_source_code varchar(12) NOT NULL,
	lead_source_name varchar(128) NOT NULL
);

CREATE UNIQUE INDEX lead_sources_lead_source_code_uix
ON crm.lead_sources(lead_source_code);


CREATE UNIQUE INDEX lead_sources_lead_source_name_uix
ON crm.lead_sources(lead_source_name);

INSERT INTO crm.lead_sources(lead_source_code, lead_source_name)
SELECT 'AG', 'Agent' UNION ALL
SELECT 'CC', 'Cold Call' UNION ALL
SELECT 'CR', 'Customer Reference' UNION ALL
SELECT 'DI', 'Direct Inquiry' UNION ALL
SELECT 'EV', 'Events' UNION ALL
SELECT 'PR', 'Partner';

CREATE TABLE crm.lead_statuses
(
	lead_status_id    SERIAL NOT NULL PRIMARY KEY,
	lead_status_code varchar(12) NOT NULL,
	lead_status_name varchar(128) NOT NULL
);

CREATE UNIQUE INDEX lead_statuses_lead_status_code_uix
ON crm.lead_statuses(lead_status_code);


CREATE UNIQUE INDEX lead_statuses_lead_status_name_uix
ON crm.lead_statuses(lead_status_name);

INSERT INTO crm.lead_statuses(lead_status_code, lead_status_name)
SELECT 'CL', 'Cool' UNION ALL
SELECT 'CF', 'Contact in Future' UNION ALL
SELECT 'LO', 'Lost' UNION ALL
SELECT 'IP', 'In Prgress' UNION ALL
SELECT 'QF', 'Qualified';

CREATE TABLE crm.opportunity_stages
(
	opportunity_stage_id SERIAL  NOT NULL PRIMARY KEY,
	opportunity_stage_code varchar(12) NOT NULL,
	opportunity_stage_name varchar(50) NOT NULL
);


CREATE UNIQUE INDEX opportunity_stages_opportunity_stage_code_uix
ON crm.opportunity_stages(UPPER(opportunity_stage_code));

CREATE UNIQUE INDEX opportunity_stages_opportunity_stage_name_uix
ON crm.opportunity_stages(UPPER(opportunity_stage_name));


INSERT INTO crm.opportunity_stages(opportunity_stage_code, opportunity_stage_name)
SELECT 'PRO', 'Prospecting' UNION ALL
SELECT 'QUA', 'Qualification' UNION ALL
SELECT 'NEG', 'Negotiating' UNION ALL
SELECT 'VER', 'Verbal' UNION ALL
SELECT 'CLW', 'Closed Won' UNION ALL
SELECT 'CLL', 'Closed Lost';

