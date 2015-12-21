-------------------------------------------
DROP FUNCTION IF EXISTS is_community(str TEXT) CASCADE;
CREATE FUNCTION is_community(str TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN str LIKE '......%';
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-------------------------------------------
DROP FUNCTION IF EXISTS extract_community_id(str TEXT) CASCADE;
CREATE FUNCTION extract_community_id(str TEXT)
RETURNS INTEGER AS $$
BEGIN
    RETURN SUBSTRING(str, '\d{4}')::integer;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-------------------------------------------
CREATE OR REPLACE FUNCTION values_by_year(table_name text, column_name text)
RETURNS SETOF RECORD AS $$
BEGIN
    RETURN QUERY EXECUTE format(
        'SELECT region, 2014 as year, _2014 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2013 as year, _2013 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2012 as year, _2012 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2011 as year, _2011 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2010 as year, _2010 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2009 as year, _2009 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2008 as year, _2008 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2007 as year, _2007 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2006 as year, _2006 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2005 as year, _2005 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2004 as year, _2004 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2003 as year, _2003 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2002 as year, _2002 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2001 as year, _2001 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 2000 as year, _2000 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1999 as year, _1999 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1998 as year, _1998 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1997 as year, _1997 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1996 as year, _1996 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1995 as year, _1995 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1994 as year, _1994 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1993 as year, _1993 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1992 as year, _1992 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1991 as year, _1991 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1990 as year, _1990 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1989 as year, _1989 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1988 as year, _1988 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1987 as year, _1987 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1986 as year, _1986 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1985 as year, _1985 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1984 as year, _1984 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1983 as year, _1983 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1982 as year, _1982 as %2$s FROM %1$s
        UNION ALL
        SELECT region, 1981 as year, _1981 as %2$s FROM %1$s',
        table_name, column_name);
END;
$$
LANGUAGE plpgsql;

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
DROP TABLE IF EXISTS public.residential_population CASCADE;
CREATE TABLE public.residential_population (
    community_id integer NOT NULL,
    year integer NOT NULL,
    population integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.residential_population
SELECT extract_community_id(region),
       year,
       population::integer
FROM values_by_year('import.mittlere_wohnbevoelkerung_1981_2014', 'population')
     f(region text, year integer, population text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.deaths CASCADE;
CREATE TABLE public.deaths (
    community_id integer NOT NULL,
    year integer NOT NULL,
    deaths integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.deaths
SELECT extract_community_id(region),
       year,
       deaths::integer
FROM values_by_year('import.todesfaelle_1981_2014', 'deaths')
     f(region text, year integer, deaths text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.births CASCADE;
CREATE TABLE public.births (
    community_id integer NOT NULL,
    year integer NOT NULL,
    births integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.births
SELECT extract_community_id(region),
       year,
       births::integer
FROM values_by_year('import.geburt_1981_2014', 'births')
     f(region text, year integer, births text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.immigration CASCADE;
CREATE TABLE public.immigration (
    community_id integer NOT NULL,
    year integer NOT NULL,
    immigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.immigration
SELECT extract_community_id(region),
       year,
       immigration::integer
FROM values_by_year('import.einwanderung_1981_2014', 'immigration')
     f(region text, year integer, immigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.emigration CASCADE;
CREATE TABLE public.emigration (
    community_id integer NOT NULL,
    year integer NOT NULL,
    emigration integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.emigration
SELECT extract_community_id(region),
       year,
       emigration::integer
FROM values_by_year('import.auswanderung_1981_2014', 'emigration')
     f(region text, year integer, emigration text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);

-------------------------------------------
DROP TABLE IF EXISTS public.new_citizenships CASCADE;
CREATE TABLE public.new_citizenships (
    community_id integer NOT NULL,
    year integer NOT NULL,
    citizenships integer NOT NULL,
    PRIMARY KEY (community_id, year),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.new_citizenships
SELECT extract_community_id(region),
       year,
       citizenships::integer
FROM values_by_year('import.buergerrecht_erwerb_1981_2014', 'citizenships')
     f(region text, year integer, citizenships text)
INNER JOIN public.communities AS c ON c.id = extract_community_id(region)
WHERE is_community(region);
