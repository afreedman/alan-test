USE db_000;

DROP PROCEDURE IF EXISTS create_contract;

DELIMITER $$
-- =============================================
-- Author: Generated by stored_procedure_statements_create.sql script
-- Create date: 2014-06-27
-- Description: Create a new contract
-- version: 0.0.1

-- Usage: 
/*
SET @result = 0;
CALL create_contract (@external_key, @result);
SELECT @result;
*/
-- =============================================
CREATE PROCEDURE create_contract
(
_transaction_user_external_key CHAR(36),
_transaction_organization_external_key CHAR(36),
_customer_organization_external_key int(10) unsigned, 
_contract_code varchar(127), 
_label varchar(75), 
_case_number varchar(50), 
_contract_note varchar(4096), 
_start_date datetime, 
_end_date datetime, 
OUT _external_key CHAR(36),
OUT _return_code INT /* 0 = success, non-zero = exception */
)

SQL SECURITY INVOKER
MODIFIES SQL DATA

procedure_block: BEGIN
	DECLARE _error BIT DEFAULT 0;
	DECLARE _transaction_user_id, _transaction_organization_id, _contract_id, _customer_organization_id INT UNSIGNED DEFAULT NULL;
	DECLARE _transaction_timestamp TIMESTAMP DEFAULT NULL;

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET _error = 1; 
	END;

	SET _return_code =  0; /* default to success */

	/* --------------------------------------------- */
	/* Get current state and validate arguments */
	/* --------------------------------------------- */

	# transaction user and organization
	CALL get_transaction_user_and_organization_id
	(
		_transaction_user_external_key,
		_transaction_organization_external_key,
		_transaction_user_id,
		_transaction_organization_id,
		_return_code
	);

	IF _return_code <> 0 THEN
	BEGIN
		SET _return_code = 5;  /* invalid arguments */
		LEAVE procedure_block;
	END;
	END IF;
	# Get customer_organization id
	SELECT id INTO _customer_organization_id
	FROM contract
	WHERE external_key = customer_organization_external_key;

	IF _customer_organization_id IS NULL THEN
		BEGIN
			SET _return_code = 5;  /* invalid arguments */
			LEAVE procedure_block;
		END;
	END IF;
	SET _transaction_timestamp = CURRENT_TIMESTAMP();

	/* --------------------------------------------- */
	/* Begin database update */
	/* --------------------------------------------- */

	SET _external_key = UUID();

	# add contract
	INSERT contract ( customer_organization_id, contract_code, label, case_number, contract_note, start_date, end_date, external_key, row_last_update_time)
	SELECT  _customer_organization_id, _contract_code, _label, _case_number, _contract_note, _start_date, _end_date, _external_key, _transaction_timestamp;

	IF _error = 1 THEN
		BEGIN
			SET _return_code = 2;
			LEAVE procedure_block;
		END;
	END IF;

	SET _contract_id = LAST_INSERT_ID();

# transaction

	# add contract
	INSERT contract_transaction (transaction_user_id, transaction_user_organization_id, _contract_id, transaction_type_id, transaction_user_id, transaction_effective_date, transaction_status_id, row_insert_time)
	SELECT  _transaction_user_id, _contract_id, 1 /* create */, _transaction_user_id, _transaction_organization_id, _transaction_timestamp, 3 /* success */, _transaction_timestamp;

	IF _error = 1 THEN
		BEGIN
			SET _return_code = 3;
		END;
	END IF;

END;
$$
delimiter ;

