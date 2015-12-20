-------------------------------------------
DROP TABLE IF EXISTS public.city_class;
DROP TABLE IF EXISTS public.municipalities;
DROP TABLE IF EXISTS public.districts;
DROP TABLE IF EXISTS public.cantons;

-------------------------------------------
CREATE TABLE public.cantons (
    id     integer PRIMARY KEY,
    geometry  geometry(PolygonZ, 3857) NOT NULL,
    name    varchar(30) NOT NULL
);

INSERT INTO public.cantons

SELECT k.id::integer, k.name, b.wkb_geometry as geometry
FROM import.kantone as k, import.canton_boundaries as b
WHERE k.id::integer = b.kantonsnum;

-------------------------------------------
CREATE TABLE public.districts (
    id        integer PRIMARY KEY,
    canton_id integer REFERENCES public.cantons (id),
    name      varchar(30) NOT NULL
);

INSERT INTO public.districts
SELECT id::integer, kanton_id::integer as canton_id, name FROM import.bezirke;

-------------------------------------------
CREATE TABLE public.municipalities (
    id        integer PRIMARY KEY,
    canton_id integer REFERENCES public.cantons (id),
    geometry  geometry(PolygonZ, 3857) NOT NULL,
    name      varchar(30) NOT NULL
);

INSERT INTO public.municipalities
SELECT DISTINCT ON (ge.id) id::integer, ge.kanton_id::integer as canton_id,
       b.wkb_geometry as geometry, ge.name
FROM import.gemeinden as ge, import.community_boundaries as b
WHERE ge.id::integer = b.bfs_nummer;

-------------------------------------------
CREATE TABLE public.city_class (
    municipality_id integer PRIMARY KEY,
    class           varchar(50) NOT NULL,
    FOREIGN KEY (municipality_id) REFERENCES public.municipalities (id)
);

INSERT INTO public.city_class
SELECT id::integer as municipality_id, name FROM import.gemeinde_stadt_charakteristika
WHERE id NOT LIKE 'AT_%'
  AND id NOT LIKE 'FR_%'
  AND id NOT LIKE 'IT_%'
  AND id not LIKE 'DE_%'
  AND id NOT LIKE 'LI_%'
  AND id::integer IN (SELECT id FROM public.municipalities);
