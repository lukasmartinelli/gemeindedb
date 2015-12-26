-------------------------------------------
DROP TABLE IF EXISTS public.political_parties CASCADE;
CREATE TABLE public.political_parties (
    community_id integer NOT NULL,
    year integer NOT NULL,
    party text NOT NULL,
    voters decimal NOT NULL,
    PRIMARY KEY (community_id, year, party),
    FOREIGN KEY (community_id) REFERENCES public.communities (id)
);

INSERT INTO public.political_parties
SELECT DISTINCT ON (community_id, jahr, partei)
    c.id AS community_id, jahr::integer AS year,
    partei AS party, fiktive_waehlende::decimal AS voters
FROM import.partei_waehlende_1975_2011
INNER JOIN public.communities AS c ON c.id = bfs_id::integer
WHERE bfs_id ~ E'^\\d+$'
