-------------------------------------------
DROP TABLE IF EXISTS public.commute_distance CASCADE;
CREATE TABLE public.commute_distance (
    community_id integer NOT NULL,
    year integer NOT NULL,
    distance_km decimal NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.commute_distance
SELECT regions_id::integer as community_id,
       2012 as year,
       durchschnittliche_länge_des_arbeitswegs_in_km::decimal as distance_km
FROM import.laenge_arbeitsweg_2010_2012
INNER JOIN public.communities AS c ON c.id = regions_id::integer;

-------------------------------------------
DROP TABLE IF EXISTS public.commuter_balance CASCADE;
CREATE TABLE public.commuter_balance (
    community_id integer NOT NULL,
    year integer NOT NULL,
    commuters integer NOT NULL,
    balance_per_100_workers decimal NOT NULL,
    PRIMARY KEY (community_id),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.commuter_balance
SELECT regions_id::integer as community_id,
       2000 as year,
       pendlersaldo_in_personen::integer as commuters,
       bilanz_der_zu__und_wegpendler_pro_100_erwerbstätige_sowie_sch::decimal as balance_per_100_workers
FROM import.pendlersaldo_2000
INNER JOIN public.communities AS c ON c.id = regions_id::integer;
