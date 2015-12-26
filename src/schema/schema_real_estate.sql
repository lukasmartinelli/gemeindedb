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

-------------------------------------------
DROP TABLE IF EXISTS public.building_investments CASCADE;
DROP TYPE IF EXISTS investment_sector;
CREATE TYPE investment_sector AS ENUM ('private', 'public');

CREATE TABLE public.building_investments (
    community_id integer NOT NULL,
    year integer NOT NULL,
    sector investment_sector NOT NULL,
    thousand_swiss_francs integer NOT NULL,
    PRIMARY KEY (community_id, year, sector),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.building_investments
SELECT c.id as community_id,
       year,
       'private' as sector,
       thousand_swiss_francs::integer
FROM values_by_year_1995_2012('import.bauinvestitionen_privat_1995_2012', 'thousand_swiss_francs')
     f(region text, year integer, thousand_swiss_francs text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region);

INSERT INTO public.building_investments
SELECT c.id as community_id,
       year,
       'public' as sector,
       thousand_swiss_francs::integer
FROM values_by_year_1995_2012('import.bauinvestitionen_oeffentlich_1995_2012', 'thousand_swiss_francs')
     f(region text, year integer, thousand_swiss_francs text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region);

-------------------------------------------
DROP TABLE IF EXISTS public.flats CASCADE;

DROP TYPE IF EXISTS rooms;
CREATE TYPE rooms AS ENUM ('1', '2', '3', '4', '5', '6+');

DROP TYPE IF EXISTS building_category;
CREATE TYPE building_category AS ENUM ('house', 'apartment', 'secondary', 'partial');

CREATE TABLE public.flats (
    community_id integer NOT NULL,
    year integer NOT NULL,
    category building_category NOT NULL,
    rooms rooms NOT NULL,
    flats integer NOT NULL,
    PRIMARY KEY (community_id, year, category, rooms),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.flats
SELECT c.id as community_id,
       year,
       CASE gebäudekategorie
         WHEN 'Einfamilienhäuser' THEN 'house'::building_category
         WHEN 'Mehrfamilienhäuser' THEN 'apartment'::building_category
         WHEN 'Wohngebäude mit Nebennutzung' THEN 'secondary'::building_category
         WHEN 'Gebäude mit teilweiser Wohnnutzung' THEN 'partial'::building_category
       END AS category,
       replace(anzahl_zimmer, ' Zimmer', '')::rooms as rooms,
       flats::integer
FROM (
    SELECT region, gebäudekategorie, anzahl_zimmer, 2014 as year, _2014 as flats FROM import.wohnungen_2009_2014
    UNION ALL
    SELECT region, gebäudekategorie, anzahl_zimmer, 2013 as year, _2013 as flats FROM import.wohnungen_2009_2014
    UNION ALL
    SELECT region, gebäudekategorie, anzahl_zimmer, 2012 as year, _2012 as flats FROM import.wohnungen_2009_2014
    UNION ALL
    SELECT region, gebäudekategorie, anzahl_zimmer, 2011 as year, _2011 as flats FROM import.wohnungen_2009_2014
    UNION ALL
    SELECT region, gebäudekategorie, anzahl_zimmer, 2010 as year, _2010 as flats FROM import.wohnungen_2009_2014
    UNION ALL
    SELECT region, gebäudekategorie, anzahl_zimmer, 2009 as year, _2009 as flats FROM import.wohnungen_2009_2014
) AS t
INNER JOIN public.communities AS c ON c.id = extract_community_id(region);
