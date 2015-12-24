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
DROP TABLE IF EXISTS public.zipcode CASCADE;
CREATE TABLE public.zipcode (
    community_id integer NOT NULL,
    zip integer NOT NULL,
    PRIMARY KEY (community_id, zip),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.zipcode
SELECT gdenr::integer, plz4::integer as zip
FROM import.postleitzahlen_2015
INNER JOIN public.communities AS c ON c.id = gdenr::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.language_areas CASCADE;
CREATE TABLE public.language_areas (
    community_id integer NOT NULL,
    year integer NOT NULL,
    language text NOT NULL,
    PRIMARY KEY (community_id),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.language_areas
SELECT regions_id::integer as community_id,
        2000 AS year,
       Sprachgebiete as language
FROM import.sprachgebiete_2000
INNER JOIN public.communities AS c ON c.id = regions_id::integer;
