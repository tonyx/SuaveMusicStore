--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.0
-- Dumped by pg_dump version 9.6.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: album_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE album_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE album_seq OWNER TO "Tonyx";

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: albums; Type: TABLE; Schema: public; Owner: Tonyx
--

CREATE TABLE albums (
    albumid integer DEFAULT nextval('album_seq'::regclass) NOT NULL,
    genreid integer NOT NULL,
    artistid integer NOT NULL,
    title character varying(160) NOT NULL,
    price numeric(10,2) NOT NULL,
    albumarturl character varying(1024) DEFAULT '/placeholder.gif'::character varying
);


--ALTER TABLE albums OWNER TO "Tonyx";

--
-- Name: artists_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE artists_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE artists_seq OWNER TO "Tonyx";

--
-- Name: artists; Type: TABLE; Schema: public; Owner: Tonyx
--

CREATE TABLE artists (
    artistid integer DEFAULT nextval('artists_seq'::regclass) NOT NULL,
    name character varying(120)
);


--ALTER TABLE artists OWNER TO "Tonyx";

--
-- Name: genres; Type: TABLE; Schema: public; Owner: Tonyx
--

CREATE TABLE genres (
    genreid integer NOT NULL,
    name character varying(120),
    description character varying(4000)
);


--ALTER TABLE genres OWNER TO "Tonyx";

--
-- Name: albumdetails; Type: VIEW; Schema: public; Owner: Tonyx
--

CREATE VIEW albumdetails AS
 SELECT a.albumid,
    a.albumarturl,
    a.price,
    a.title,
    at.name AS artist,
    g.name AS genre
   FROM ((albums a
     JOIN artists at ON ((at.artistid = a.artistid)))
     JOIN genres g ON ((g.genreid = a.genreid)));


--ALTER TABLE albumdetails OWNER TO "Tonyx";

--
-- Name: albums_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE albums_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE albums_seq OWNER TO "Tonyx";

--
-- Name: orderdetail_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE orderdetail_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE orderdetail_seq OWNER TO "Tonyx";

--
-- Name: orderdetails; Type: TABLE; Schema: public; Owner: Tonyx
--

CREATE TABLE orderdetails (
    orderdetailid integer DEFAULT nextval('orderdetail_seq'::regclass) NOT NULL,
    orderid integer NOT NULL,
    albumid integer NOT NULL,
    quantity integer NOT NULL,
    unitprice numeric(10,2) NOT NULL
);


--ALTER TABLE orderdetails OWNER TO "Tonyx";

--
-- Name: bestsellers; Type: VIEW; Schema: public; Owner: Tonyx
--

CREATE VIEW bestsellers AS
 SELECT a.albumid,
    a.title,
    a.albumarturl,
    count(*) AS count
   FROM (albums a
     JOIN orderdetails o ON ((a.albumid = o.albumid)))
  GROUP BY a.albumid, a.title, a.albumarturl
  ORDER BY (count(*)) DESC
 LIMIT 5;


--ALTER TABLE bestsellers OWNER TO "Tonyx";

--
-- Name: carts_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE carts_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE carts_seq OWNER TO "Tonyx";

--
-- Name: carts; Type: TABLE; Schema: public; Owner: Tonyx
--

CREATE TABLE carts (
    recordid integer DEFAULT nextval('carts_seq'::regclass) NOT NULL,
    cartid character varying(50) NOT NULL,
    albumid integer NOT NULL,
    count integer NOT NULL,
    datecreated timestamp without time zone NOT NULL
);


--ALTER TABLE carts OWNER TO "Tonyx";

--
-- Name: cartdetails; Type: VIEW; Schema: public; Owner: Tonyx
--

CREATE VIEW cartdetails AS
 SELECT c.cartid,
    c.count,
    a.title AS albumtitle,
    a.albumid,
    a.price
   FROM (carts c
     JOIN albums a ON ((c.albumid = a.albumid)));


--ALTER TABLE cartdetails OWNER TO "Tonyx";

--
-- Name: genres_genreid_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE genres_genreid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE genres_genreid_seq OWNER TO "Tonyx";

--
-- Name: genres_genreid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Tonyx
--

ALTER SEQUENCE genres_genreid_seq OWNED BY genres.genreid;


--
-- Name: genres_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE genres_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE genres_seq OWNER TO "Tonyx";

--
-- Name: orders_seq; Type: SEQUENCE; Schema: public; Owner: Tonyx
--

CREATE SEQUENCE orders_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--ALTER TABLE orders_seq OWNER TO "Tonyx";

--
-- Name: orders; Type: TABLE; Schema: public; Owner: Tonyx
--

CREATE TABLE orders (
    orderid integer DEFAULT nextval('orders_seq'::regclass) NOT NULL,
    orderdate timestamp(3) without time zone NOT NULL,
    username character varying(256),
    firstname character varying(160),
    lastname character varying(160),
    address character varying(70),
    city character varying(40),
    state character varying(40),
    postalcode character varying(10),
    country character varying(40),
    phone character varying(24),
    email character varying(160),
    total numeric(10,2) NOT NULL
);


--ALTER TABLE orders OWNER TO "Tonyx";

--
-- Name: users; Type: TABLE; Schema: public; Owner: Tonyx
--

CREATE TABLE users (
    userid integer DEFAULT nextval('genres_seq'::regclass) NOT NULL,
    username character varying(200) NOT NULL,
    email character varying(200) NOT NULL,
    password character varying(200) NOT NULL,
    role character varying(50) NOT NULL
);


--ALTER TABLE users OWNER TO "Tonyx";

--
-- Name: genres genreid; Type: DEFAULT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY genres ALTER COLUMN genreid SET DEFAULT nextval('genres_genreid_seq'::regclass);


--
-- Name: album_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('album_seq', 238, true);


--
-- Data for Name: albums; Type: TABLE DATA; Schema: public; Owner: Tonyx
--

COPY albums (albumid, genreid, artistid, title, price, albumarturl) FROM stdin;
1	1	100	Greatest Hits	8.99	/placeholder.gif
2	1	102	Misplaced Childhood	8.99	/placeholder.gif
3	1	105	The Best Of Men At Work	8.99	/placeholder.gif
4	1	110	Nevermind	8.99	/placeholder.gif
5	1	111	Compositores	8.99	/placeholder.gif
6	1	114	Bark at the Moon (Remastered)	8.99	/placeholder.gif
7	1	114	Blizzard of Ozz	8.99	/placeholder.gif
8	1	114	Diary of a Madman (Remastered)	8.99	/placeholder.gif
9	1	114	No More Tears (Remastered)	8.99	/placeholder.gif
10	1	114	Speak of the Devil	8.99	/placeholder.gif
11	1	115	Walking Into Clarksdale	8.99	/placeholder.gif
12	1	117	The Beast Live	8.99	/placeholder.gif
13	1	118	Live On Two Legs [Live]	8.99	/placeholder.gif
14	1	118	Riot Act	8.99	/placeholder.gif
15	1	118	Ten	8.99	/placeholder.gif
16	1	118	Vs.	8.99	/placeholder.gif
17	1	120	Dark Side Of The Moon	8.99	/placeholder.gif
18	1	124	New Adventures In Hi-Fi	8.99	/placeholder.gif
19	1	126	Raul Seixas	8.99	/placeholder.gif
20	1	127	By The Way	8.99	/placeholder.gif
21	1	127	Californication	8.99	/placeholder.gif
22	1	128	Retrospective I (1974-1980)	8.99	/placeholder.gif
23	1	130	Maquinarama	8.99	/placeholder.gif
24	1	130	O Samba Poconé	8.99	/placeholder.gif
25	1	132	A-Sides	8.99	/placeholder.gif
26	1	134	Core	8.99	/placeholder.gif
27	1	136	[1997] Black Light Syndrome	8.99	/placeholder.gif
28	1	139	Beyond Good And Evil	8.99	/placeholder.gif
29	1	140	The Doors	8.99	/placeholder.gif
30	1	141	The Police Greatest Hits	8.99	/placeholder.gif
31	1	142	Hot Rocks, 1964-1971 (Disc 1)	8.99	/placeholder.gif
32	1	142	No Security	8.99	/placeholder.gif
33	1	142	Voodoo Lounge	8.99	/placeholder.gif
34	1	144	My Generation - The Very Best Of The Who	8.99	/placeholder.gif
35	1	150	Achtung Baby	8.99	/placeholder.gif
36	1	150	B-Sides 1980-1990	8.99	/placeholder.gif
37	1	150	How To Dismantle An Atomic Bomb	8.99	/placeholder.gif
38	1	150	Pop	8.99	/placeholder.gif
39	1	150	Rattle And Hum	8.99	/placeholder.gif
40	1	150	The Best Of 1980-1990	8.99	/placeholder.gif
41	1	150	War	8.99	/placeholder.gif
42	1	150	Zooropa	8.99	/placeholder.gif
43	1	152	Diver Down	8.99	/placeholder.gif
44	1	152	The Best Of Van Halen, Vol. I	8.99	/placeholder.gif
45	1	152	Van Halen III	8.99	/placeholder.gif
46	1	152	Van Halen	8.99	/placeholder.gif
47	1	153	Contraband	8.99	/placeholder.gif
48	1	2	Restless and Wild	8.99	/placeholder.gif
49	1	200	Every Kind of Light	8.99	/placeholder.gif
50	1	22	BBC Sessions [Disc 1] [Live]	8.99	/placeholder.gif
51	1	22	BBC Sessions [Disc 2] [Live]	8.99	/placeholder.gif
52	1	22	Coda	8.99	/placeholder.gif
53	1	22	Houses Of The Holy	8.99	/placeholder.gif
54	1	22	In Through The Out Door	8.99	/placeholder.gif
55	1	22	IV	8.99	/placeholder.gif
56	1	22	Led Zeppelin I	8.99	/placeholder.gif
57	1	22	Led Zeppelin II	8.99	/placeholder.gif
58	1	22	Led Zeppelin III	8.99	/placeholder.gif
59	1	22	Physical Graffiti [Disc 1]	8.99	/placeholder.gif
60	1	22	Physical Graffiti [Disc 2]	8.99	/placeholder.gif
61	1	22	Presence	8.99	/placeholder.gif
62	1	22	The Song Remains The Same (Disc 1)	8.99	/placeholder.gif
63	1	22	The Song Remains The Same (Disc 2)	8.99	/placeholder.gif
64	1	23	Bongo Fury	8.99	/placeholder.gif
65	1	3	Big Ones	8.99	/placeholder.gif
66	1	4	Jagged Little Pill	8.99	/placeholder.gif
67	1	5	Facelift	8.99	/placeholder.gif
68	1	51	Greatest Hits I	8.99	/placeholder.gif
69	1	51	Greatest Hits II	8.99	/placeholder.gif
70	1	51	News Of The World	8.99	/placeholder.gif
71	1	52	Greatest Kiss	8.99	/placeholder.gif
72	1	52	Unplugged [Live]	8.99	/placeholder.gif
73	1	55	Into The Light	8.99	/placeholder.gif
74	1	58	Come Taste The Band	8.99	/placeholder.gif
75	1	58	Deep Purple In Rock	8.99	/placeholder.gif
76	1	58	Fireball	8.99	/placeholder.gif
77	1	58	Machine Head	8.99	/placeholder.gif
78	1	58	MK III The Final Concerts [Disc 1]	8.99	/placeholder.gif
79	1	58	Purpendicular	8.99	/placeholder.gif
80	1	58	Slaves And Masters	8.99	/placeholder.gif
81	1	58	Stormbringer	8.99	/placeholder.gif
82	1	58	The Battle Rages On	8.99	/placeholder.gif
83	1	58	The Final Concerts (Disc 2)	8.99	/placeholder.gif
84	1	59	Santana - As Years Go By	8.99	/placeholder.gif
85	1	59	Santana Live	8.99	/placeholder.gif
86	1	59	Supernatural	8.99	/placeholder.gif
87	1	76	Chronicle, Vol. 1	8.99	/placeholder.gif
88	1	76	Chronicle, Vol. 2	8.99	/placeholder.gif
89	1	8	Audioslave	8.99	/placeholder.gif
90	1	82	King For A Day Fool For A Lifetime	8.99	/placeholder.gif
91	1	84	In Your Honor [Disc 1]	8.99	/placeholder.gif
92	1	84	In Your Honor [Disc 2]	8.99	/placeholder.gif
93	1	90	Brave New World	8.99	/placeholder.gif
94	1	90	Fear Of The Dark	8.99	/placeholder.gif
95	1	90	Live At Donington 1992 (Disc 1)	8.99	/placeholder.gif
96	1	90	Live At Donington 1992 (Disc 2)	8.99	/placeholder.gif
97	1	90	Rock In Rio [CD2]	8.99	/placeholder.gif
98	1	90	The Number of The Beast	8.99	/placeholder.gif
99	1	90	The X Factor	8.99	/placeholder.gif
100	1	90	Virtual XI	8.99	/placeholder.gif
101	1	92	Emergency On Planet Earth	8.99	/placeholder.gif
102	1	94	Are You Experienced?	8.99	/placeholder.gif
103	1	95	Surfing with the Alien (Remastered)	8.99	/placeholder.gif
104	10	203	The Best of Beethoven	8.99	/placeholder.gif
105	10	208	Pachelbel: Canon & Gigue	8.99	/placeholder.gif
106	10	211	Bach: Goldberg Variations	8.99	/placeholder.gif
107	10	212	Bach: The Cello Suites	8.99	/placeholder.gif
108	10	213	Handel: The Messiah (Highlights)	8.99	/placeholder.gif
109	10	217	Haydn: Symphonies 99 - 104	8.99	/placeholder.gif
110	10	219	A Soprano Inspired	8.99	/placeholder.gif
111	10	221	Wagner: Favourite Overtures	8.99	/placeholder.gif
112	10	223	Tchaikovsky: The Nutcracker	8.99	/placeholder.gif
113	10	224	The Last Night of the Proms	8.99	/placeholder.gif
114	10	226	Respighi:Pines of Rome	8.99	/placeholder.gif
115	10	226	Strauss: Waltzes	8.99	/placeholder.gif
116	10	229	Carmina Burana	8.99	/placeholder.gif
117	10	230	A Copland Celebration, Vol. I	8.99	/placeholder.gif
118	10	231	Bach: Toccata & Fugue in D Minor	8.99	/placeholder.gif
119	10	232	Prokofiev: Symphony No.1	8.99	/placeholder.gif
120	10	233	Scheherazade	8.99	/placeholder.gif
121	10	234	Bach: The Brandenburg Concertos	8.99	/placeholder.gif
122	10	236	Mascagni: Cavalleria Rusticana	8.99	/placeholder.gif
123	10	237	Sibelius: Finlandia	8.99	/placeholder.gif
124	10	242	Adams, John: The Chairman Dances	8.99	/placeholder.gif
125	10	245	Berlioz: Symphonie Fantastique	8.99	/placeholder.gif
126	10	245	Prokofiev: Romeo & Juliet	8.99	/placeholder.gif
127	10	247	English Renaissance	8.99	/placeholder.gif
128	10	248	Mozart: Symphonies Nos. 40 & 41	8.99	/placeholder.gif
129	10	250	SCRIABIN: Vers la flamme	8.99	/placeholder.gif
130	10	255	Bartok: Violin & Viola Concertos	8.99	/placeholder.gif
131	10	259	South American Getaway	8.99	/placeholder.gif
132	10	260	Górecki: Symphony No. 3	8.99	/placeholder.gif
133	10	261	Purcell: The Fairy Queen	8.99	/placeholder.gif
134	10	264	Weill: The Seven Deadly Sins	8.99	/placeholder.gif
135	10	266	Szymanowski: Piano Works, Vol. 1	8.99	/placeholder.gif
136	10	267	Nielsen: The Six Symphonies	8.99	/placeholder.gif
137	10	274	Mozart: Chamber Music	8.99	/placeholder.gif
138	2	10	The Best Of Billy Cobham	8.99	/placeholder.gif
139	2	197	Quiet Songs	8.99	/placeholder.gif
140	2	202	Worlds	8.99	/placeholder.gif
141	2	27	Quanta Gente Veio ver--Bônus De Carnaval	8.99	/placeholder.gif
142	2	53	Heart of the Night	8.99	/placeholder.gif
143	2	53	Morning Dance	8.99	/placeholder.gif
144	2	6	Warner 25 Anos	8.99	/placeholder.gif
145	2	68	Miles Ahead	8.99	/placeholder.gif
146	2	68	The Essential Miles Davis [Disc 1]	8.99	/placeholder.gif
147	2	68	The Essential Miles Davis [Disc 2]	8.99	/placeholder.gif
148	2	79	Outbreak	8.99	/placeholder.gif
149	2	89	Blue Moods	8.99	/placeholder.gif
150	3	100	Greatest Hits	8.99	/placeholder.gif
151	3	106	Ace Of Spades	8.99	/placeholder.gif
152	3	109	Motley Crue Greatest Hits	8.99	/placeholder.gif
153	3	11	Alcohol Fueled Brewtality Live! [Disc 1]	8.99	/placeholder.gif
154	3	11	Alcohol Fueled Brewtality Live! [Disc 2]	8.99	/placeholder.gif
155	3	114	Tribute	8.99	/placeholder.gif
156	3	12	Black Sabbath Vol. 4 (Remaster)	8.99	/placeholder.gif
157	3	12	Black Sabbath	8.99	/placeholder.gif
158	3	135	Mezmerize	8.99	/placeholder.gif
159	3	14	Chemical Wedding	8.99	/placeholder.gif
160	3	50	...And Justice For All	8.99	/placeholder.gif
161	3	50	Black Album	8.99	/placeholder.gif
162	3	50	Garage Inc. (Disc 1)	8.99	/placeholder.gif
163	3	50	Garage Inc. (Disc 2)	8.99	/placeholder.gif
164	3	50	Load	8.99	/placeholder.gif
165	3	50	Master Of Puppets	8.99	/placeholder.gif
166	3	50	ReLoad	8.99	/placeholder.gif
167	3	50	Ride The Lightning	8.99	/placeholder.gif
168	3	50	St. Anger	8.99	/placeholder.gif
169	3	7	Plays Metallica By Four Cellos	8.99	/placeholder.gif
170	3	87	Faceless	8.99	/placeholder.gif
171	3	88	Use Your Illusion II	8.99	/placeholder.gif
172	3	90	A Real Dead One	8.99	/placeholder.gif
173	3	90	A Real Live One	8.99	/placeholder.gif
174	3	90	Live After Death	8.99	/placeholder.gif
175	3	90	No Prayer For The Dying	8.99	/placeholder.gif
176	3	90	Piece Of Mind	8.99	/placeholder.gif
177	3	90	Powerslave	8.99	/placeholder.gif
178	3	90	Rock In Rio [CD1]	8.99	/placeholder.gif
179	3	90	Rock In Rio [CD2]	8.99	/placeholder.gif
180	3	90	Seventh Son of a Seventh Son	8.99	/placeholder.gif
181	3	90	Somewhere in Time	8.99	/placeholder.gif
182	3	90	The Number of The Beast	8.99	/placeholder.gif
183	3	98	Living After Midnight	8.99	/placeholder.gif
184	4	196	Cake: B-Sides and Rarities	8.99	/placeholder.gif
185	4	204	Temple of the Dog	8.99	/placeholder.gif
186	4	205	Carry On	8.99	/placeholder.gif
187	4	253	Carried to Dust (Bonus Track Version)	8.99	/placeholder.gif
188	4	8	Revelations	8.99	/placeholder.gif
189	6	133	In Step	8.99	/placeholder.gif
190	6	137	Live [Disc 1]	8.99	/placeholder.gif
191	6	137	Live [Disc 2]	8.99	/placeholder.gif
192	6	81	The Cream Of Clapton	8.99	/placeholder.gif
193	6	81	Unplugged	8.99	/placeholder.gif
194	6	90	Iron Maiden	8.99	/placeholder.gif
195	7	103	Barulhinho Bom	8.99	/placeholder.gif
196	7	112	Olodum	8.99	/placeholder.gif
197	7	113	Acústico MTV	8.99	/placeholder.gif
198	7	113	Arquivo II	8.99	/placeholder.gif
199	7	113	Arquivo Os Paralamas Do Sucesso	8.99	/placeholder.gif
200	7	145	Serie Sem Limite (Disc 1)	8.99	/placeholder.gif
201	7	145	Serie Sem Limite (Disc 2)	8.99	/placeholder.gif
202	7	155	Ao Vivo [IMPORT]	8.99	/placeholder.gif
203	7	16	Prenda Minha	8.99	/placeholder.gif
204	7	16	Sozinho Remix Ao Vivo	8.99	/placeholder.gif
205	7	17	Minha Historia	8.99	/placeholder.gif
206	7	18	Afrociberdelia	8.99	/placeholder.gif
207	7	18	Da Lama Ao Caos	8.99	/placeholder.gif
208	7	20	Na Pista	8.99	/placeholder.gif
209	7	201	Duos II	8.99	/placeholder.gif
210	7	21	Sambas De Enredo 2001	8.99	/placeholder.gif
211	7	21	Vozes do MPB	8.99	/placeholder.gif
212	7	24	Chill: Brazil (Disc 1)	8.99	/placeholder.gif
213	7	27	Quanta Gente Veio Ver (Live)	8.99	/placeholder.gif
214	7	37	The Best of Ed Motta	8.99	/placeholder.gif
215	7	41	Elis Regina-Minha História	8.99	/placeholder.gif
216	7	42	Milton Nascimento Ao Vivo	8.99	/placeholder.gif
217	7	42	Minas	8.99	/placeholder.gif
218	7	46	Jorge Ben Jor 25 Anos	8.99	/placeholder.gif
219	7	56	Meus Momentos	8.99	/placeholder.gif
220	7	6	Chill: Brazil (Disc 2)	8.99	/placeholder.gif
221	7	72	Vinicius De Moraes	8.99	/placeholder.gif
222	7	77	Cássia Eller - Sem Limite [Disc 1]	8.99	/placeholder.gif
223	7	80	Djavan Ao Vivo - Vol. 02	8.99	/placeholder.gif
224	7	80	Djavan Ao Vivo - Vol. 1	8.99	/placeholder.gif
225	7	81	Unplugged	8.99	/placeholder.gif
226	7	83	Deixa Entrar	8.99	/placeholder.gif
227	7	86	Roda De Funk	8.99	/placeholder.gif
228	7	96	Jota Quest-1995	8.99	/placeholder.gif
229	7	99	Mais Do Mesmo	8.99	/placeholder.gif
230	8	100	Greatest Hits	8.99	/placeholder.gif
231	8	151	UB40 The Best Of - Volume Two [UK]	8.99	/placeholder.gif
232	8	19	Acústico MTV [Live]	8.99	/placeholder.gif
233	8	19	Cidade Negra - Hits	8.99	/placeholder.gif
234	9	21	Axé Bahia 2001	8.99	/placeholder.gif
235	9	252	Frank	8.99	/placeholder.gif
236	5	276	Le Freak	8.99	/placeholder.gif
237	5	278	MacArthur Park Suite	8.99	/placeholder.gif
238	5	277	Ring My Bell	8.99	/placeholder.gif
\.


--
-- Name: albums_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('albums_seq', 1, false);


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: Tonyx
--

COPY artists (artistid, name) FROM stdin;
1	AC/DC
2	Accept
3	Aerosmith
4	Alanis Morissette
5	Alice In Chains
6	Antônio Carlos Jobim
7	Apocalyptica
8	Audioslave
9	Billy Cobham
10	Black Label Society
11	Black Sabbath
12	Bruce Dickinson
13	Buddy Guy
14	Caetano Veloso
15	Chico Buarque
16	Chico Science & Nação Zumbi
17	Cidade Negra
18	Cláudio Zoli
19	Various Artists
20	Led Zeppelin
21	Frank Zappa & Captain Beefheart
22	Marcos Valle
23	Gilberto Gil
24	Ed Motta
25	Elis Regina
26	Milton Nascimento
27	Jorge Ben
28	Metallica
29	Queen
30	Kiss
31	Spyro Gyra
32	David Coverdale
33	Gonzaguinha
34	Deep Purple
35	Santana
36	Miles Davis
37	Vinícius De Moraes
38	Creedence Clearwater Revival
39	Cássia Eller
40	Dennis Chambers
41	Djavan
42	Eric Clapton
43	Faith No More
44	Falamansa
45	Foo Fighters
46	Funk Como Le Gusta
47	Godsmack
48	Guns N' Roses
49	Incognito
50	Iron Maiden
51	Jamiroquai
52	Jimi Hendrix
53	Joe Satriani
54	Jota Quest
55	Judas Priest
56	Legião Urbana
57	Lenny Kravitz
58	Lulu Santos
59	Marillion
60	Marisa Monte
61	Men At Work
62	Motörhead
63	Mötley Crüe
64	Nirvana
65	O Terço
66	Olodum
67	Os Paralamas Do Sucesso
68	Ozzy Osbourne
69	Page & Plant
70	Paul D'Ianno
71	Pearl Jam
72	Pink Floyd
73	R.E.M.
74	Raul Seixas
75	Red Hot Chili Peppers
76	Rush
77	Skank
78	Soundgarden
79	Stevie Ray Vaughan & Double Trouble
80	Stone Temple Pilots
81	System Of A Down
82	Terry Bozzio, Tony Levin & Steve Stevens
83	The Black Crowes
84	The Cult
85	The Doors
86	The Police
87	The Rolling Stones
88	The Who
89	Tim Maia
90	U2
91	UB40
92	Van Halen
93	Velvet Revolver
94	Zeca Pagodinho
95	Dread Zeppelin
96	Scorpions
97	Cake
98	Aisha Duo
99	The Posies
100	Luciana Souza/Romero Lubambo
101	Aaron Goldberg
102	Nicolaus Esterhazy Sinfonia
103	Temple of the Dog
104	Chris Cornell
105	Alberto Turco & Nova Schola Gregoriana
106	English Concert & Trevor Pinnock
107	Wilhelm Kempff
108	Yo-Yo Ma
109	Scholars Baroque Ensemble
110	Royal Philharmonic Orchestra & Sir Thomas Beecham
111	Britten Sinfonia, Ivor Bolton & Lesley Garrett
112	Sir Georg Solti & Wiener Philharmoniker
113	London Symphony Orchestra & Sir Charles Mackerras
114	Barry Wordsworth & BBC Concert Orchestra
115	Eugene Ormandy
116	Boston Symphony Orchestra & Seiji Ozawa
117	Aaron Copland & London Symphony Orchestra
118	Ton Koopman
119	Sergei Prokofiev & Yuri Temirkanov
120	Chicago Symphony Orchestra & Fritz Reiner
121	Orchestra of The Age of Enlightenment
122	James Levine
123	Berliner Philharmoniker & Hans Rosbaud
124	Maurizio Pollini
125	Gustav Mahler
126	Edo de Waart & San Francisco Symphony
127	Choir Of Westminster Abbey & Simon Preston
128	Michael Tilson Thomas & San Francisco Symphony
129	The King's Singers
130	Berliner Philharmoniker & Herbert Von Karajan
131	Christopher O'Riley
132	Fretwork
133	Amy Winehouse
134	Calexico
135	Yehudi Menuhin
136	Les Arts Florissants & William Christie
137	The 12 Cellists of The Berlin Philharmonic
138	Adrian Leaper & Doreen de Feis
139	Roger Norrington, London Classical Players
140	Kent Nagano and Orchestre de l'Opéra de Lyon
141	Julian Bream
142	Martin Roscoe
143	Göteborgs Symfoniker & Neeme Järvi
144	Gerald Moore
145	Mela Tenenbaum, Pro Musica Prague & Richard Kapp
146	Nash Ensemble
147	Chic
148	Anita Ward
149	Donna Summer
150	Accept
151	Aerosmith
152	Alanis Morissette
153	Alice In Chains
154	Antônio Carlos Jobim
155	Apocalyptica
156	Audioslave
157	Billy Cobham
158	Black Label Society
159	Black Sabbath
160	Bruce Dickinson
161	Buddy Guy
162	Caetano Veloso
163	Chico Buarque
164	Chico Science & Nação Zumbi
165	Cidade Negra
166	Cláudio Zoli
167	Various Artists
168	Led Zeppelin
169	Frank Zappa & Captain Beefheart
170	Marcos Valle
171	Gilberto Gil
172	Ed Motta
173	Elis Regina
174	Milton Nascimento
175	Jorge Ben
176	Metallica
177	Queen
178	Kiss
179	Spyro Gyra
180	David Coverdale
181	Gonzaguinha
182	Deep Purple
183	Santana
184	Miles Davis
185	Vinícius De Moraes
186	Creedence Clearwater Revival
187	Cássia Eller
188	Dennis Chambers
189	Djavan
190	Eric Clapton
191	Faith No More
192	Falamansa
193	Foo Fighters
194	Funk Como Le Gusta
195	Godsmack
196	Guns N' Roses
197	Incognito
198	Iron Maiden
199	Jamiroquai
200	Jimi Hendrix
201	Joe Satriani
202	Jota Quest
203	Judas Priest
204	Legião Urbana
205	Lenny Kravitz
206	Lulu Santos
207	Marillion
208	Marisa Monte
209	Men At Work
210	Motörhead
211	Mötley Crüe
212	Nirvana
213	O Terço
214	Olodum
215	Os Paralamas Do Sucesso
216	Ozzy Osbourne
217	Page & Plant
218	Paul D'Ianno
219	Pearl Jam
220	Pink Floyd
221	R.E.M.
222	Raul Seixas
223	Red Hot Chili Peppers
224	Rush
225	Skank
226	Soundgarden
227	Stevie Ray Vaughan & Double Trouble
228	Stone Temple Pilots
229	System Of A Down
230	Terry Bozzio, Tony Levin & Steve Stevens
231	The Black Crowes
232	The Cult
233	The Doors
234	The Police
235	The Rolling Stones
236	The Who
237	Tim Maia
238	U2
239	UB40
240	Van Halen
241	Velvet Revolver
242	Zeca Pagodinho
243	Dread Zeppelin
244	Scorpions
245	Cake
246	Aisha Duo
247	The Posies
248	Luciana Souza/Romero Lubambo
249	Aaron Goldberg
250	Nicolaus Esterhazy Sinfonia
251	Temple of the Dog
252	Chris Cornell
253	Alberto Turco & Nova Schola Gregoriana
254	English Concert & Trevor Pinnock
255	Wilhelm Kempff
256	Yo-Yo Ma
257	Scholars Baroque Ensemble
258	Royal Philharmonic Orchestra & Sir Thomas Beecham
259	Britten Sinfonia, Ivor Bolton & Lesley Garrett
260	Sir Georg Solti & Wiener Philharmoniker
261	London Symphony Orchestra & Sir Charles Mackerras
262	Barry Wordsworth & BBC Concert Orchestra
263	Eugene Ormandy
264	Boston Symphony Orchestra & Seiji Ozawa
265	Aaron Copland & London Symphony Orchestra
266	Ton Koopman
267	Sergei Prokofiev & Yuri Temirkanov
268	Chicago Symphony Orchestra & Fritz Reiner
269	Orchestra of The Age of Enlightenment
270	James Levine
271	Berliner Philharmoniker & Hans Rosbaud
272	Maurizio Pollini
273	Gustav Mahler
274	Edo de Waart & San Francisco Symphony
275	Choir Of Westminster Abbey & Simon Preston
276	Michael Tilson Thomas & San Francisco Symphony
277	The King's Singers
278	Berliner Philharmoniker & Herbert Von Karajan
279	Christopher O'Riley
280	Fretwork
281	Amy Winehouse
282	Calexico
283	Yehudi Menuhin
284	Les Arts Florissants & William Christie
285	The 12 Cellists of The Berlin Philharmonic
286	Adrian Leaper & Doreen de Feis
287	Roger Norrington, London Classical Players
288	Kent Nagano and Orchestre de l'Opéra de Lyon
289	Julian Bream
290	Martin Roscoe
291	Göteborgs Symfoniker & Neeme Järvi
292	Gerald Moore
293	Mela Tenenbaum, Pro Musica Prague & Richard Kapp
294	Nash Ensemble
295	Chic
296	Anita Ward
297	Donna Summer
\.


--
-- Name: artists_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('artists_seq', 297, true);


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: Tonyx
--

COPY carts (recordid, cartid, albumid, count, datecreated) FROM stdin;
\.


--
-- Name: carts_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('carts_seq', 1, false);


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: Tonyx
--

COPY genres (genreid, name, description) FROM stdin;
1	Rock	Rock and Roll is a form of rock music developed in the 1950s and 1960s. Rock music combines many kinds of music from the United States, such as country music, folk music, church music, work songs, blues and jazz.
2	Jazz	Jazz is a type of music which was invented in the United States. Jazz music combines African-American music with European music. Some common jazz instruments include the saxophone, trumpet, piano, double bass, and drums.
3	Metal	Heavy Metal is a loud, aggressive style of Rock music. The bands who play heavy-metal music usually have one or two guitars, a bass guitar and drums. In some bands, electronic keyboards, organs, or other instruments are used. Heavy metal songs are loud and powerful-sounding, and have strong rhythms that are repeated. There are many different types of Heavy Metal, some of which are described below. Heavy metal bands sometimes dress in jeans, leather jackets, and leather boots, and have long hair. Heavy metal bands sometimes behave in a dramatic way when they play their instruments or sing. However, many heavy metal bands do not like to do this.
4	Alternative	Alternative rock is a type of rock music that became popular in the 1980s and became widely popular in the 1990s. Alternative rock is made up of various subgenres that have come out of the indie music scene since the 1980s, such as grunge, indie rock, Britpop, gothic rock, and indie pop. These genres are sorted by their collective types of punk, which laid the groundwork for alternative music in the 1970s.
5	Disco	Disco is a style of pop music that was popular in the mid-1970s. Disco music has a strong beat that people can dance to. People usually dance to disco music at bars called disco clubs. The word "disco" is also used to refer to the style of dancing that people do to disco music, or to the style of clothes that people wear to go disco dancing. Disco was at its most popular in the United States and Europe in the 1970s and early 1980s. Disco was brought into the mainstream by the hit movie Saturday Night Fever, which was released in 1977. This movie, which starred John Travolta, showed people doing disco dancing. Many radio stations played disco in the late 1970s.
6	Blues	The blues is a form of music that started in the United States during the start of the 20th century. It was started by former African slaves from spirituals, praise songs, and chants. The first blues songs were called Delta blues. These songs came from the area near the mouth of the Mississippi River.
7	Latin	Latin American music is the music of all countries in Latin America (and the Caribbean) and comes in many varieties. Latin America is home to musical styles such as the simple, rural conjunto music of northern Mexico, the sophisticated habanera of Cuba, the rhythmic sounds of the Puerto Rican plena, the symphonies of Heitor Villa-Lobos, and the simple and moving Andean flute. Music has played an important part recently in Latin America's politics, the nueva canción movement being a prime example. Latin music is very diverse, with the only truly unifying thread being the use of Latin-derived languages, predominantly the Spanish language, the Portuguese language in Brazil, and to a lesser extent, Latin-derived creole languages, such as those found in Haiti.
8	Reggae	Reggae is a music genre first developed in Jamaica in the late 1960s. While sometimes used in a broader sense to refer to most types of Jamaican music, the term reggae more properly denotes a particular music style that originated following on the development of ska and rocksteady.
9	Pop	Pop music is a music genre that developed from the mid-1950s as a softer alternative to rock 'n' roll and later to rock music. It has a focus on commercial recording, often oriented towards a youth market, usually through the medium of relatively short and simple love songs. While these basic elements of the genre have remained fairly constant, pop music has absorbed influences from most other forms of popular music, particularly borrowing from the development of rock music, and utilizing key technological innovations to produce new variations on existing themes.
10	Classical	Classical music is a very general term which normally refers to the standard music of countries in the Western world. It is music that has been composed by musicians who are trained in the art of writing music (composing) and written down in music notation so that other musicians can play it. Classical music can also be described as "art music" because great art (skill) is needed to compose it and to perform it well. Classical music differs from pop music because it is not made just in order to be popular for a short time or just to be a commercial success.
11	Rock	Rock and Roll is a form of rock music developed in the 1950s and 1960s. Rock music combines many kinds of music from the United States, such as country music, folk music, church music, work songs, blues and jazz.
\.


--
-- Name: genres_genreid_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('genres_genreid_seq', 11, true);


--
-- Name: genres_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('genres_seq', 1, true);


--
-- Name: orderdetail_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('orderdetail_seq', 1, false);


--
-- Data for Name: orderdetails; Type: TABLE DATA; Schema: public; Owner: Tonyx
--

COPY orderdetails (orderdetailid, orderid, albumid, quantity, unitprice) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: Tonyx
--

COPY orders (orderid, orderdate, username, firstname, lastname, address, city, state, postalcode, country, phone, email, total) FROM stdin;
\.


--
-- Name: orders_seq; Type: SEQUENCE SET; Schema: public; Owner: Tonyx
--

SELECT pg_catalog.setval('orders_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: Tonyx
--

COPY users (userid, username, email, password, role) FROM stdin;
1	admin	admin@example@com	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918	admin
\.


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (albumid);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (artistid);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (recordid);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (genreid);


--
-- Name: orderdetails orderdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY orderdetails
    ADD CONSTRAINT orderdetails_pkey PRIMARY KEY (orderdetailid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (userid);


--
-- Name: carts albumfk; Type: FK CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT albumfk FOREIGN KEY (albumid) REFERENCES albums(albumid) MATCH FULL;


--
-- Name: orderdetails albumidfk; Type: FK CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY orderdetails
    ADD CONSTRAINT albumidfk FOREIGN KEY (albumid) REFERENCES albums(albumid);


--
-- Name: albums artistfk; Type: FK CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT artistfk FOREIGN KEY (artistid) REFERENCES artists(artistid) MATCH FULL;


--
-- Name: albums genrefk; Type: FK CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY albums
    ADD CONSTRAINT genrefk FOREIGN KEY (genreid) REFERENCES genres(genreid) MATCH FULL;


--
-- Name: orderdetails orderidfk; Type: FK CONSTRAINT; Schema: public; Owner: Tonyx
--

ALTER TABLE ONLY orderdetails
    ADD CONSTRAINT orderidfk FOREIGN KEY (orderid) REFERENCES orders(orderid);


--
-- PostgreSQL database dump complete
--




