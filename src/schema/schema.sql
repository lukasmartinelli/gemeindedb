-------------------------------------------
DROP TABLE IF EXISTS public.cantons CASCADE;
CREATE TABLE public.cantons (
    id     integer PRIMARY KEY,
    name    varchar(30) NOT NULL
);

INSERT INTO public.cantons
SELECT regions_id::integer as id, regionsname as name
FROM import.kantone_1997;

-------------------------------------------
DROP TABLE IF EXISTS public.communities CASCADE;
CREATE TABLE public.communities (
    id        integer PRIMARY KEY,
    canton_id integer REFERENCES public.cantons (id),
    name      varchar(30) NOT NULL
);

INSERT INTO public.communities
SELECT regions_id::integer,
       substring("kantonszugehörigkeit" FROM '\((.*)\)+$')::integer as canton_id,
       regionsname as name
FROM import.politische_gemeinden_2015;

-------------------------------------------
