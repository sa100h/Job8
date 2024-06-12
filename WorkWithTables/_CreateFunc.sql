-----Функции полезные

-- Выделить инициал
create or replace function get_inicial(
	_name CHARACTER VARYING(50)
) 
returns CHARACTER VARYING(2) AS
$BODY$
begin

	IF _name IS NOT NULL THEN
		return substring(_name,1,1) || '.';
	ELSE
		return '';
	END IF;
	
end;
$BODY$
LANGUAGE plpgsql;


-- Получить Фамилию и инициалы
CREATE OR REPLACE FUNCTION public.get_name(
	_last_name character varying,
	_first_name character varying,
	_middle_name character varying)
    RETURNS character varying(100)
AS $BODY$
begin

	return _last_name || ' ' || get_inicial(_first_name) || get_inicial(_middle_name);
	
end;
$BODY$
LANGUAGE plpgsql;