-------------------------------------------
DROP TABLE IF EXISTS public.empty_flats CASCADE;
CREATE TABLE public.empty_flats (
    community_id integer NOT NULL,
    year integer NOT NULL,
    rooms text NOT NULL,
    flats integer NOT NULL,
    PRIMARY KEY (community_id, year, rooms),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.empty_flats
SELECT extract_community_id(f15.region),
       2015 as year,
       f15.rooms,
       f15.flats::integer
FROM (
    SELECT region, '1' as rooms, _1_wohnraum as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '2' as rooms, _2_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '3' as rooms, _3_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '4' as rooms, _4_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '5' as rooms, _5_wohnräume as flats FROM import.leerstehende_wohnungen_2015
    UNION ALL
    SELECT region, '6+' as rooms, _6_wohnräume_und_mehr as flats FROM import.leerstehende_wohnungen_2015
) AS f15
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.housing_estate_share CASCADE;
CREATE TABLE public.housing_estate_share (
    community_id integer NOT NULL,
    year integer NOT NULL,
    share decimal NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.housing_estate_share
SELECT regions_id::integer as community_id,
       2004 as year,
       anteil_der_siedlungsflächen_an_der_gesamtfläche_in_::decimal as share
FROM import.anteil_siedlungsflaeche_2004
INNER JOIN public.communities AS c ON c.id = regions_id::integer;
