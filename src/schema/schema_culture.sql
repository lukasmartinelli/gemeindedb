-------------------------------------------
DROP TABLE IF EXISTS public.cinemas CASCADE;
CREATE TABLE public.cinemas (
    community_id integer NOT NULL,
    year integer NOT NULL,
    cinemas integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.cinemas
SELECT regions_id::integer as community_id,
        2014 as year,
        anzahl_kinos::integer as cinemas
FROM import.kinos_2014
INNER JOIN public.communities AS c ON c.id = regions_id::integer;
