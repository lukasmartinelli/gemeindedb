-------------------------------------------
DROP TYPE IF EXISTS workplace_size CASCADE;
CREATE TYPE workplace_size AS ENUM ('micro', 'small', 'medium', 'big');

DROP TABLE IF EXISTS public.workplaces_by_size CASCADE;
CREATE TABLE public.workplaces_by_size (
    community_id integer NOT NULL,
    year integer NOT NULL,
    workplace_size workplace_size NOT NULL,
    workplaces integer NOT NULL,
    workers integer NOT NULL,
    PRIMARY KEY (community_id, year, workplace_size),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.workplaces_by_size
SELECT c.id as community_id,
       2013 as year,
       'micro' AS workplace_size,
       arbeitsstätten::integer as workplaces,
       beschäftigte::integer as workers
FROM import.beschaeftigte_mikrounternehmen_2013
INNER JOIN public.communities AS c ON c.id = split_part(region, ' ', 1)::integer;

INSERT INTO public.workplaces_by_size
SELECT c.id as community_id,
       2013 as year,
       'small' AS workplace_size,
       arbeitsstätten::integer as workplaces,
       beschäftigte::integer as workers
FROM import.beschaeftigte_kleinunternehmen_2013
INNER JOIN public.communities AS c ON c.id = split_part(region, ' ', 1)::integer;

INSERT INTO public.workplaces_by_size
SELECT c.id as community_id,
       2013 as year,
       'medium' AS workplace_size,
       arbeitsstätten::integer as workplaces,
       beschäftigte::integer as workers
FROM import.beschaeftigte_mittlere_unternehmen_2013
INNER JOIN public.communities AS c ON c.id = split_part(region, ' ', 1)::integer;

INSERT INTO public.workplaces_by_size
SELECT c.id as community_id,
       2013 as year,
       'big' AS workplace_size,
       arbeitsstätten::integer as workplaces,
       beschäftigte::integer as workers
FROM import.beschaeftigte_grossunternehmen_2013
INNER JOIN public.communities AS c ON c.id = split_part(region, ' ', 1)::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.workplaces_by_sector CASCADE;
CREATE TABLE public.workplaces_by_sector (
    community_id integer NOT NULL,
    year integer NOT NULL,
    sector integer NOT NULL,
    workplaces integer NOT NULL,
    workers integer NOT NULL,
    PRIMARY KEY (community_id, year, sector),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.workplaces_by_sector
SELECT c.id as community_id,
       2013 as year,
       1 as sector,
       s1.arbeitsstätten::integer as workplaces,
       s1.beschäftigte::integer as workers
FROM import.beschaeftigte_primaersektor_2013 AS s1
INNER JOIN public.communities AS c ON c.id = split_part(s1.region, ' ', 1)::integer;

INSERT INTO public.workplaces_by_sector
SELECT c.id as community_id,
       2013 as year,
       2 as sector,
       s2.arbeitsstätten::integer as workplaces,
       s2.beschäftigte::integer as workers
FROM import.beschaeftigte_sekundaersektor_2013 AS s2
INNER JOIN public.communities AS c ON c.id = split_part(s2.region, ' ', 1)::integer;

INSERT INTO public.workplaces_by_sector
SELECT c.id as community_id,
       2013 as year,
       3 as sector,
       s3.arbeitsstätten::integer as workplaces,
       s3.beschäftigte::integer as workers
FROM import.beschaeftigte_tertiaersektor_2013 AS s3
INNER JOIN public.communities AS c ON c.id = split_part(s3.region, ' ', 1)::integer;
