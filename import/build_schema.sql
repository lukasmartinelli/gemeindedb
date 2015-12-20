-------------------------------------------
DROP TABLE IF EXISTS public.cantons CASCADE;
CREATE TABLE public.cantons (
    id     integer PRIMARY KEY,
    name    varchar(30) NOT NULL
);

INSERT INTO public.cantons
SELECT regions_id::integer as id, regionsname as name
FROM import._134_die_26_kantone_der_schweiz_de;

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
FROM import._18838_die_2324_gemeinden_der_schweiz_am_1_1_2015_de;

-------------------------------------------
DROP TABLE IF EXISTS public.population_2010 CASCADE;
CREATE TABLE public.population_2010 (
    community_id integer PRIMARY KEY,
    population integer NOT NULL,
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.population_2010
SELECT regions_id::integer as community_id, einwohnerzahl_am_jahresende::integer
FROM import._10621_staendige_wohnbevoelkerung_2010_de
WHERE regions_id::integer IN (SELECT id FROM public.communities);
-------------------------------------------
