-- Станции со всеми линиями
CREATE VIEW station_with_line AS
	SELECT 
		  s.id as station_id
		, s.name as station_name
		, STRING_AGG(l.name, ', ') as line_name
	FROM stations s
	INNER JOIN station_lines sl
		ON sl.station_id = s.id
	INNER JOIN lines l
		ON l.id = sl.line_id
	group by s.id, s.name 
	order by 1