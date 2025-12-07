--
-- PostgreSQL database dump
--

\restrict yK7CWiqOe2Z8SICZHMkwBdRdEBQ22R0mUDcuCeiKnfF1D5ydORIgE0UYj2qy18K

-- Dumped from database version 16.11
-- Dumped by pg_dump version 16.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.card (
    card_id integer NOT NULL,
    card_name character varying(100) NOT NULL,
    card_type character varying(50) NOT NULL,
    domain character varying(50),
    energy integer,
    power integer,
    might integer,
    ability_text text,
    artist character varying(100) NOT NULL,
    collector_number character varying(80) NOT NULL,
    flavor_text text,
    CONSTRAINT card_energy_check CHECK ((energy >= 0)),
    CONSTRAINT card_might_check CHECK ((might >= 0)),
    CONSTRAINT card_power_check CHECK ((power >= 0))
);


ALTER TABLE public.card OWNER TO postgres;

--
-- Name: card_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.card_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.card_card_id_seq OWNER TO postgres;

--
-- Name: card_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.card_card_id_seq OWNED BY public.card.card_id;


--
-- Name: card_printing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.card_printing (
    printing_id character varying(20) NOT NULL,
    card_id integer NOT NULL,
    set_id integer NOT NULL,
    rarity character varying(20) NOT NULL,
    foil boolean DEFAULT false,
    alt_art boolean DEFAULT false,
    overnumbered boolean DEFAULT false,
    signed boolean DEFAULT false,
    release_date date NOT NULL,
    image_url character varying(255)
);


ALTER TABLE public.card_printing OWNER TO postgres;

--
-- Name: card_set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.card_set (
    set_id integer NOT NULL,
    set_name character varying(100) NOT NULL,
    set_code character varying(10) NOT NULL,
    release_date date NOT NULL,
    total_cards integer,
    description text,
    CONSTRAINT card_set_total_cards_check CHECK ((total_cards > 0))
);


ALTER TABLE public.card_set OWNER TO postgres;

--
-- Name: card_set_set_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.card_set_set_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.card_set_set_id_seq OWNER TO postgres;

--
-- Name: card_set_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.card_set_set_id_seq OWNED BY public.card_set.set_id;


--
-- Name: collection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection (
    collection_id integer NOT NULL,
    user_id integer NOT NULL,
    collection_name character varying(100) DEFAULT 'My Collection'::character varying,
    date_created date DEFAULT CURRENT_DATE NOT NULL,
    is_primary boolean DEFAULT true
);


ALTER TABLE public.collection OWNER TO postgres;

--
-- Name: collection_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collection_card (
    collection_id integer NOT NULL,
    printing_id character varying(20) NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    condition character varying(20),
    date_added date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT collection_card_condition_check CHECK (((condition)::text = ANY ((ARRAY['Mint'::character varying, 'Near Mint'::character varying, 'Excellent'::character varying, 'Good'::character varying, 'Played'::character varying, 'Poor'::character varying])::text[]))),
    CONSTRAINT collection_card_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.collection_card OWNER TO postgres;

--
-- Name: collection_collection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.collection_collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.collection_collection_id_seq OWNER TO postgres;

--
-- Name: collection_collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.collection_collection_id_seq OWNED BY public.collection.collection_id;


--
-- Name: deck; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deck (
    deck_id integer NOT NULL,
    user_id integer NOT NULL,
    deck_name character varying(100) NOT NULL,
    primary_domain character varying(20),
    date_created date DEFAULT CURRENT_DATE NOT NULL,
    last_modified date DEFAULT CURRENT_DATE NOT NULL,
    description text
);


ALTER TABLE public.deck OWNER TO postgres;

--
-- Name: deck_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deck_card (
    deck_id integer NOT NULL,
    printing_id character varying(20) NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT deck_card_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.deck_card OWNER TO postgres;

--
-- Name: deck_deck_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deck_deck_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deck_deck_id_seq OWNER TO postgres;

--
-- Name: deck_deck_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deck_deck_id_seq OWNED BY public.deck.deck_id;


--
-- Name: set; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.set (
    set_id integer NOT NULL,
    set_name character varying(100) NOT NULL,
    set_code character varying(10) NOT NULL,
    release_date date NOT NULL,
    total_cards integer,
    description text,
    CONSTRAINT set_total_cards_check CHECK ((total_cards > 0))
);


ALTER TABLE public.set OWNER TO postgres;

--
-- Name: set_set_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.set_set_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.set_set_id_seq OWNER TO postgres;

--
-- Name: set_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.set_set_id_seq OWNED BY public.set.set_id;


--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    tag_id integer NOT NULL,
    tag_name character varying(50) NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tag_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tag_tag_id_seq OWNER TO postgres;

--
-- Name: tag_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tag_tag_id_seq OWNED BY public.tag.tag_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    date_joined date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: card card_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card ALTER COLUMN card_id SET DEFAULT nextval('public.card_card_id_seq'::regclass);


--
-- Name: card_set set_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_set ALTER COLUMN set_id SET DEFAULT nextval('public.card_set_set_id_seq'::regclass);


--
-- Name: collection collection_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection ALTER COLUMN collection_id SET DEFAULT nextval('public.collection_collection_id_seq'::regclass);


--
-- Name: deck deck_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck ALTER COLUMN deck_id SET DEFAULT nextval('public.deck_deck_id_seq'::regclass);


--
-- Name: set set_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.set ALTER COLUMN set_id SET DEFAULT nextval('public.set_set_id_seq'::regclass);


--
-- Name: tag tag_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag ALTER COLUMN tag_id SET DEFAULT nextval('public.tag_tag_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.card (card_id, card_name, card_type, domain, energy, power, might, ability_text, artist, collector_number, flavor_text) FROM stdin;
1	Blazing Scorcher	Unit	Fury	5	\N	5	ACCELERATE (You may pay --- as an additional cost to have me enter ready.)	Envar Studio	OGN-001/298	\N
2	Brazen Buccaneer	Unit	Fury	6	\N	5	As you play me, you may discard 1 as an additional cost. If you do, reduce my cost by.	Six More Vodka	OGN-002/298	"They called my crew 'scurvy dogs' and I took that personally."
3	Chemtech Enforcer	Unit	Fury	2	\N	2	[Assault 2] (+2 while I'm an attacker.) When you play me, discard 1.	Six More Vodka	OGN-003/298	"Knock, knock."
4	Cleave	Spell	Fury	1	\N	\N	[Action] (Play on your turn or in showdowns.) Give a unit [Assault 3] this turn. (+3 while it's an attacker.)	Kudos Productions	OGN-004/298	Nobody ever won a war without attacking.
5	Disintegrate	Spell	Fury	4	\N	\N	[Action] (Play on your turn or in showdowns.) Deal 3 to a unit at a battlefield. If this kills it, draw 1.	Kudos Productions	OGN-005/298	"Ashes, ashes, they all fall down." -Annie
6	Flame Chompers	Unit	Fury	3	\N	3	When you discard me, you may pay 1 fury to play me.	Six More Vodka	OGN-006/298	"GET 'EM, CHOMPIES!" -Jinx
7	Fury Rune	Rune	Fury	\N	\N	\N	\N	Greg Ghielmetti & Leah Chen	OGN-007/298	\N
8	Get Excited!	Spell	Fury	2	1	\N	[Action] (Play on your turn or in showdowns.) Discard 1. Deal its Energy cost as damage to a unit at a battlefield. (Ignore its Power cost.)	Original Force Studio	OGN-008/298	"Everybody, panic!" -Jinx
9	Hextech Ray	Spell	Fury	1	1	\N	[Action] (Play on your turn or in showdowns.) Deal 3 to a unit at a battlefield.	League of Legends	OGN-009/298	"Destroy. Then Improve." -Viktor
10	Legion Rearguard	Unit	Fury	2	\N	2	[Accelerate] (You may pay as an additional cost to have me enter ready.)	Six More Vodka	OGN-010/298	The last line of offense.
11	Magma Wurm	Unit	Fury	8	1	8	Other friendly units enter ready.	Envar Studio	OGN-011/298	A river of flame in an ocean of ice.
12	Noxus Hopeful	Unit	Fury	4	\N	4	[Legion] - I cost less. (Get the effect if you've played another card this turn.)	Six More Vodka	OGN-012/298	First to the front, first to glory.
13	Pouty Poro	Unit	Fury	2	\N	2	[Deflect] (Opponents must pay to choose me with a spell or ability.)	Caravan Studio	OGN-013/298	"Braum takes medicine too, see?" -Braum
14	Sky Splitter	Spell	Fury	9	1	\N	[Action] (Play on your turn or in showdowns.) This spell's Energy cost is reduced by the highest Might among units you control. Deal 5 to a unit at a battlefield.	Polar Engine Studio	OGN-014/298	"Puny mortals!" -Volibear
15	Captain Farron	Unit	Fury	4	1	5	Other friendly units here have [Assault]. (+1 while they're attackers.)	Six More Vodka	OGN-015/298	"Forward! Always!"
16	Dangerous Duo	Unit	Fury	3	\N	3	[Legion] - When you play me, give a unit +2 this turn. (Get the effect if you've played another card this turn.)	Envar Studio	OGN-016/298	\N
17	Iron Ballista	Gear	Fury	3	\N	\N	This enters exhausted.: Deal 2 to a unit at a battlefield.	Kudos Productions	OGN-017/298	"There's no way they can hit us at this dist--AUGH!"
18	Noxus Saboteur	Unit	Fury	3	\N	3	Your opponents' [Hidden] cards can't be revealed here.	Six More Vodka	OGN-018/298	Nothing fails like a perfect plan.
19	Raging Soul	Unit	Fury	4	\N	4	If you've discarded a card this turn, I have [Assault] and [Ganking]. (+1 while I'm an attacker. I can move from battlefield to battlefield.)	Six More Vodka	OGN-019/298	\N
20	Scrapyard Champion	Unit	Fury	5	1	5	[Legion] - When you play me, discard 2, then draw 2. (Get the effect if you've played another card this turn.)	Envar Studio	OGN-020/298	"Last one standing" is a bit subjective.
21	Sun Disc	Gear	Fury	2	1	\N	: [Legion] - The next unit you play this turn enters ready. (Get the effect if you've played another card this turn.)	Envar Studio	OGN-021/298	"Those who follow me follow destiny!" -Azir
22	Thermo Beam	Spell	Fury	5	2	\N	[Action] (Play on your turn or in showdowns.) Kill all gear.	Max Grecke	OGN-022/298	"Turn the limiter off, the beam is totally stable." -Common last words
23	Unlicensed Armory	Gear	Fury	2	\N	\N	Discard 1,: Choose a friendly unit. The next time it dies this turn, you may pay to recall it exhausted instead. (Send it to base. This isn't a move.)	Kudos Productions	OGN-023/298	\N
24	Void Seeker	Spell	Fury	3	1	\N	[Action] (Play on your turn or in showdowns.) Deal 4 to a unit at a battlefield. Draw 1.	Kudos Productions	OGN-024/298	"It's a good day for a hunt." -Kai'sa
25	Blind Fury	Spell	Fury	4	2	\N	[Action] (Play on your turn or in showdowns.) Each opponent reveals the top card of their Main Deck. Choose one and play it, ignoring its cost. Then recycle the rest.	Six More Vodka	OGN-025/298	\N
26	Brynhir Thundersong	Unit	Fury	6	\N	5	When you play me, opponents can't play cards this turn.	Envar Studio	OGN-026/298	"Silence. The sky speaks."
27	Darius, Trifarian	Champion Unit	Fury	5	1	5	When you play your second card in a turn, give me +2 this turn and ready me.	League Splash Team	OGN-027/298	"With overwhelming force."
28	Draven, Showboat	Champion Unit	Fury	5	1	3	My Might is increased by your points.	Six More Vodka	OGN-028/298	"Let's admire me for a bit."
29	Falling Star	Spell	Fury	2	2	\N	Do this twice: Deal 3 to a unit. (You can choose different units.)	Kudos Productions	OGN-029/298	\N
30	Jinx, Demolitionist	Champion Unit	Fury	3	1	4	[Accelerate] (You may pay as an additional cost to have me enter ready.) [Assault 2] (+2 while I'm an attacker.) When you play me, discard 2.	Kudos Productions	OGN-030/298	"I really need a new gun. But don't tell my other guns."
31	Raging Firebrand	Unit	Fury	6	1	4	When you play me, the next spell you play this turn costs less.	JiHun Lee	OGN-031/298	\N
32	Ravenborn Tome	Gear	Fury	3	\N	\N	: The next spell you play deals 1 Bonus Damage. (Each instance of damage the spell deals is increased by 1.)	Polar Engine Studio	OGN-032/298	The book is bound in flame-resistant materials, for obvious reasons.
33	Shakedown	Spell	Fury	2	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Choose an enemy unit. Deal 6 to it unless its controller has you draw 2.	Kudos Productions	OGN-033/298	"Blink once for yes."
34	Tryndamere, Barbarian	Champion Unit	Fury	7	2	8	When I conquer after an attack, if you assigned 5 or more excess damage to enemy units, you score 1 point.	Six More Vodka	OGN-034/298	"You never stood a chance."
35	Vayne, Hunter	Champion Unit	Fury	4	1	2	[Assault 3] (+3 while I'm an attacker.) If an opponent controls a battlefield, I enter ready. When I conquer, you may pay to return me to my owner's hand.	Kudos Productions	OGN-035/298	"On wings of night."
36	Vi, Destructive	Champion Unit	Fury	2	1	3	[Ganking] (I can move from battlefield to battlefield.)	Kudos Productions	OGN-036/298	"Punch first. Ask questions while punching."
37	Immortal Phoenix	Unit	Fury	3	1	3	[Assault 2] (+2 while I'm an attacker.) When you kill a unit with a spell, you may pay to play me from your trash.	Kudos Productions	OGN-037/298	The memory of every death fuels even brighter flames.
38	Kadregrin the Infernal	Unit	Fury	9	2	\N	When you play me, draw 1 for each of your [Mighty] units. (A unit is Mighty while it has 5+ .)	Six More Vodka	OGN-038/298	First among flames.
39	Kai'sa, Survivor	Champion Unit	Fury	4	\N	4	[Accelerate] (You may pay as an additional cost to have me enter ready.) When I conquer, draw 1.	League Splash Team	OGN-039/298	"I like it here. I just might stay."
40	Seal of Rage	Gear	Fury	0	1	\N	: [Reaction] - [Add]. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-040/298	\N
41	Volibear, Furious	Champion Unit	Fury	10	2	9	[Deflect 2] (Opponents must pay to choose me with a spell or ability.) When I attack, deal 5 damage split among any number of enemy units here.	Envar Studio	OGN-041/298	"I split mountains with my roar!"
42	Calm Rune	Rune	Calm	\N	\N	\N	\N	Greg Ghielmetti & Leah Chen	OGN-042/298	\N
43	Charm	Spell	Calm	1	1	\N	Move an enemy unit.	Kudos Productions	OGN-043/298	"There's no harm in looking." -Common last words
44	Clockwork Keeper	Unit	Calm	2	\N	2	As you play me, you may pay 1 energy as an additional cost. If you do, draw 1.	Polar Engine Studio	OGN-044/298	It always goes back for seconds.
45	Defy	Spell	Calm	1	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Counter a spell that costs no more than and no more than.	Kudos Productions	OGN-045/298	"No."
46	En Garde	Spell	Calm	1	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Give a friendly unit +1 this turn, then an additional +1 this turn if it is the only unit you control there.	Kudos Productions	OGN-046/298	"Is this supposed to be a challenge?" -Fiora
47	Find Your Center	Spell	Calm	3	\N	\N	[Action] (Play on your turn or in showdowns.) If an opponent's score is within 3 points of the Victory Score, this costs less. Draw 1 and channel 1 rune exhausted.	Kudos Productions	OGN-047/298	One does not wait for the perfect moment.
48	Meditation	Spell	Calm	2	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) As an additional cost to play this, you may exhaust a friendly unit. If you do, draw 2. Otherwise, draw 1.	Kudos Productions	OGN-048/298	\N
49	Playful Phantom	Unit	Calm	5	\N	5	\N	Six More Vodka	OGN-049/298	"My toys break so easily."
50	Rune Prison	Spell	Calm	2	1	\N	[Action] (Play on your turn or in showdowns.) Stun a unit. (It doesn't deal combat damage this turn.)	Kudos Productions	OGN-050/298	"Be still!" -Ryze
51	Solari Shieldbearer	Unit	Calm	3	\N	2	When you play me, stun a unit. (It doesn't deal combat damage this turn.)	Kudos Productions	OGN-051/298	"Discipline is our shield."
52	Stalwart Poro	Unit	Calm	2	\N	2	[Shield] (+1 while I'm a defender.)	Six More Vodka	OGN-052/298	It suits him.
53	Stand United	Spell	Calm	3	\N	\N	[Hidden] (Hide now for to react with later for.) [Action] (Play on your turn or in showdowns.) Buff a friendly unit. Buffs give an additional +1 to friendly units this turn. (To buff a unit, give it a +1 buff if it doesn't already have one.)	Six More Vodka	OGN-053/298	\N
54	Sunlit Guardian	Unit	Calm	3	\N	3	[Shield] (+1 while I'm a defender.) [Tank] (I must be assigned combat damage first.)	Kudos Productions	OGN-054/298	Nobody ever won a war without defending.
55	Wielder of Water	Unit	Calm	3	\N	2	While I'm attacking or defending alone, I have +2.	Six More Vodka	OGN-055/298	Each drop an ocean of possibilities.
56	Adapatron	Unit	Calm	4	\N	3	When I conquer, you may kill a gear. If you do, buff me. (If I don't have a buff, I get a +1 buff.)	Kudos Productions	OGN-056/298	There's a scrap for that.
57	Block	Spell	Calm	2	\N	\N	[Hidden] (Hide now for to react with later for.) [Action] (Play on your turn or in showdowns.) Give a unit [Shield 3] and [Tank] this turn. (+3 while it's a defender. It must be assigned combat damage first.)	Kudos Productions	OGN-057/298	\N
58	Discipline	Spell	Calm	2	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Give a unit +2 this turn. Draw 1.	Kudos Productions	OGN-058/298	A blade is only as sharp as the one who wields it.
59	Eclipse Herald	Unit	Calm	7	1	7	When you stun an enemy unit, ready me and give me +1 this turn.	Kudos Productions	OGN-059/298	An omen as terrifying as that which follows.
60	Mask of Foresight	Gear	Calm	2	\N	\N	When a friendly unit attacks or defends alone, give it +1 this turn.	Kudos Productions	OGN-060/298	To know the future, you must first accept it.
61	Poro Herder	Unit	Calm	3	1	3	When you play me, if you control a Poro, buff me and draw 1. (If I don't have a buff, I get a +1 buff.)	Six More Vodka	OGN-061/298	A fluff is where you make it.
62	Reinforce	Spell	Calm	5	\N	\N	Look at the top 5 cards of your Main Deck. You may play a unit from among them. Its Energy cost is reduced by. Then recycle the remaining cards.	Kudos Productions	OGN-062/298	\N
63	Spirit's Refuge	Gear	Calm	2	1	\N	When you play this, buff a friendly unit. (If it doesn't have a buff, it gets a +1 buff.) Friendly buffed units have [Deflect] if they didn't already. (Opponents must pay to choose those units with a spell or ability.)	Kudos Productions	OGN-063/298	\N
64	Wind Wall	Spell	Calm	3	2	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Counter a spell.	Max Grecke	OGN-064/298	"Face the wind!" -Yasuo
65	Wizened Elder	Unit	Calm	4	\N	4	While I'm buffed, I have an additional +1.	Six More Vodka	OGN-065/298	"I'm still fighting at my age. That should concern you more than it does."
66	Ahri, Alluring	Champion Unit	Calm	5	1	4	When I hold, you score 1 point.	League Splash Team	OGN-066/298	"Remember this moment."
67	Blitzcrank, Impassive	Champion Unit	Calm	5	1	5	[Tank] (I must be assigned combat damage first.) When you play me to a battlefield, you may move an enemy unit to here. When I hold, return me to my owner's hand.	League Splash Team	OGN-067/298	\N
68	Caitlyn, Patrolling	Champion Unit	Calm	3	1	3	I must be assigned combat damage last.: Deal damage equal to my Might to a unit at a battlefield. Use this ability only while I'm at a battlefield.	Six More Vodka	OGN-068/298	"I never miss."
69	Last Stand	Spell	Calm	3	1	\N	[Action] (Play on your turn or in showdowns.) Double a friendly unit's Might this turn. Give it [Temporary]. (Kill it at the start of its controller's Beginning Phase, before scoring.)	Kudos Productions	OGN-069/298	Worth it.
70	Mageseeker Warden	Unit	Calm	6	1	5	While I'm at a battlefield, opponents can only play units to their base. While I'm at a battlefield, spells and abilities can't ready enemy units and gear.	Six More Vodka	OGN-070/298	\N
71	Party Favors	Spell	Calm	3	\N	\N	Each other player chooses Cards or Runes. For each player that chooses Cards, you and that player each draw 1. For each player that chooses Runes, you and that player each channel 1 rune exhausted.	Kudos Productions	OGN-071/298	\N
72	Solari Shrine	Gear	Calm	3	\N	\N	When you kill a stunned enemy unit, you may exhaust this to draw 1.	Kudos Productions	OGN-072/298	The names of the fallen are a lesson for our descendants.
73	Sona, Harmonious	Champion Unit	Calm	4	1	4	While I'm at a battlefield, ready 4 friendly runes at the end of your turn.	League Splash Team	OGN-073/298	"The symphony never ends."
74	Taric, Protector	Champion Unit	Calm	4	1	4	[Shield] (+1 while I'm a defender.) [Tank] (I must be assigned combat damage first.) Other friendly units here have [Shield].	Six More Vodka	OGN-074/298	"Each life is a rare jewel."
75	Tasty Faefolk	Unit	Calm	7	\N	6	[Accelerate] (You may pay as an additional cost to have me enter ready.) [Deathknell] - Channel 2 runes exhausted and draw 1. (When I die, get the effect.)	Dao Trong Le	OGN-075/298	\N
76	Yasuo, Remorseful	Champion Unit	Calm	6	2	6	When I attack, deal damage equal to my Might to an enemy unit here.	Six More Vodka	OGN-076/298	"Is a leaf's only purpose to fall?"
77	Zhonya's Hourglass	Gear	Calm	2	\N	\N	[Hidden] (Hide now for to react with later for.) The next time a friendly unit would die, kill this instead. Recall that unit exhausted. (Send it to base. This isn't a move.)	Kudos Productions	OGN-077/298	\N
78	Lee Sin, Ascetic	Champion Unit	Calm	5	1	5	[Shield] (+1 while I'm a defender.): Buff me. (I get a +1 buff.) I can have any number of buffs.	Six More Vodka	OGN-078/298	"Let us see whose spirit is stronger."
79	Leona, Zealot	Champion Unit	Calm	6	1	6	If an opponent's score is within 3 points of the Victory Score, I enter ready. Stunned enemy units here have -8, to a minimum of 1.	Six More Vodka	OGN-079/298	"Feel the sun's glory!"
80	Mystic Reversal	Spell	Calm	4	3	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Gain control of a spell. You may make new choices for it.	Polar Engine Studio	OGN-080/298	Good mages borrow, great mages steal.
81	Seal of Focus	Gear	Calm	0	1	\N	: [Reaction] - [Add]. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-081/298	\N
82	Whiteflame Protector	Unit	Calm	8	2	8	When you play me, give a unit +8 this turn.	Aron Elekes	OGN-082/298	A dragon is capable of nobility equal to its rage.
83	Consult the Past	Spell	Mind	4	\N	\N	[Hidden] (Hide now for to react with later for.) [Reaction] (Play any time, even before spells and abilities resolve.) Draw 2.	Kudos Productions	OGN-083/298	\N
84	Eager Apprentice	Unit	Mind	3	\N	3	While I'm at a battlefield, the Energy costs for spells you play is reduced by 1, to a minimum of 1	Six More Vodka	OGN-084/298	"As long as these thirty-seven things go right, it'll work every time!"
85	Falling Comet	Spell	Mind	5	\N	\N	[Action] (Play on your turn or in showdowns.) Deal 6 to a unit at a battlefield.	Kudos Productions	OGN-085/298	Just an everyday celestial event.
86	Jeweled Colossus	Unit	Mind	5	\N	5	[Vision] (When you play me, look at the top card of your Main Deck. You may recycle it.) [Shield] (+1 while I'm a defender.)	Kudos Productions	OGN-086/298	\N
87	Lecturing Yordle	Unit	Mind	3	\N	2	[Tank] (I must be assigned combat damage first.) When you play me, draw 1.	Kudos Productions	OGN-087/298	"...poisonous, but I didn't know that at the time. You see..."
88	Mega-Mech	Unit	Mind	7	\N	8	\N	Valentin Gloaguen	OGN-088/298	Mech fights have two rules: One- No cheating. Two- Don't get caught cheating.
89	Mind Rune	Rune	Mind	\N	\N	\N	\N	Greg Ghielmetti & Leah Chen	OGN-089/298	\N
90	Orb of Regret	Gear	Mind	1	\N	\N	Exhaust: Give a unit -1 this turn, to a minimum of 1.	Kudos Productions	OGN-090/298	"There's beauty in even the most painful memories." -Ahri
91	Pit Crew	Unit	Mind	3	\N	3	When you play a gear, ready me.	Chris Kintner	OGN-091/298	"GOOD ENOUGH LET'S GOOOO!"
92	Riptide Rex	Unit	Mind	6	2	6	When you play me, deal 6 to an enemy unit at a battlefield.	MAR Studio	OGN-092/298	"Rainin' fire!"
93	Smoke Screen	Spell	Mind	2	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Give a unit -4 this turn, to a minimum of 1	Kudos Productions	OGN-093/298	"Well, well, well. What have we here?"
94	Sprite Call	Spell	Mind	3	\N	\N	[Hidden] (Hide now for to react with later for.) [Action] (Play on your turn or in showdowns.) Play a ready 3 Sprite unit token with [Temporary]. (Kill it at the start of its controller's Beginning Phase, before scoring.)	Envar Studio	OGN-094/298	\N
95	Stupefy	Spell	Mind	1	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Give a unit -1 this turn, to a minimum of 1. Draw 1.	Kudos Productions	OGN-095/298	It's easier to outsmart an opponent with a concussion.
96	Watchful Sentry	Unit	Mind	2	\N	1	[Deathknell] - Draw 1. (When I die, get the effect.)	Six More Vodka	OGN-096/298	He may never see home again. But because of that, home still stands.
97	Blastcone Fae	Unit	Mind	2	1	2	[Hidden] (Hide now for to react with later for.) When you play me, give a unit -2 this turn, to a minimum of 1	Caravan Studio	OGN-097/298	\N
98	Energy Conduit	Gear	Mind	3	\N	\N	Exhaust: [Reaction] - [Add] 1 Energy. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-098/298	Whatever it does, it sure does a lot of it.
99	Garbage Grabber	Gear	Mind	2	\N	\N	Recycle 3 from your trash, 1 Energy, Exhaust: Draw 1.	Caravan Studio	OGN-099/298	The constructs of the in-between feed on whatever gets lost in the portals- mostly keys and left socks.
100	Gemcraft Seer	Unit	Mind	3	1	3	[Vision] (When you play me, look at the top card of your Main Deck. You may recycle it.) Other friendly units have [Vision].	Bubble Cat Studio	OGN-100/298	The light changes with every reflection.
101	Mushroom Pouch	Gear	Mind	2	\N	\N	At the start of your Beginning Phase, if you control a facedown card at a battlefield, draw 1.	Polar Engine Studio	OGN-101/298	"A Bandle Scout is always prepared!" -Teemo
102	Portal Rescue	Spell	Mind	3	1	\N	[Action] (Play on your turn or in showdowns.) Banish a friendly unit, then its owner plays it to their base, ignoring its cost.	Kudos Productions	OGN-102/298	"Where do the portals go? You know, I've never asked." -Norra
103	Ravenbloom Student	Unit	Mind	2	\N	2	When you play a spell, give me +1 Might this turn.	Polar Engine Studio	OGN-103/298	A little knowledge is a dangerous thing. A lot of knowledge is awesome.
104	Retreat	Spell	Mind	1	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Return a friendly unit to its owner's hand. Its owner channels 1 rune exhausted.	Kudos Productions	OGN-104/298	There's always tomorrow.
105	Singularity	Spell	Mind	6	2	\N	Deal 6 to each of up to two units.	Kudos Productions	OGN-105/298	Two fates, very briefly intertwined.
106	Sprite Mother	Unit	Mind	4	1	3	When you play me, play a ready 3 Might Sprite unit token with [Temporary] here. (Kill it at the start of its controller's Beginning Phase, before scoring.)	Envar Studio	OGN-106/298	"Come, little ones."
107	Ava Achiever	Unit	Mind	5	\N	4	When I attack, you may pay 1 Mind to play a card with [Hidden] from your hand here, ignoring its cost.	Kudos Productions	OGN-107/298	"I brought snacks!"
108	Convergent Mutation	Spell	Mind	2	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Choose a friendly unit. If its Might is less than another friendly unit's, its Might becomes the Might of that friendly unit this turn.	Wild Blue Studios	OGN-108/298	"I don't know, I think it's kind of cute."
109	Dr. Mundo, Expert	Champion Unit	Mind	8	2	6	My Might is increased by the number of cards in your trash. At the start of your Beginning Phase, recycle 3 from your trash.	League Splash Team	OGN-109/298	"This not hurt a bit!"
110	Ekko, Recurrant	Champion Unit	Mind	5	1	5	[Accelerate] (You may pay 1 Power and 1 Mind as an additional cost to have me enter ready.) [Deathknell] - Recycle me to ready your runes. (When I die, get the effect.)	Six More Vodka	OGN-110/298	"Time to start some trouble."
111	Heimerdinger, Inventor	Champion Unit	Mind	3	1	3	I have all Exhaust abilities of all friendly legends, units, and gear.	Six More Vodka	OGN-111/298	"I do love a good conundrum."
112	Kai'sa, Evolutionary	Champion Unit	Mind	6	1	6	[Ganking] (I can move from battlefield to battlefield.) When I conquer, you may play a spell from your trash with Energy cost less than your points without paying its Energy cost. Then recycle it. (You must still pay its Power cost.)	Kudos Productions	OGN-112/298	\N
113	Malzahar, Fanatic	Champion Unit	Mind	4	\N	3	Kill a friendly unit or gear, Exhaust: [Action] - [Add] 2. (Use on your turn or in showdowns. Abilities that add resources can't be reacted to.)	League Splash Team	OGN-113/298	"We demand sacrifice."
114	Progress Day	Spell	Mind	6	1	\N	Draw 4.	Kudos Productions	OGN-114/298	See the dreams of a thousand tomorrows, and at such a low price!
115	Promising Future	Spell	Mind	5	1	\N	Each player looks at the top 5 cards of their Main Deck, chooses one, then recycles the rest. Starting with the next player, each player plays those cards, ignoring Energy costs. (They must still pay Power costs.)	Kudos Productions	OGN-115/298	\N
116	Thousand-Tailed Watcher	Unit	Mind	7	1	7	[Accelerate] (You may pay as an additional cost to have me enter ready.) When you play me, give enemy units -3 this turn, to a minimum of 1.	Six More Vodka	OGN-116/298	You will know when you've pushed the wilds too far.
117	Viktor, Innovator	Champion Unit	Mind	4	1	3	When you play a card on an opponent's turn, play a 1 Might Recruit unit token in your base.	League Splash Team	OGN-117/298	"Join the glorious evolution."
118	Wraith of Echoes	Unit	Mind	6	1	5	The first time a friendly unit dies each turn, draw 1.	Michal Ivan	OGN-118/298	His friends are with him in spirit.
119	Ahri, Inquisitive	Champion Unit	Mind	3	1	3	When I attack or defend, give an enemy unit here -2 Might this turn, to a minimum of 1 Might.	Six More Vodka	OGN-119/298	"The hunter and the hunted."
120	Seal of Insight	Gear	Mind	1	1	\N	Exhaust: [Reaction] - [Add] 1 Mind. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-120/298	\N
121	Teemo, Strategist	Champion Unit	Mind	2	1	2	[Hidden] (Hide now for to react with later for.) When I defend or I'm played from [Hidden], reveal the top 5 cards of your Main Deck. Deal 1 to an enemy unit here for each card with [Hidden], then recycle them.	Six More Vodka	OGN-121/298	\N
122	Time Warp	Spell	Mind	10	4	\N	Take a turn after this one. Banish this.	Kudos Productions	OGN-122/298	"Fool me once... and I'll just rewind." -Ekko
123	Unchecked Power	Spell	Mind	7	2	\N	Exhaust all friendly units, then deal 12 to ALL units at battlefields.	Kudos Productions	OGN-123/298	That's enough.
124	Arena Bar	Gear	Body	3	\N	\N	Exhaust: Buff an exhausted friendly unit. (If it doesn't have a buff, it gets a +1 Might buff.)	Kudos Productions	OGN-124/298	"This one's on the house!"
125	Bilgewater Bully	Unit	Body	6	\N	6	While I'm buffed, I have [Ganking]. (I can move from battlefield to battlefield.)	Envar Studio	OGN-125/298	Places to go, people to gank.
126	Body Rune	Rune	Body	\N	\N	\N	\N	Greg Ghielmetti & Leah Chen	OGN-126/298	\N
127	Cannon Barrage	Spell	Body	2	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Deal 2 to all enemy units in combat.	Kudos Productions	OGN-127/298	If you've got enough guns, you don't need to aim.
128	Challenge	Spell	Body	2	1	\N	[Action] (Play on your turn or in showdowns.) Choose a friendly unit and an enemy unit. They deal damage equal to their Mights to each other.	Kudos Productions	OGN-128/298	"He started it when he hit me back!"
129	Confront	Spell	Body	2	\N	\N	[Action] (Play on your turn or in showdowns.) Units you play this turn enter ready. Draw 1.	Kudos Productions	OGN-129/298	Now is the only moment that matters.
130	Crackshot Corsair	Unit	Body	3	\N	3	When I attack, deal 1 to an enemy unit here.	Six More Vodka	OGN-130/298	"Ahoy."
131	Dune Duke	Unit	Body	5	\N	5	When I attack, give me +2 Might if there is a ready enemy unit here	Bubble Cat Studio	OGN-131/298	Dragons hunt not just for food, but for the thrill of it.
132	First Mate	Unit	Body	3	\N	3	When you play me, ready another unit.	Slawomir Maniak	OGN-132/298	"It's a boarding party! Try to have some fun with it."
133	Flurry of Blades	Spell	Body	1	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Deal 1 to all units at battlefields.	Rafael Zanchetin	OGN-133/298	"Violence solves everything." -Katarina
134	Mobilize	Spell	Body	2	\N	\N	Channel 1 rune exhausted. If you can't, draw 1.	Kudos Productions	OGN-134/298	The sound of the trumpets is the first blow struck in battle.
135	Pakaa Cub	Unit	Body	3	\N	3	[Hidden] (Hide now for to react with later for.)	Bubble Cat Studio	OGN-135/298	"Oh, it's so cute!" -Common last words
136	Pit Rookie	Unit	Body	2	\N	2	When you play me, buff another friendly unit. (If it doesn't have a buff, it gets a +1 buff.)	Kudos Productions	OGN-136/298	"Is that all you got?"
137	Stormclaw Ursine	Unit	Body	7	\N	6	[Tank] (I must be assigned combat damage first.) When you play me, channel 1 rune exhausted.	Kudos Productions	OGN-137/298	"The Ursine speak for man, and the wild responds." -Volibear
138	Catalyst of Aeons	Spell	Body	4	\N	\N	Channel 2 runes exhausted. If you couldn't channel 2 runes this way, draw 1.	Kudos Productions	OGN-138/298	Ages of strife, crystallized into eternity.
139	Cithria of Cloudfield	Unit	Body	2	\N	1	When you play another unit, buff me. (If I don't have a buff, I get a +1 buff.)	Six More Vodka	OGN-139/298	Every story starts small.
140	Herald of Scales	Unit	Body	4	\N	3	Your Dragons' Energy costs are reduced by 2 Power, to a minimum of 1 Power.	Polar Engine Studio	OGN-140/298	The language of dragons is a magic of its own.
141	Kinkou Monk	Unit	Body	4	1	4	When you play me, buff two other friendly units. (Each one that doesn't have a buff gets a +1 Might buff.)	Kudos Productions	OGN-141/298	A master teaches the same lesson again and again, and learns something new each time.
142	Mountain Drake	Unit	Body	9	\N	10	\N	Kudos Productions	OGN-142/298	After centuries spent trying to understand dragon behavior, researchers can agree on one thing: If you're seeing that behavior up close... run.
143	Pirate's Haven	Gear	Body	3	\N	\N	When you ready a friendly unit, give it +1 Might this turn.	Envar Studio	OGN-143/298	It's the best place in the world, until you run out of coin.
144	Spoils of War	Spell	Body	4	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) If an enemy unit has died this turn, this costs less. Draw 2.	Kudos Productions	OGN-144/298	Waste nothing.
145	Unyielding Spirit	Spell	Body	1	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Prevent all spell and ability damage this turn.	Max Grecke	OGN-145/298	Battles are won in the heart before they are won on the field.
146	Wallop	Spell	Body	2	\N	\N	[Action] (Play on your turn or in showdowns.) As you play this, you may spend a buff as an additional cost. If you do, ignore this spell's cost. Ready a unit.	Kudos Productions	OGN-146/298	If smashing doesn't work, just keep smashing.
147	Wildclaw Shaman	Unit	Body	4	\N	\N	When you play me, you may spend a buff to buff me and ready me. (If I don't have a buff, I get a +1 Might buff.)	Kudos Productions	OGN-147/298	To channel nature's fury, a shaman must endure it.
148	Anivia, Primal	Champion Unit	Body	7	2	8	When I attack, deal 3 to all enemy units here.	Six More Vodka	OGN-148/298	"Do not tempt the blizzard."
149	Carnivorous Snapvine	Unit	Body	5	2	6	When you play me, choose an enemy unit at a battlefield. We deal damage equal to our Mights to each other.	Six More Vodka	OGN-149/298	Gardening is usually a very relaxing hobby.
150	Kraken Hunter	Unit	Body	3	2	6	[Accelerate] (You may pay as an additional cost to have me enter ready.) [Assault] (+1 while I'm an attacker.) As you play me, you may spend any number of buffs as an additional cost. Reduce my cost by for each buff you spend.	JiHun Lee	OGN-150/298	\N
151	Lee Sin, Centered	Champion Unit	Body	6	\N	6	[Accelerate] (You may pay as an additional cost to have me enter ready.) Other buffed friendly units at my battlefield have +2 Might.	League Splash Team	OGN-151/298	"Today will be a worthy test."
152	Mistfall	Gear	Body	3	\N	\N	When you buff a friendly unit, you may pay and exhaust this to ready it.	Polar Engine Studio	OGN-152/298	Thousands of thwarted dreams, ready to be lifted anew.
153	Overt Operation	Spell	Body	5	2	\N	[Action] (Play on your turn or in showdowns.) For each friendly unit, you may spend its buff to ready it. Then buff all friendly units. (Each one that doesn't have a buff gets a +1 buff.)	Kudos Productions	OGN-153/298	"We can go deep undercover, sneak in through the back and end this quietly. Or..."
154	Primal Strength	Spell	Body	4	1	\N	[Action] (Play on your turn or in showdowns.) Give a unit +7 Might this turn.	Kudos Productions	OGN-154/298	There is a savagery inside us all.
155	Qiyana, Victorious	Champion Unit	Body	4	1	4	[Deflect] (Opponents must pay to choose me with a spell or ability.) When I conquer, draw 1 or channel 1 rune exhausted.	League Splash Team	OGN-155/298	"Line them up. I will bend their knees."
156	Sabotage	Spell	Body	1	1	\N	Choose an opponent. They reveal their hand. Choose a non-unit card from it, and recycle that card.	Kudos Productions	OGN-156/298	Sometimes it takes dirty tricks to ensure a fair fight.
157	Udyr, Wildman	Champion Unit	Body	6	1	6	Spend my buff: Choose one you've not chosen this turn - Deal 2 to a unit at a battlefield. Stun a unit at a battlefield. Ready me. Give me [Ganking] this turn.	Six More Vodka	OGN-157/298	\N
158	Volibear, Imposing	Champion Unit	Body	12	2	10	[Shield 3] (+3 Might while I'm a defender.) [Tank] (I must be assigned combat damage first.) When an opponent moves to a battlefield other than mine, draw 1. (Bases are not battlefield.)	Envar Studio	OGN-158/298	"Gods do not beg. We take what is ours!"
159	Warwick, Hunter	Champion Unit	Body	6	1	5	I enter ready. When I attack, kill all damaged enemy units here.	League Splash Team	OGN-159/298	"The blood you spilled calls to me."
160	Dazzling Aurora	Gear	Body	9	2	\N	At the end of your turn, reveal cards from the top of your Main Deck until you reveal a unit. Play it, ignoring its cost, and recycle the rest.	Six More Vodka	OGN-160/298	The omens offer much to those who dare to see them.
161	Deadbloom Predator	Unit	Body	8	2	8	[Deflect] (Opponents must pay to choose me with a spell or ability.) You may play me to an occupied enemy battlefield.	Slawomir Maniak	OGN-161/298	The souls of those who died unfulfilled coalesce into a form to sate those hungers.
162	Miss Fortune, Captain	Champion Unit	Body	5	1	5	[Accelerate] (You may pay 1 Power and 1 Body as an additional cost to have me enter ready.) [Ganking] (I can move from battlefield to battlefield.) The first time I move each turn, you may ready something else that's exhausted.	League Splash Team	OGN-162/298	"Set sail!"
163	Seal of Strength	Gear	Body	0	1	\N	Exhaust: [Reaction] - [Add] 1 Body. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-163/298	\N
164	Sett, Brawler	Champion Unit	Body	5	1	4	When I'm played and when I conquer, buff me. (If I don't have a buff, I get a +1 buff.) Spend my buff: Give me +4 Might this turn.	Envar Studio	OGN-164/298	"Momma always said I had her temper."
165	Cemetery Attendant	Unit	Chaos	3	3	1	When you play me, return a unit from your trash to your hand.	Bubble Cat Studio	OGN-165/298	"Good boy! Now, where's the rest of 'em?"
166	Chaos Rune	Rune	Chaos	\N	\N	\N	\N	Greg Ghielmetti & Leah Chen	OGN-166/298	\N
167	Ember Monk	Unit	Chaos	4	\N	4	When you play a card from [Hidden], give me +2 Might this turn.	Kudos Productions	OGN-167/298	A flame bright enough to cast many shadows.
168	Fight or Flight	Spell	Chaos	2	\N	\N	[Hidden] (Hide now for to react with later for 0 Power.) [Action] (Play on your turn or in showdowns.) Move a unit from a battlefield to its base.	Kudos Productions	OGN-168/298	"Boo."
169	Gust	Spell	Chaos	1	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Return a unit at a battlefield with 3 Might or less to its owner's hand.	Kudos Productions	OGN-169/298	\N
170	Morbid Return	Spell	Chaos	2	\N	\N	[Action] (Play on your turn or in showdowns.) Return a unit from your trash to your hand.	Rafael Zanchetin	OGN-170/298	"Soon, this long cruel night will end. But not yet." -Viego
171	Mystic Poro	Unit	Chaos	2	\N	2	[Vision] (When you play me, look at the top card of your Main Deck. You may recycle it.)	Kudos Productions	OGN-171/298	Forecast: Sunny, with a chance of snax.
172	Rebuke	Spell	Chaos	2	2	\N	[Action] (Play on your turn or in showdowns.) Return a unit at a battlefield to its owner's hand.	Kudos Productions	OGN-172/298	"Get out."
173	Ride the Wind	Spell	Chaos	2	1	\N	[Action] (Play on your turn or in showdowns.) Move a friendly unit and ready it.	Kudos Productions	OGN-173/298	"Follow the wind, but watch your back." -Yasuo
174	Sai Scout	Unit	Chaos	6	\N	5	[Vision] (When you play me, look at the top card of your Main Deck. You may recycle it.) You may play me to an open battlefield.	Dao Trong Le	OGN-174/298	"Ours for the taking!"
175	Shipyard Skulker	Unit	Chaos	3	\N	3	\N	Six More Vodka	OGN-175/298	Few people laughed when she claimed she was a "dock pirate" - or at least, few remained.
176	Sneaky Deckhand	Unit	Chaos	3	\N	2	You may play me to an open battlefield.	Dao Trong Le	OGN-176/298	"I like to think of her as a pre-boarding party." -Miss Fortune
177	Stealthy Pursuer	Unit	Chaos	4	1	4	When a friendly unit moves from my location, I may be moved with it.	Kudos Productions	OGN-177/298	"Anywhere you can go, I can go better."
178	Undercover Agent	Unit	Chaos	5	1	5	[Deathknell] - Discard 2, then draw 2. (When I die, get the effect.)	Six More Vodka	OGN-178/298	Even he no longer knew which side he worked for.
179	Acceptable Losses	Spell	Chaos	1	\N	\N	[Action] (Play on your turn or in showdowns.) Each player kills one of their gear.	Kudos Productions	OGN-179/298	"Never liked that sword anyway."
180	Fading Memories	Spell	Chaos	4	1	\N	Give a unit at a battlefield or a gear [Temporary]. (Kill it at the start of its controller's Beginning Phase, before scoring.)	Kudos Productions	OGN-180/298	You too shall pass.
181	Pack of Wonders	Gear	Chaos	2	\N	\N	Exhaust: Return another friendly gear, unit, or [Hidden] card to its owner's hand.	Kudos Productions	OGN-181/298	"I know I put it in here somewhere..." -Teemo
182	Scrapheap	Gear	Chaos	2	\N	\N	When this is played, discarded, or killed, draw 1.	Kudos Productions	OGN-182/298	The parts that make it to the heap are the ones that DIDN'T blow up.
183	Stacked Deck	Spell	Chaos	1	\N	\N	[Action] (Play on your turn or in showdowns.) Look at the top 3 cards of your Main Deck. Put 1 into your hand and recycle the rest.	Kudos Productions	OGN-183/298	"Just lucky, I guess."
184	The Syren	Gear	Chaos	2	\N	\N	1 Mana, Exhaust: Move a friendly unit at a battlefield to its base.	Six More Vodka	OGN-184/298	Without a ship, a pirate's just another common criminal.
185	Traveling Merchant	Unit	Chaos	2	\N	2	When I move, discard 1, then draw 1.	Six More Vodka	OGN-185/298	Payment first, refund never.
186	Treasure Trove	Gear	Chaos	2	\N	\N	When this leaves the board, draw 1 and channel 1 rune exhausted. 1 Chaos, Exhaust: Kill this.	Kudos Productions	OGN-186/298	"We're gonna be rich!" -Common last words
187	Whirlwind	Spell	Chaos	4	1	\N	Starting with the next player, each player may return a unit to its owner's hand.	Polar Engine Studio	OGN-187/298	"The storm approaches." -Janna
188	Zaunite Bouncer	Unit	Chaos	4	2	2	When you play me, return another unit at a battlefield to its owner's hand.	Envar Studio	OGN-188/298	If he had things his way, NOBODY would get in.
189	Kayn, Unleashed	Champion Unit	Chaos	6	1	6	[Ganking] (I can move from battlefield to battlefield.) If I have moved twice this turn, I don't take damage.	Kudos Productions	OGN-189/298	"I will survive eternity. They will die today."
190	Kog'maw, Caustic	Champion Unit	Chaos	3	1	1	[Deathknell] - Deal 4 to all units at my battlefield. (When I die, get the effect.)	League Splash Team	OGN-190/298	"Oblivion come."
191	Maddened Marauder	Unit	Chaos	5	\N	4	[Tank] (I must be assigned combat damage first.) When you play me, move a unit from a battlefield to its base.	Alex Heath	OGN-191/298	They know no fear. Nor much of anything else, really.
192	Mindsplitter	Unit	Chaos	7	2	7	When you play me, choose an opponent. They reveal their hand. Choose a card from it, and they discard that card.	Six More Vodka	OGN-192/298	Its victims go mad deciding which half to run from first.
193	Miss Fortune, Buccaneer	Champion Unit	Chaos	4	1	4	You may play me to an open battlefield. Friendly units may be played to open battlefields.	Six More Vodka	OGN-193/298	"I always shoot first."
194	Nocturne, Horrifying	Champion Unit	Chaos	4	1	4	[Ganking] (I can move from battlefield to battlefield.) When you look at cards from the top of your deck (and don't draw them) and see me, you may play me for.	Six More Vodka	OGN-194/298	\N
195	Rhasa the Sunderer	Unit	Chaos	10	1	6	I cost 1 Power less for each card in your trash.	Six More Vodka	OGN-195/298	It feeds well on death, but better on madness.
196	Soulgorger	Unit	Chaos	8	2	5	When you play me, you may play a unit from your trash, ignoring its Energy cost. (You must still pay its Power cost.)	Six More Vodka	OGN-196/298	\N
197	Teemo, Scout	Champion Unit	Chaos	2	\N	1	[Hidden] (Hide now for to react with later for 0 Power.) When you play me, give me +3 Might this turn.	League Splash Team	OGN-197/298	"Reporting in!"
198	The Harrowing	Spell	Chaos	6	2	\N	Play a unit from your trash, ignoring its Energy cost. (You must still pay its Power cost.)	Rafael Zanchetin	OGN-198/298	\N
199	Tideturner	Unit	Chaos	2	\N	2	[Hidden] (Hide now for to react with later for 0 Power.) When you play me, you may choose a unit you control. Move me to its location and it to my original location.	Kudos Productions	OGN-199/298	\N
200	Twisted Fate, Gambler	Champion Unit	Chaos	4	\N	4	When I attack, reveal the top rune of your rune deck, then recycle it. Do one of the following based on its domain: 1 Fury - Deal 2 to an enemy unit here and 1 to all other enemy units here. 1 Mind - Draw 1. 1 Order - Stun an enemy unit.	Six More Vodka	OGN-200/298	\N
201	Invert Timelines	Spell	Chaos	2	1	\N	Each player discards their hand, then draws 4.	Kudos Productions	OGN-201/298	"Good a time as any to act reckless." -Ekko
202	Jinx, Rebel	Champion Unit	Chaos	5	1	5	When you discard one or more cards, ready me and give me +1 Might this turn.	Kudos Productions	OGN-202/298	"Rules are meant to be broken. Like buildings! Or people."
203	Possession	Spell	Chaos	8	3	\N	[Action] (Play on your turn or in showdowns.) Choose an enemy unit at a battlefield. Take control of it and recall it. (Send it to your base. This isn't a move.)	League of Legends	OGN-203/298	Some have a change of heart. Others need you to change it for them.
204	Seal of Discord	Gear	Chaos	0	1	\N	Exhaust: [Reaction] - [Add] 1 Chaos. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-204/298	\N
205	Yasuo, Windrider	Champion Unit	Chaos	5	1	4	[Ganking] (I can move from battlefield to battlefield.) The third time I move in a turn, you score 1 point.	Six More Vodka	OGN-205/298	"I will follow this path until the end."
206	Back to Back	Spell	Order	3	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Give two friendly units each +2 Might this turn.	Kudos Productions	OGN-206/298	Fight together or die alone.
207	Call to Glory	Spell	Order	3	\N	\N	[Reaction] (Play any time, even before spells and abilities resolve.) As you play this, you may spend a buff as an additional cost. If you do, ignore this spell's cost. Give a unit +3 Might this turn.	Kudos Productions	OGN-207/298	\N
208	Cruel Patron	Unit	Order	4	\N	6	As an additional cost to play me, kill a friendly unit.	Kudos Productions	OGN-208/298	Fealty is a duty, not a choice.
209	Cull the Weak	Spell	Order	2	1	\N	Each player kills one of their units.	Kudos Productions	OGN-209/298	What good is having a plank if nobody ever walks it?
210	Daring Poro	Unit	Order	2	\N	2	[Assault] (+1 Might while I'm an attacker.)	Six More Vodka	OGN-210/298	Don't worry, they love it.
211	Faithful Manufactor	Unit	Order	3	\N	2	When you play me, play a 1 Might Recruit unit token here.	Kudos Productions	OGN-211/298	Hard work is its own reward.
212	Forge of the Future	Gear	Order	2	\N	\N	When you play this, play a 1 Might Recruit unit token at your base. Kill this: Recycle up to 4 cards from trashes.	Envar Studio	OGN-212/298	"What else do we make? Beats me, but we do it better than anyone else."
213	Hidden Blade	Spell	Order	2	1	\N	[Hidden] (Hide now for to react with later for 0 Power.) [Action] (Play on your turn or in showdowns.) Kill a unit at a battlefield. Its controller draws 2.	Rafael Zanchetin	OGN-213/298	Not every Noxian decree is read aloud.
214	Order Rune	Rune	Order	\N	\N	\N	\N	Greg Ghielmetti & Leah Chen	OGN-214/298	\N
215	Petty Officer	Unit	Order	5	\N	5	[Assault] (+1 Might while I'm an attacker.)	Six More Vodka	OGN-215/298	Cross him and you'll learn just how petty he can be.
216	Soaring Scout	Unit	Order	2	\N	1	[Deathknell] - Channel 1 rune exhausted. (When I die, get the effect.)	Six More Vodka	OGN-216/298	"Show us a path!" -Ashe
217	Trifarian Gloryseeker	Unit	Order	2	\N	2	[Legion] - When you play me, buff me. (If I don't have a buff, I get a +1 buff. Get the effect if you've played another card this turn.)	Six More Vodka	OGN-217/298	War demands your life but offers immortality.
218	Vanguard Captain	Unit	Order	3	1	3	[Legion] - When you play me, play two 1 Might Recruit unit tokens here. (Get the effect if you've played another card this turn.)	Six More Vodka	OGN-218/298	"Soldiers, to me!"
219	Vanguard Sergeant	Unit	Order	4	\N	4	\N	Six More Vodka	OGN-219/298	He knew his orders: hold the line, or there would be nothing left to hold.
220	Facebreaker	Spell	Order	2	\N	\N	[Hidden] (Hide now for to react with later for 0 Power.) [Action] (Play on your turn or in showdowns.) Stun a friendly unit and an enemy unit at the same battlefield. (They don't deal combat damage this turn.)	Kudos Productions	OGN-220/298	"Play nice!" -Sett
221	Imperial Decree	Spell	Order	5	2	\N	[Action] (Play on your turn or in showdowns.) When any unit takes damage this turn, kill it.	Kudos Productions	OGN-221/298	"With a word, I end you." -Azir
222	Noxian Drummer	Unit	Order	3	\N	3	When I move to a battlefield, play a 1 Might Recruit unit token here. (It is also at the battlefield.)	Six More Vodka	OGN-222/298	Even the Legion's musicians are hard to beat.
223	Peak Guardian	Unit	Order	6	1	5	When you play me, buff me. Then, if I am at a battlefield, buff all other friendly units there. (To buff a unit, give it a +1 Might buff if it doesn't already have one.)	Six More Vodka	OGN-223/298	Mount Targon's blessing is bestowed upon those who have proven they are strong enough without it.
224	Salvage	Spell	Order	2	1	\N	[Action] (Play on your turn or in showdowns.) You may kill a gear. Draw 1.	Kudos Productions	OGN-224/298	One person's treasure is another one's trash.
225	Solari Chief	Unit	Order	5	1	4	When you play me, choose an enemy unit. If it is stunned, kill it. Otherwise, stun it. (It doesn't deal combat damage this turn.)	JiHun Lee	OGN-225/298	The sun has many rays, each tasked with driving out the darkness.
226	Spectral Matron	Unit	Order	4	2	4	When you play me, you may play a unit costing no more than 3 Power and no more than 1 from your trash, ignoring its cost.	Six More Vodka	OGN-226/298	"Come- there is use for you yet."
227	Symbol of the Solari	Gear	Order	1	\N	\N	If a combat where you are the attacker ends in a tie, recall ALL units instead. (Send them to base. This isn't a move. Ties are calculated after combat damage is dealt.)	Kudos Productions	OGN-227/298	"Next time, try to leave a dent!" -Leona
228	Vanguard Helm	Gear	Order	2	\N	\N	When a buffed friendly unit dies, buff another friendly unit. (If it doesn't have a buff, it gets a +1 Might buff.)	Kudos Productions	OGN-228/298	Vanguard soldiers share both a helm and a vision.
229	Vengeance	Spell	Order	4	2	\N	Kill a unit.	Max Grecke	OGN-229/298	A brief moment of turmoil- then peace.
230	Albus Ferros	Unit	Order	4	\N	3	When you play me, spend any number of buffs. For each buff spent, channel 1 rune exhausted.	Kudos Productions	OGN-230/298	In Piltover, the best way to become a great inventor is to find a great investor.
231	Commander Ledros	Unit	Order	6	4	8	As you play me, you may kill any number of friendly units as an additional cost. Reduce my cost by 1 Order for each killed this way [Deflect] (Opponents must pay to choose me with a spell or ability.) [Ganking] (I can move from battlefield to battlefield.)	Six More Vodka	OGN-231/298	\N
232	Fiora, Victorious	Champion Unit	Order	4	\N	4	While I'm [Mighty], I have [Deflect], [Ganking], and [Shield]. (I'm Mighty while I have 5+ Might.)	Six More Vodka	OGN-232/298	"I long for a worthy opponent."
233	Grand Strategem	Spell	Order	6	3	\N	[Action] (Play on your turn or in showdowns.) Give friendly units +5 Might this turn.	Kudos Productions	OGN-233/298	You need not understand the plan- only believe in it.
234	Harnessed Dragon	Unit	Order	8	2	6	When you play me, kill an enemy unit.	Envar Studio	OGN-234/298	What bends a dragon's will is not strength, but sense of purpose.
235	Karma, Channeler	Champion Unit	Order	6	1	6	[Vision] (When you play me, look at the top card of your Main Deck. You may recycle it.) When you recycle one or more cards, buff a friendly unit. (If it doesn't have a buff, it gets a +1 buff. Runes aren't cards.)	Six More Vodka	OGN-235/298	"Heart and mind as one."
236	Karthus, Eternal	Champion Unit	Order	3	1	3	Your [Deathknell] effects trigger an additional time.	League Splash Team	OGN-236/298	"We all have a place among the divine. We only have to accept it."
237	King's Edict	Spell	Order	6	2	\N	Starting with the next player, each other player chooses a unit you don't control that hasn't been chosen for this spell. Kill those units.	Kudos Productions	OGN-237/298	Ruling is about making hard choices. Serving is about living with the consequences.
238	Leona, Determined	Champion Unit	Order	4	1	4	[Shield] (+1 Might while I'm a defender.) When I attack, stun an enemy unit here. (It doesn't deal combat damage this turn.)	Six More Vodka	OGN-238/298	"First light approaches."
239	Machine Evangel	Unit	Order	5	1	4	[Deathknell] - Play three 1 Might Recruit unit tokens into your base. (When I die, get the effect.)	Kudos Productions	OGN-239/298	The future is built by those who never see it.
240	Sett, Kingpin	Champion Unit	Order	4	1	5	[Tank] (I must be assigned combat damage first.) I get +1 Might for each buffed friendly unit at my battlefield.	League Splash Team	OGN-240/298	"Bein' the boss is a lot better than not bein' the boss."
241	Shen, Kinkou	Champion Unit	Order	3	1	3	[Reaction] (Play any time, even before spells and abilities resolve, including to a battlefield you control.) [Shield 2] (+2 Might while I'm a defender.) [Tank] (I must be assigned combat damage first.)	Six More Vodka	OGN-241/298	"Tread carefully."
242	Baited Hook	Gear	Order	3	\N	\N	1 Power and 1 Order, Exhaust: Kill a friendly unit. Look at the top 5 cards of your Main Deck. You may play a unit from among them that has Might up to 1 more than the killed unit, ignoring its cost. Then recycle the rest.	Kudos Productions	OGN-242/298	There's always a bigger fish- sometimes a MUCH bigger fish.
243	Darius, Executioner	Champion Unit	Order	6	1	6	[Legion] - When you play me, ready me. (Get the effect if you've played another card this turn) Other friendly units have +1 Might here.	Six More Vodka	OGN-243/298	"They will regret opposing me."
244	Divine Judgement	Spell	Order	7	2	\N	Each player chooses 2 units, 2 gear, 2 runes, and 2 cards in their hands. Recycle the rest.	Kudos Productions	OGN-244/298	Equality isn't always equal.
245	Seal of Unity	Gear	Order	0	1	\N	Exhaust: [Reaction] - [Add] 1 Order. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-245/298	\N
246	Viktor, Leader	Champion Unit	Order	4	1	4	When another non-Recruit unit you control dies, play a 1 Might Recruit unit token into your base.	League Splash Team	OGN-246/298	"I am the first of many."
247	Daughter of the Void	Legend	Fury, Mind	\N	\N	\N	: [Reaction] - [Add]. Use only to play spells. (Abilities that add resources can't be reacted to.)	Kudos Productions	OGN-247/298	\N
248	Icathian Rain	Signature Spell	Fury, Mind	7	3	\N	Do this 6 times: Deal 2 to a unit. (You can choose different units.)	Kudos Productions	OGN-248/298	\N
249	Relentless Storm	Legend	Fury, Body	\N	\N	\N	When you play a [Mighty] unit, you may exhaust me to channel 1 rune exhausted. (A unit is Mighty while it has 5+.)	Grafit Studio	OGN-249/298	\N
250	Stormbringer	Signature Spell	Fury, Body	6	2	\N	Choose a friendly unit in your base. Deal damage equal to its Might to all enemy units at a battlefield, then move your unit there.	Kudos Productions	OGN-250/298	\N
251	Loose Cannon	Legend	Fury, Chaos	\N	\N	\N	At start of your Beginning Phase, draw 1 if you have one or fewer cards in your hand.	Sugar Free	OGN-251/298	\N
252	Super Mega Death Rocket!	Signature Spell	Fury, Chaos	4	1	\N	Deal 5 to a unit. When you conquer, you may discard 1 to return this from your trash to your hand	Kudos Productions	OGN-252/298	\N
253	Hand of Noxus	Legend	Fury, Order	\N	\N	\N	: [Reaction], [Legion] - [Add]. (Abilities that add resources can't be reacted to. Get the effect if you've played a card this turn.)	Six More Vodka	OGN-253/298	\N
254	Noxian Guillotine	Signature Spell	Fury, Order	4	1	\N	[Action] (Play on your turn or in showdowns.) Choose a unit. Kill it the next time it takes damage this turn. Move an enemy unit. Then choose another enemy unit at its destination. They deal damage equal to their Mights to each other.	Kudos Productions	OGN-254/298	\N
255	Nine-Tailed Fox	Legend	Calm, Mind	\N	\N	\N	When an enemy unit attacks a battlefield you control, give it -1 this turn, to a minimum of 1.	Envar Studio	OGN-255/298	\N
256	Fox-Fire	Signature Spell	Calm, Mind	3	\N	\N	[Hidden] (Hide now for to react with later for.) [Action] (Play on your turn or in showdowns.) Kill any number of units at a battlefield with total Might 4 or less.	League Splash Team	OGN-256/298	\N
257	Blind Monk	Legend	Calm, Body	\N	\N	\N	,: Buff a friendly unit. (If it doesn't have a buff, it gets a +1 buff.)	Six More Vodka	OGN-257/298	\N
258	Dragon's Rage	Signature Spell	Calm, Body	4	1	\N	Move an enemy unit. Then choose another enemy unit at its destination. They deal damage equal to their Mights to each other.	Kudos Productions	OGN-258/298	\N
259	Unforgiven	Legend	Calm, Chaos	\N	\N	\N	: Move a friendly unit to or from its base.	TSWCK	OGN-259/298	\N
260	Last Breath	Signature Spell	Calm, Chaos	3	2	\N	[Action] (Play on your turn or in showdowns.) Ready a friendly unit. It deals damage equal to its Might to an enemy unit at a battlefield.	Kudos Productions	OGN-260/298	\N
261	Radiant Dawn	Legend	Calm, Order	\N	\N	\N	When you stun one or more enemy units, buff a friendly unit. (If it doesn't have a buff, it gets a +1 buff.)	Six More Vodka	OGN-261/298	\N
262	Zenith Blade	Signature Spell	Calm, Order	3	2	\N	[Action] (Play on your turn or in showdowns.) Stun an enemy unit at a battlefield. You may move a friendly unit to that enemy unit's battlefield. (A stunned unit doesn't deal combat damage this turn.)	Kudos Productions	OGN-262/298	\N
263	Swift Scout	Legend	Mind, Chaos	\N	\N	\N	You may pay to hide a card with [Hidden] instead of.,: Put a Teemo unit you own into your hand from your Champion Zone or the board.	Shawn Lee	OGN-263/298	\N
264	Guerilla Warfare	Signature Spell	Mind, Chaos	2	1	\N	Return up to two cards with [Hidden] from your trash to your hand. You can hide cards ignoring costs this turn.	Kudos Productions	OGN-264/298	\N
265	Herald of the Arcane	Legend	Mind, Order	\N	\N	\N	,: Play a 1 Recruit unit token.	Fortiche Production	OGN-265/298	\N
266	Siphon Power	Signature Spell	Mind, Order	2	1	\N	[Reaction] (Play any time, even before spells and abilities resolve.) Choose a battlefield. Give friendly units there +1 this turn and enemy units there -1 this turn, to a minimum of 1.	Kudos Productions	OGN-266/298	\N
267	Bounty Hunter	Legend	Body, Chaos	\N	\N	\N	: Give a unit [Ganking] this turn. (It can move from battlefield to battlefield.)	Six More Vodka	OGN-267/298	\N
268	Bullet Time	Signature Spell	Body, Chaos	1	\N	\N	[Action] (Play on your turn or in showdowns.) Pay any amount of to deal that much damage to all enemy units at a battlefield.	Kudos Productions	OGN-268/298	\N
269	The Boss	Legend	Body, Order	\N	\N	\N	When a buffed unit you control would die, you may pay and exhaust me to spend its buff and recall it exhausted instead. (Send it to base. This isn't a move.) When you conquer, ready me.	Envar Studio	OGN-269/298	\N
270	Showstopper	Signature Spell	Body, Order	1	1	\N	Buff a friendly unit in your base, then move it to a battlefield. (If it doesn't have a buff, it gets a +1 buff.)	Kudos Productions	OGN-270/298	\N
271	Recruit	Token Unit	\N	\N	\N	1	\N	Six More Vodka	OGN-271/298	"To strike against any of us is to strike against all of us!"
272	Recruit	Token Unit	\N	\N	\N	1	\N	Six More Vodka	OGN-272/298	"Few earn the right to call themselves Trifarian."
273	Recruit	Token Unit	\N	\N	\N	1	\N	Fortiche Production	OGN-273/298	"We are the future."
274	Sprite	Token Unit	\N	\N	\N	3	[Temporary] (Kill me at the start of your Beginning Phase, before scoring.)	Envar Studio	OGN-274/298	Dreams rarely linger, but the dreamer is still changed.
275	Altar to Unity	Battlefield	\N	\N	\N	\N	When you hold here, play a 1 Recruit unit token in your base.	Kudos Productions	OGN-275/298	\N
276	Aspirant's Climb	Battlefield	\N	\N	\N	\N	Increase the points needed to win the game by 1.	Polar Engine Studio	OGN-276/298	\N
277	Back-Alley Bar	Battlefield	\N	\N	\N	\N	When a unit moves from here, give it +1 this turn.	Kudos Productions	OGN-277/298	\N
278	Bandle Tree	Battlefield	\N	\N	\N	\N	You may hide an additional card here.	Kudos Productions	OGN-278/298	\N
279	Fortified Position	Battlefield	\N	\N	\N	\N	When you defend here, choose a unit. It gains [Shield 2] this combat. (+2 while it's a defender.)	Six More Vodka	OGN-279/298	\N
280	Grove of the God-Willow	Battlefield	\N	\N	\N	\N	When you hold here, draw 1.	Kudos Productions	OGN-280/298	\N
281	Hallowed Tomb	Battlefield	\N	\N	\N	\N	When you hold here, you may return your Chosen Champion from your trash to your Champion Zone if it is empty.	Kudos Productions	OGN-281/298	\N
282	Monastery of Hirana	Battlefield	\N	\N	\N	\N	When you hold here, you may return your Chosen Champion from your trash to your Champion Zone if it is empty.	Six More Vodka	OGN-282/298	\N
283	Navori Fighting Pit	Battlefield	\N	\N	\N	\N	When you hold here, buff a unit here. (If it doesn't have a buff, it gets a +1 buff.)	Envar Studio	OGN-283/298	\N
284	Obelisk of Power	Battlefield	\N	\N	\N	\N	At the start of each player's first Beginning Phase, that player channels 1 rune.	Chris Kintner	OGN-284/298	\N
285	Reaver's Row	Battlefield	\N	\N	\N	\N	When you defend here, you may move a friendly unit here to base.	Kudos Productions	OGN-285/298	\N
286	Reckoner's Arena	Battlefield	\N	\N	\N	\N	When you hold here, activate the conquer effects of units here.	Six More Vodka	OGN-286/298	\N
287	Sigil of the Storm	Battlefield	\N	\N	\N	\N	When you conquer here, recycle one of your runes.	Envar Studio	OGN-287/298	\N
288	Startipped Peak	Battlefield	\N	\N	\N	\N	When you hold here, you may channel 1 rune exhausted.	Polar Engine Studio	OGN-288/298	\N
289	Targon's Peak	Battlefield	\N	\N	\N	\N	When you conquer here, ready 2 runes at the end of this turn.	Six More Vodka	OGN-289/298	\N
290	The Arena's Greatest	Battlefield	\N	\N	\N	\N	At the start of each player's first Beginning Phase, that player gains 1 point.	Envar Studio	OGN-290/298	\N
291	The Candlelit Sanctum	Battlefield	\N	\N	\N	\N	When you conquer here, look at the top two cards of your Main Deck. You may recycle one or both of them. Put those you don't back in any order.	Envar Studio	OGN-291/298	\N
292	The Dreaming Tree	Battlefield	\N	\N	\N	\N	The first time you choose a friendly unit with a spell here each turn, draw 1.	Envar Studio	OGN-292/298	\N
293	The Grand Plaza	Battlefield	\N	\N	\N	\N	When you hold here, if you have 7+ units here, you win the game.	Six More Vodka	OGN-293/298	\N
294	Trifarian War Camp	Battlefield	\N	\N	\N	\N	Units here have +1. (This includes attackers.)	Kudos Productions	OGN-294/298	\N
295	Vilemaw's Lair	Battlefield	\N	\N	\N	\N	Units can't move from here to base.	Kudos Productions	OGN-295/298	\N
296	Void Gate	Battlefield	\N	\N	\N	\N	Spells and abilities affecting units here each deal 1 Bonus Damage. (Each instance of damage the spell deals is increased by 1.)	Envar Studio	OGN-296/298	\N
297	Windswept Hillock	Battlefield	\N	\N	\N	\N	Units here have [Ganking]. (They can move from battlefield to battlefield.)	Kudos Productions	OGN-297/298	\N
298	Zaun Warrens	Battlefield	\N	\N	\N	\N	When you conquer here, discard 1, then draw 1.	Envar Studio	OGN-298/298	\N
299	Daughter of the Void	Legend	Fury, Mind	\N	\N	\N	: [Reaction] - [Add]. Use only to play spells. (Abilities that add resources can't be reacted to.)	Jason Chan	OGN-299*/298	\N
300	Relentless Storm	Legend	Fury, Body	\N	\N	\N	When you play a [Mighty] unit, you may exhaust me to channel 1 rune exhausted. (A unit is Mighty while it has 5+.)	Alex Flores	OGN-300*/298	\N
301	Loose Cannon	Legend	Fury, Chaos	\N	\N	\N	At start of your Beginning Phase, draw 1 if you have one or fewer cards in your hand.	Sean Yang	OGN-301*/298	\N
302	Hand of Noxus	Legend	Fury, Order	\N	\N	\N	: [Reaction], [Legion] - [Add]. (Abilities that add resources can't be reacted to. Get the effect if you've played a card this turn.)	Peter Kim	OGN-302*/298	\N
303	Nine-Tailed Fox	Legend	Calm, Mind	\N	\N	\N	When an enemy unit attacks a battlefield you control, give it -1 this turn, to a minimum of 1.	Airi Pan	OGN-303*/298	\N
304	Blind Monk	Legend	Calm, Body	\N	\N	\N	,: Buff a friendly unit. (If it doesn't have a buff, it gets a +1 buff.)	Loiza Chen	OGN-304*/298	\N
305	Unforgiven	Legend	Calm, Chaos	\N	\N	\N	,: Move a friendly unit to or from its base.	Quy Ho	OGN-305*/298	\N
306	Radiant Dawn	Legend	Calm, Order	\N	\N	\N	When you stun one or more enemy units, buff a friendly unit. (If it doesn't have a buff, it gets a +1 buff.)	Su Ke	OGN-306*/298	\N
307	Swift Scout	Legend	Mind, Chaos	\N	\N	\N	You may pay to hide a card with [Hidden] instead of.,: Put a Teemo unit you own into your hand from your Champion Zone or the board.	Jordan Yoon	OGN-307*/298	\N
308	Herald of the Arcane	Legend	Mind, Order	\N	\N	\N	,: Play a 1 Recruit unit token.	Rudy Siswanto	OGN-308*/298	\N
309	Bounty Hunter	Legend	Body, Chaos	\N	\N	\N	: Give a unit [Ganking] this turn. (It can move from battlefield to battlefield.)	Mindy Kang	OGN-309*/298	\N
310	The Boss	Legend	Body, Order	\N	\N	\N	When a buffed unit you control would die, you may pay and exhaust me to spend its buff and recall it exhausted instead. (Send it to base. This isn't a move.) When you conquer, ready me.	Gem Lim	OGN-310*/298	\N
\.


--
-- Data for Name: card_printing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.card_printing (printing_id, card_id, set_id, rarity, foil, alt_art, overnumbered, signed, release_date, image_url) FROM stdin;
1	1	1	Common	f	f	f	f	2025-10-31	\N
2	2	1	Common	f	f	f	f	2025-10-31	\N
3	3	1	Common	f	f	f	f	2025-10-31	\N
4	4	1	Common	f	f	f	f	2025-10-31	\N
5	5	1	Common	f	f	f	f	2025-10-31	\N
6	6	1	Common	f	f	f	f	2025-10-31	\N
7	7	1	Common	f	f	f	f	2025-10-31	\N
7a	7	1	Overnumbered	f	t	t	f	2025-10-31	\N
8	8	1	Common	f	f	f	f	2025-10-31	\N
9	9	1	Common	f	f	f	f	2025-10-31	\N
10	10	1	Common	f	f	f	f	2025-10-31	\N
11	11	1	Common	f	f	f	f	2025-10-31	\N
12	12	1	Common	f	f	f	f	2025-10-31	\N
13	13	1	Common	f	f	f	f	2025-10-31	\N
14	14	1	Common	f	f	f	f	2025-10-31	\N
15	15	1	Uncommon	f	f	f	f	2025-10-31	\N
16	16	1	Uncommon	f	f	f	f	2025-10-31	\N
17	17	1	Uncommon	f	f	f	f	2025-10-31	\N
18	18	1	Uncommon	f	f	f	f	2025-10-31	\N
19	19	1	Uncommon	f	f	f	f	2025-10-31	\N
20	20	1	Uncommon	f	f	f	f	2025-10-31	\N
21	21	1	Uncommon	f	f	f	f	2025-10-31	\N
22	22	1	Uncommon	f	f	f	f	2025-10-31	\N
23	23	1	Uncommon	f	f	f	f	2025-10-31	\N
24	24	1	Uncommon	f	f	f	f	2025-10-31	\N
25	25	1	Rare	f	f	f	f	2025-10-31	\N
26	26	1	Rare	f	f	f	f	2025-10-31	\N
27	27	1	Rare	f	f	f	f	2025-10-31	\N
27a	27	1	Overnumbered	f	t	t	f	2025-10-31	\N
28	28	1	Rare	f	f	f	f	2025-10-31	\N
29	29	1	Rare	f	f	f	f	2025-10-31	\N
30	30	1	Rare	f	f	f	f	2025-10-31	\N
30a	30	1	Overnumbered	f	t	t	f	2025-10-31	\N
31	31	1	Rare	f	f	f	f	2025-10-31	\N
32	32	1	Rare	f	f	f	f	2025-10-31	\N
33	33	1	Rare	f	f	f	f	2025-10-31	\N
34	34	1	Rare	f	f	f	f	2025-10-31	\N
35	35	1	Rare	f	f	f	f	2025-10-31	\N
36	36	1	Rare	f	f	f	f	2025-10-31	\N
37	37	1	Epic	f	f	f	f	2025-10-31	\N
38	38	1	Epic	f	f	f	f	2025-10-31	\N
39	39	1	Epic	f	f	f	f	2025-10-31	\N
39a	39	1	Overnumbered	f	t	t	f	2025-10-31	\N
40	40	1	Epic	f	f	f	f	2025-10-31	\N
41	41	1	Epic	f	f	f	f	2025-10-31	\N
41a	41	1	Overnumbered	f	t	t	f	2025-10-31	\N
42	42	1	Common	f	f	f	f	2025-10-31	\N
42a	42	1	Overnumbered	f	t	t	f	2025-10-31	\N
43	43	1	Common	f	f	f	f	2025-10-31	\N
44	44	1	Common	f	f	f	f	2025-10-31	\N
45	45	1	Common	f	f	f	f	2025-10-31	\N
46	46	1	Common	f	f	f	f	2025-10-31	\N
47	47	1	Common	f	f	f	f	2025-10-31	\N
48	48	1	Common	f	f	f	f	2025-10-31	\N
49	49	1	Common	f	f	f	f	2025-10-31	\N
50	50	1	Common	f	f	f	f	2025-10-31	\N
51	51	1	Common	f	f	f	f	2025-10-31	\N
52	52	1	Common	f	f	f	f	2025-10-31	\N
53	53	1	Common	f	f	f	f	2025-10-31	\N
54	54	1	Common	f	f	f	f	2025-10-31	\N
55	55	1	Common	f	f	f	f	2025-10-31	\N
56	56	1	Uncommon	f	f	f	f	2025-10-31	\N
57	57	1	Uncommon	f	f	f	f	2025-10-31	\N
58	58	1	Uncommon	f	f	f	f	2025-10-31	\N
59	59	1	Uncommon	f	f	f	f	2025-10-31	\N
60	60	1	Uncommon	f	f	f	f	2025-10-31	\N
61	61	1	Uncommon	f	f	f	f	2025-10-31	\N
62	62	1	Uncommon	f	f	f	f	2025-10-31	\N
63	63	1	Uncommon	f	f	f	f	2025-10-31	\N
64	64	1	Uncommon	f	f	f	f	2025-10-31	\N
65	65	1	Uncommon	f	f	f	f	2025-10-31	\N
66	66	1	Rare	f	f	f	f	2025-10-31	\N
66a	66	1	Overnumbered	f	t	t	f	2025-10-31	\N
67	67	1	Rare	f	f	f	f	2025-10-31	\N
68	68	1	Rare	f	f	f	f	2025-10-31	\N
69	69	1	Rare	f	f	f	f	2025-10-31	\N
70	70	1	Rare	f	f	f	f	2025-10-31	\N
71	71	1	Rare	f	f	f	f	2025-10-31	\N
72	72	1	Rare	f	f	f	f	2025-10-31	\N
73	73	1	Rare	f	f	f	f	2025-10-31	\N
74	74	1	Rare	f	f	f	f	2025-10-31	\N
75	75	1	Rare	f	f	f	f	2025-10-31	\N
76	76	1	Rare	f	f	f	f	2025-10-31	\N
76a	76	1	Overnumbered	f	t	t	f	2025-10-31	\N
77	77	1	Rare	f	f	f	f	2025-10-31	\N
78	78	1	Epic	f	f	f	f	2025-10-31	\N
78a	78	1	Overnumbered	f	t	t	f	2025-10-31	\N
79	79	1	Epic	f	f	f	f	2025-10-31	\N
79a	79	1	Overnumbered	f	t	t	f	2025-10-31	\N
80	80	1	Epic	f	f	f	f	2025-10-31	\N
81	81	1	Epic	f	f	f	f	2025-10-31	\N
82	82	1	Epic	f	f	f	f	2025-10-31	\N
83	83	1	Common	f	f	f	f	2025-10-31	\N
84	84	1	Common	f	f	f	f	2025-10-31	\N
85	85	1	Common	f	f	f	f	2025-10-31	\N
86	86	1	Common	f	f	f	f	2025-10-31	\N
87	87	1	Common	f	f	f	f	2025-10-31	\N
88	88	1	Common	f	f	f	f	2025-10-31	\N
89	89	1	Common	f	f	f	f	2025-10-31	\N
89a	89	1	Overnumbered	f	t	t	f	2025-10-31	\N
90	90	1	Common	f	f	f	f	2025-10-31	\N
91	91	1	Common	f	f	f	f	2025-10-31	\N
92	92	1	Common	f	f	f	f	2025-10-31	\N
93	93	1	Common	f	f	f	f	2025-10-31	\N
94	94	1	Common	f	f	f	f	2025-10-31	\N
95	95	1	Common	f	f	f	f	2025-10-31	\N
96	96	1	Common	f	f	f	f	2025-10-31	\N
97	97	1	Uncommon	f	f	f	f	2025-10-31	\N
98	98	1	Uncommon	f	f	f	f	2025-10-31	\N
99	99	1	Uncommon	f	f	f	f	2025-10-31	\N
100	100	1	Uncommon	f	f	f	f	2025-10-31	\N
101	101	1	Uncommon	f	f	f	f	2025-10-31	\N
102	102	1	Uncommon	f	f	f	f	2025-10-31	\N
103	103	1	Uncommon	f	f	f	f	2025-10-31	\N
104	104	1	Uncommon	f	f	f	f	2025-10-31	\N
105	105	1	Uncommon	f	f	f	f	2025-10-31	\N
106	106	1	Uncommon	f	f	f	f	2025-10-31	\N
107	107	1	Rare	f	f	f	f	2025-10-31	\N
108	108	1	Rare	f	f	f	f	2025-10-31	\N
109	109	1	Rare	f	f	f	f	2025-10-31	\N
110	110	1	Rare	f	f	f	f	2025-10-31	\N
111	111	1	Rare	f	f	f	f	2025-10-31	\N
112	112	1	Rare	f	f	f	f	2025-10-31	\N
112a	112	1	Overnumbered	f	t	t	f	2025-10-31	\N
113	113	1	Rare	f	f	f	f	2025-10-31	\N
114	114	1	Rare	f	f	f	f	2025-10-31	\N
115	115	1	Rare	f	f	f	f	2025-10-31	\N
116	116	1	Rare	f	f	f	f	2025-10-31	\N
117	117	1	Rare	f	f	f	f	2025-10-31	\N
117a	117	1	Overnumbered	f	t	t	f	2025-10-31	\N
118	118	1	Rare	f	f	f	f	2025-10-31	\N
119	119	1	Epic	f	f	f	f	2025-10-31	\N
119a	119	1	Overnumbered	f	t	t	f	2025-10-31	\N
120	120	1	Epic	f	f	f	f	2025-10-31	\N
121	121	1	Epic	f	f	f	f	2025-10-31	\N
121a	121	1	Overnumbered	f	t	t	f	2025-10-31	\N
122	122	1	Epic	f	f	f	f	2025-10-31	\N
123	123	1	Epic	f	f	f	f	2025-10-31	\N
124	124	1	Common	f	f	f	f	2025-10-31	\N
125	125	1	Common	f	f	f	f	2025-10-31	\N
126	126	1	Common	f	f	f	f	2025-10-31	\N
126a	126	1	Overnumbered	f	t	t	f	2025-10-31	\N
127	127	1	Common	f	f	f	f	2025-10-31	\N
128	128	1	Common	f	f	f	f	2025-10-31	\N
129	129	1	Common	f	f	f	f	2025-10-31	\N
130	130	1	Common	f	f	f	f	2025-10-31	\N
131	131	1	Common	f	f	f	f	2025-10-31	\N
132	132	1	Common	f	f	f	f	2025-10-31	\N
133	133	1	Common	f	f	f	f	2025-10-31	\N
134	134	1	Common	f	f	f	f	2025-10-31	\N
135	135	1	Common	f	f	f	f	2025-10-31	\N
136	136	1	Common	f	f	f	f	2025-10-31	\N
137	137	1	Common	f	f	f	f	2025-10-31	\N
138	138	1	Uncommon	f	f	f	f	2025-10-31	\N
139	139	1	Uncommon	f	f	f	f	2025-10-31	\N
140	140	1	Uncommon	f	f	f	f	2025-10-31	\N
141	141	1	Uncommon	f	f	f	f	2025-10-31	\N
142	142	1	Uncommon	f	f	f	f	2025-10-31	\N
143	143	1	Uncommon	f	f	f	f	2025-10-31	\N
144	144	1	Uncommon	f	f	f	f	2025-10-31	\N
145	145	1	Uncommon	f	f	f	f	2025-10-31	\N
146	146	1	Uncommon	f	f	f	f	2025-10-31	\N
147	147	1	Uncommon	f	f	f	f	2025-10-31	\N
148	148	1	Rare	f	f	f	f	2025-10-31	\N
149	149	1	Rare	f	f	f	f	2025-10-31	\N
150	150	1	Rare	f	f	f	f	2025-10-31	\N
151	151	1	Rare	f	f	f	f	2025-10-31	\N
151a	151	1	Overnumbered	f	t	t	f	2025-10-31	\N
152	152	1	Rare	f	f	f	f	2025-10-31	\N
153	153	1	Rare	f	f	f	f	2025-10-31	\N
154	154	1	Rare	f	f	f	f	2025-10-31	\N
155	155	1	Rare	f	f	f	f	2025-10-31	\N
156	156	1	Rare	f	f	f	f	2025-10-31	\N
157	157	1	Rare	f	f	f	f	2025-10-31	\N
158	158	1	Rare	f	f	f	f	2025-10-31	\N
158a	158	1	Overnumbered	f	t	t	f	2025-10-31	\N
159	159	1	Rare	f	f	f	f	2025-10-31	\N
160	160	1	Epic	f	f	f	f	2025-10-31	\N
161	161	1	Epic	f	f	f	f	2025-10-31	\N
162	162	1	Epic	f	f	f	f	2025-10-31	\N
162a	162	1	Overnumbered	f	t	t	f	2025-10-31	\N
163	163	1	Epic	f	f	f	f	2025-10-31	\N
164	164	1	Epic	f	f	f	f	2025-10-31	\N
164a	164	1	Overnumbered	f	t	t	f	2025-10-31	\N
165	165	1	Common	f	f	f	f	2025-10-31	\N
166	166	1	Common	f	f	f	f	2025-10-31	\N
166a	166	1	Overnumbered	f	t	t	f	2025-10-31	\N
167	167	1	Common	f	f	f	f	2025-10-31	\N
168	168	1	Common	f	f	f	f	2025-10-31	\N
169	169	1	Common	f	f	f	f	2025-10-31	\N
170	170	1	Common	f	f	f	f	2025-10-31	\N
171	171	1	Common	f	f	f	f	2025-10-31	\N
172	172	1	Common	f	f	f	f	2025-10-31	\N
173	173	1	Common	f	f	f	f	2025-10-31	\N
174	174	1	Common	f	f	f	f	2025-10-31	\N
175	175	1	Common	f	f	f	f	2025-10-31	\N
176	176	1	Common	f	f	f	f	2025-10-31	\N
177	177	1	Common	f	f	f	f	2025-10-31	\N
178	178	1	Common	f	f	f	f	2025-10-31	\N
179	179	1	Uncommon	f	f	f	f	2025-10-31	\N
180	180	1	Uncommon	f	f	f	f	2025-10-31	\N
181	181	1	Uncommon	f	f	f	f	2025-10-31	\N
182	182	1	Uncommon	f	f	f	f	2025-10-31	\N
183	183	1	Uncommon	f	f	f	f	2025-10-31	\N
184	184	1	Uncommon	f	f	f	f	2025-10-31	\N
185	185	1	Uncommon	f	f	f	f	2025-10-31	\N
186	186	1	Uncommon	f	f	f	f	2025-10-31	\N
187	187	1	Uncommon	f	f	f	f	2025-10-31	\N
188	188	1	Uncommon	f	f	f	f	2025-10-31	\N
189	189	1	Rare	f	f	f	f	2025-10-31	\N
190	190	1	Rare	f	f	f	f	2025-10-31	\N
191	191	1	Rare	f	f	f	f	2025-10-31	\N
192	192	1	Rare	f	f	f	f	2025-10-31	\N
193	193	1	Rare	f	f	f	f	2025-10-31	\N
194	194	1	Rare	f	f	f	f	2025-10-31	\N
194a	194	1	Overnumbered	f	t	t	f	2025-10-31	\N
195	195	1	Rare	f	f	f	f	2025-10-31	\N
196	196	1	Rare	f	f	f	f	2025-10-31	\N
197	197	1	Rare	f	f	f	f	2025-10-31	\N
197a	197	1	Overnumbered	f	t	t	f	2025-10-31	\N
198	198	1	Rare	f	f	f	f	2025-10-31	\N
199	199	1	Rare	f	f	f	f	2025-10-31	\N
200	200	1	Rare	f	f	f	f	2025-10-31	\N
201	201	1	Epic	f	f	f	f	2025-10-31	\N
202	202	1	Epic	f	f	f	f	2025-10-31	\N
202a	202	1	Overnumbered	f	t	t	f	2025-10-31	\N
203	203	1	Epic	f	f	f	f	2025-10-31	\N
204	204	1	Epic	f	f	f	f	2025-10-31	\N
205	205	1	Epic	f	f	f	f	2025-10-31	\N
205a	205	1	Overnumbered	f	t	t	f	2025-10-31	\N
206	206	1	Common	f	f	f	f	2025-10-31	\N
207	207	1	Common	f	f	f	f	2025-10-31	\N
208	208	1	Common	f	f	f	f	2025-10-31	\N
209	209	1	Common	f	f	f	f	2025-10-31	\N
210	210	1	Common	f	f	f	f	2025-10-31	\N
211	211	1	Common	f	f	f	f	2025-10-31	\N
212	212	1	Common	f	f	f	f	2025-10-31	\N
213	213	1	Common	f	f	f	f	2025-10-31	\N
214	214	1	Common	f	f	f	f	2025-10-31	\N
214a	214	1	Overnumbered	f	t	t	f	2025-10-31	\N
215	215	1	Common	f	f	f	f	2025-10-31	\N
216	216	1	Common	f	f	f	f	2025-10-31	\N
217	217	1	Common	f	f	f	f	2025-10-31	\N
218	218	1	Common	f	f	f	f	2025-10-31	\N
219	219	1	Common	f	f	f	f	2025-10-31	\N
220	220	1	Uncommon	f	f	f	f	2025-10-31	\N
221	221	1	Uncommon	f	f	f	f	2025-10-31	\N
222	222	1	Uncommon	f	f	f	f	2025-10-31	\N
223	223	1	Uncommon	f	f	f	f	2025-10-31	\N
224	224	1	Uncommon	f	f	f	f	2025-10-31	\N
225	225	1	Uncommon	f	f	f	f	2025-10-31	\N
226	226	1	Uncommon	f	f	f	f	2025-10-31	\N
227	227	1	Uncommon	f	f	f	f	2025-10-31	\N
228	228	1	Uncommon	f	f	f	f	2025-10-31	\N
229	229	1	Uncommon	f	f	f	f	2025-10-31	\N
230	230	1	Rare	f	f	f	f	2025-10-31	\N
231	231	1	Rare	f	f	f	f	2025-10-31	\N
232	232	1	Rare	f	f	f	f	2025-10-31	\N
233	233	1	Rare	f	f	f	f	2025-10-31	\N
234	234	1	Rare	f	f	f	f	2025-10-31	\N
235	235	1	Rare	f	f	f	f	2025-10-31	\N
236	236	1	Rare	f	f	f	f	2025-10-31	\N
237	237	1	Rare	f	f	f	f	2025-10-31	\N
238	238	1	Rare	f	f	f	f	2025-10-31	\N
238a	238	1	Overnumbered	f	t	t	f	2025-10-31	\N
239	239	1	Rare	f	f	f	f	2025-10-31	\N
240	240	1	Rare	f	f	f	f	2025-10-31	\N
240a	240	1	Overnumbered	f	t	t	f	2025-10-31	\N
241	241	1	Rare	f	f	f	f	2025-10-31	\N
242	242	1	Epic	f	f	f	f	2025-10-31	\N
243	243	1	Epic	f	f	f	f	2025-10-31	\N
243a	243	1	Overnumbered	f	t	t	f	2025-10-31	\N
244	244	1	Epic	f	f	f	f	2025-10-31	\N
245	245	1	Epic	f	f	f	f	2025-10-31	\N
246	246	1	Epic	f	f	f	f	2025-10-31	\N
246a	246	1	Overnumbered	f	t	t	f	2025-10-31	\N
247	247	1	Rare	f	f	f	f	2025-10-31	\N
248	248	1	Epic	f	f	f	f	2025-10-31	\N
249	249	1	Rare	f	f	f	f	2025-10-31	\N
250	250	1	Epic	f	f	f	f	2025-10-31	\N
251	251	1	Rare	f	f	f	f	2025-10-31	\N
252	252	1	Epic	f	f	f	f	2025-10-31	\N
253	253	1	Rare	f	f	f	f	2025-10-31	\N
254	254	1	Epic	f	f	f	f	2025-10-31	\N
255	255	1	Rare	f	f	f	f	2025-10-31	\N
256	256	1	Epic	f	f	f	f	2025-10-31	\N
257	257	1	Rare	f	f	f	f	2025-10-31	\N
258	258	1	Epic	f	f	f	f	2025-10-31	\N
259	259	1	Rare	f	f	f	f	2025-10-31	\N
260	260	1	Epic	f	f	f	f	2025-10-31	\N
261	261	1	Rare	f	f	f	f	2025-10-31	\N
262	262	1	Epic	f	f	f	f	2025-10-31	\N
263	263	1	Rare	f	f	f	f	2025-10-31	\N
264	264	1	Epic	f	f	f	f	2025-10-31	\N
265	265	1	Rare	f	f	f	f	2025-10-31	\N
266	266	1	Epic	f	f	f	f	2025-10-31	\N
267	267	1	Rare	f	f	f	f	2025-10-31	\N
268	268	1	Epic	f	f	f	f	2025-10-31	\N
269	269	1	Rare	f	f	f	f	2025-10-31	\N
270	270	1	Epic	f	f	f	f	2025-10-31	\N
271	271	1	Common	f	f	f	f	2025-10-31	\N
272	272	1	Common	f	f	f	f	2025-10-31	\N
273	273	1	Common	f	f	f	f	2025-10-31	\N
274	274	1	Common	f	f	f	f	2025-10-31	\N
275	275	1	Uncommon	f	f	f	f	2025-10-31	\N
276	276	1	Uncommon	f	f	f	f	2025-10-31	\N
277	277	1	Uncommon	f	f	f	f	2025-10-31	\N
278	278	1	Uncommon	f	f	f	f	2025-10-31	\N
279	279	1	Uncommon	f	f	f	f	2025-10-31	\N
280	280	1	Uncommon	f	f	f	f	2025-10-31	\N
281	281	1	Uncommon	f	f	f	f	2025-10-31	\N
282	282	1	Uncommon	f	f	f	f	2025-10-31	\N
283	283	1	Uncommon	f	f	f	f	2025-10-31	\N
284	284	1	Uncommon	f	f	f	f	2025-10-31	\N
285	285	1	Uncommon	f	f	f	f	2025-10-31	\N
286	286	1	Uncommon	f	f	f	f	2025-10-31	\N
287	287	1	Uncommon	f	f	f	f	2025-10-31	\N
288	288	1	Uncommon	f	f	f	f	2025-10-31	\N
289	289	1	Uncommon	f	f	f	f	2025-10-31	\N
290	290	1	Uncommon	f	f	f	f	2025-10-31	\N
291	291	1	Uncommon	f	f	f	f	2025-10-31	\N
292	292	1	Uncommon	f	f	f	f	2025-10-31	\N
293	293	1	Uncommon	f	f	f	f	2025-10-31	\N
294	294	1	Uncommon	f	f	f	f	2025-10-31	\N
295	295	1	Uncommon	f	f	f	f	2025-10-31	\N
296	296	1	Uncommon	f	f	f	f	2025-10-31	\N
297	297	1	Uncommon	f	f	f	f	2025-10-31	\N
298	298	1	Uncommon	f	f	f	f	2025-10-31	\N
299	299	1	Overnumbered	f	t	t	f	2025-10-31	\N
299a	299	1	Overnumbered	f	t	t	t	2025-10-31	\N
300	300	1	Overnumbered	f	t	t	f	2025-10-31	\N
300a	300	1	Overnumbered	f	t	t	t	2025-10-31	\N
301	301	1	Overnumbered	f	t	t	f	2025-10-31	\N
301a	301	1	Overnumbered	f	t	t	t	2025-10-31	\N
302	302	1	Overnumbered	f	t	t	f	2025-10-31	\N
302a	302	1	Overnumbered	f	t	t	t	2025-10-31	\N
303	303	1	Overnumbered	f	t	t	f	2025-10-31	\N
303a	303	1	Overnumbered	f	t	t	t	2025-10-31	\N
304	304	1	Overnumbered	f	t	t	f	2025-10-31	\N
304a	304	1	Overnumbered	f	t	t	t	2025-10-31	\N
305	305	1	Overnumbered	f	t	t	f	2025-10-31	\N
305a	305	1	Overnumbered	f	t	t	t	2025-10-31	\N
306	306	1	Overnumbered	f	t	t	f	2025-10-31	\N
306a	306	1	Overnumbered	f	t	t	t	2025-10-31	\N
307	307	1	Overnumbered	f	t	t	f	2025-10-31	\N
307a	307	1	Overnumbered	f	t	t	t	2025-10-31	\N
308	308	1	Overnumbered	f	t	t	f	2025-10-31	\N
308a	308	1	Overnumbered	f	t	t	t	2025-10-31	\N
309	309	1	Overnumbered	f	t	t	f	2025-10-31	\N
309a	309	1	Overnumbered	f	t	t	t	2025-10-31	\N
310	310	1	Overnumbered	f	t	t	f	2025-10-31	\N
310a	310	1	Overnumbered	f	t	t	t	2025-10-31	\N
\.


--
-- Data for Name: card_set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.card_set (set_id, set_name, set_code, release_date, total_cards, description) FROM stdin;
1	Origins	OGN	2024-01-01	310	Main set
\.


--
-- Data for Name: collection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collection (collection_id, user_id, collection_name, date_created, is_primary) FROM stdin;
1	1	My Collection	2025-12-07	t
2	2	My Collection	2025-12-07	t
\.


--
-- Data for Name: collection_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.collection_card (collection_id, printing_id, quantity, condition, date_added) FROM stdin;
1	7a	1	Near Mint	2025-12-07
1	13	1	Near Mint	2025-12-07
1	30a	1	Near Mint	2025-12-07
1	76a	1	Near Mint	2025-12-07
\.


--
-- Data for Name: deck; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deck (deck_id, user_id, deck_name, primary_domain, date_created, last_modified, description) FROM stdin;
\.


--
-- Data for Name: deck_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deck_card (deck_id, printing_id, quantity) FROM stdin;
\.


--
-- Data for Name: set; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.set (set_id, set_name, set_code, release_date, total_cards, description) FROM stdin;
1	Origins	OGN	2025-01-15	298	The first set of Riftbound - includes units, spells, gear, runes, legends, and battlefields
2	Origins Alternate Art	OGN*	2025-01-15	12	Alternate art versions from Origins set
\.


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tag (tag_id, tag_name) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, email, password, date_joined) FROM stdin;
1	brianna	bpinson23@icloud.com	$2b$10$XfZTT7QeqN.AsMGDj4wVo.Tdtooyiu8rc0RGmOv64cHeq8jVIp27G	2025-12-07
2	joe	blph3y@umsystem.edu	$2b$10$ESyfTy74SUJRNPxXQQT4cuamfsEnrATo6gEFbNfHFDPgLYEElouy2	2025-12-07
\.


--
-- Name: card_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.card_card_id_seq', 310, true);


--
-- Name: card_set_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.card_set_set_id_seq', 1, false);


--
-- Name: collection_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.collection_collection_id_seq', 2, true);


--
-- Name: deck_deck_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deck_deck_id_seq', 1, false);


--
-- Name: set_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.set_set_id_seq', 2, true);


--
-- Name: tag_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tag_tag_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 2, true);


--
-- Name: card card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card
    ADD CONSTRAINT card_pkey PRIMARY KEY (card_id);


--
-- Name: card_printing card_printing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_printing
    ADD CONSTRAINT card_printing_pkey PRIMARY KEY (printing_id);


--
-- Name: card_set card_set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_set
    ADD CONSTRAINT card_set_pkey PRIMARY KEY (set_id);


--
-- Name: card_set card_set_set_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_set
    ADD CONSTRAINT card_set_set_code_key UNIQUE (set_code);


--
-- Name: collection_card collection_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_card
    ADD CONSTRAINT collection_card_pkey PRIMARY KEY (collection_id, printing_id);


--
-- Name: collection collection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_pkey PRIMARY KEY (collection_id);


--
-- Name: deck_card deck_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck_card
    ADD CONSTRAINT deck_card_pkey PRIMARY KEY (deck_id, printing_id);


--
-- Name: deck deck_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck
    ADD CONSTRAINT deck_pkey PRIMARY KEY (deck_id);


--
-- Name: set set_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.set
    ADD CONSTRAINT set_pkey PRIMARY KEY (set_id);


--
-- Name: set set_set_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.set
    ADD CONSTRAINT set_set_code_key UNIQUE (set_code);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: tag tag_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: card_printing card_printing_card_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_printing
    ADD CONSTRAINT card_printing_card_id_fkey FOREIGN KEY (card_id) REFERENCES public.card(card_id) ON DELETE CASCADE;


--
-- Name: card_printing card_printing_set_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_printing
    ADD CONSTRAINT card_printing_set_id_fkey FOREIGN KEY (set_id) REFERENCES public.card_set(set_id) ON DELETE CASCADE;


--
-- Name: collection_card collection_card_collection_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_card
    ADD CONSTRAINT collection_card_collection_id_fkey FOREIGN KEY (collection_id) REFERENCES public.collection(collection_id) ON DELETE CASCADE;


--
-- Name: collection_card collection_card_printing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection_card
    ADD CONSTRAINT collection_card_printing_id_fkey FOREIGN KEY (printing_id) REFERENCES public.card_printing(printing_id) ON DELETE CASCADE;


--
-- Name: collection collection_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collection
    ADD CONSTRAINT collection_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: deck_card deck_card_deck_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck_card
    ADD CONSTRAINT deck_card_deck_id_fkey FOREIGN KEY (deck_id) REFERENCES public.deck(deck_id) ON DELETE CASCADE;


--
-- Name: deck_card deck_card_printing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck_card
    ADD CONSTRAINT deck_card_printing_id_fkey FOREIGN KEY (printing_id) REFERENCES public.card_printing(printing_id) ON DELETE CASCADE;


--
-- Name: deck deck_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deck
    ADD CONSTRAINT deck_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict yK7CWiqOe2Z8SICZHMkwBdRdEBQ22R0mUDcuCeiKnfF1D5ydORIgE0UYj2qy18K

