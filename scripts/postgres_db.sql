
-- psql -f /vagrant/scripts/postgres_db.sql 
create user benchmark password 'benchmark';

DROP DATABASE IF EXISTS benchmark;
CREATE DATABASE benchmark owner benchmark;
GRANT ALL PRIVILEGES ON DATABASE benchmark TO benchmark;

\connect benchmark
CREATE UNLOGGED TABLE cache
( 
  key varchar(1024) CONSTRAINT key_pk PRIMARY KEY,
  value integer NOT NULL
);
ALTER TABLE cache OWNER TO benchmark;

drop function if exists upsertism(varchar);

create function upsertism(varchar)
  RETURNS integer AS
$$
DECLARE
    result integer;
begin
  begin
    insert into cache values ($1, 1) returning value into result;
  exception when unique_violation then
    update cache set value = value + 1 where key = $1 returning value into result;
  end;
  return result;
end
$$ language plpgsql;