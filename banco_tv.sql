-- Banco de dados: BD_TV_FILMES (PostgreSQL)

CREATE DATABASE bd_tv_filmes;
\c bd_tv_filmes

CREATE TABLE tipo (
    id_tipo INTEGER PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE pais (
    id_pais INTEGER PRIMARY KEY,
    nome VARCHAR(60)
);

CREATE TABLE genero (
    id_genero INTEGER PRIMARY KEY,
    nome VARCHAR(50)
);

CREATE TABLE plataforma (
    id_plataforma INTEGER PRIMARY KEY,
    nome VARCHAR(60)
);

CREATE TABLE contatos (
    id_contato INTEGER PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(120),
    senha VARCHAR(64)
);

CREATE TABLE ator (
    id_ator INTEGER PRIMARY KEY,
    nome VARCHAR(100),
    id_pais INTEGER REFERENCES pais (id_pais)
);

CREATE TABLE programatv (
    id_programa INTEGER PRIMARY KEY,
    titulo VARCHAR(150),
    ano INTEGER,
    id_tipo INTEGER REFERENCES tipo (id_tipo)
);

CREATE TABLE prog_informacoes (
    id_prog_inf INTEGER PRIMARY KEY,
    titulo_original VARCHAR(150),
    sinopse TEXT,
    id_programa INTEGER UNIQUE REFERENCES programatv (id_programa),
    id_pais INTEGER REFERENCES pais (id_pais)
);

CREATE TABLE avaliacao (
    id_contato INTEGER REFERENCES contatos (id_contato),
    id_programa INTEGER REFERENCES programatv (id_programa),
    nota NUMERIC(3,1),
    PRIMARY KEY (id_contato, id_programa)
);

CREATE TABLE pro_elenco (
    id_programa INTEGER REFERENCES programatv (id_programa),
    id_ator INTEGER REFERENCES ator (id_ator),
    chk_ator BOOLEAN,
    chk_diretor BOOLEAN,
    PRIMARY KEY (id_programa, id_ator)
);

CREATE TABLE prog_genero (
    id_programa INTEGER REFERENCES programatv (id_programa),
    id_genero INTEGER REFERENCES genero (id_genero),
    PRIMARY KEY (id_programa, id_genero)
);

CREATE TABLE disponibilidade (
    id_programa INTEGER REFERENCES programatv (id_programa),
    id_plataforma INTEGER REFERENCES plataforma (id_plataforma),
    PRIMARY KEY (id_programa, id_plataforma)
);

-- tipo
INSERT INTO tipo (id_tipo, nome) VALUES
    (1, 'Filme'),
    (2, 'Série'),
    (3, 'Minissérie'),
    (4, 'Documentário'),
    (5, 'Animação'),
    (6, 'Reality Show'),
    (7, 'Novela'),
    (8, 'Anime'),
    (9, 'Especial'),
    (10, 'Curta-metragem'),
    (11, 'Talk Show'),
    (12, 'Programa de Auditório'),
    (13, 'Telejornal'),
    (14, 'Esporte'),
    (15, 'Stand-up');

-- pais
INSERT INTO pais (id_pais, nome) VALUES
    (1, 'Brasil'),
    (2, 'Estados Unidos'),
    (3, 'Reino Unido'),
    (4, 'Coreia do Sul'),
    (5, 'Espanha'),
    (6, 'Japão'),
    (7, 'França'),
    (8, 'Alemanha'),
    (9, 'Itália'),
    (10, 'Canadá'),
    (11, 'Argentina'),
    (12, 'México'),
    (13, 'Austrália'),
    (14, 'Índia'),
    (15, 'Dinamarca'),
    (16, 'Suécia');

-- genero
INSERT INTO genero (id_genero, nome) VALUES
    (1, 'Drama'),
    (2, 'Comédia'),
    (3, 'Ação'),
    (4, 'Ficção Científica'),
    (5, 'Terror'),
    (6, 'Romance'),
    (7, 'Suspense'),
    (8, 'Aventura'),
    (9, 'Fantasia'),
    (10, 'Crime'),
    (11, 'Documentário'),
    (12, 'Animação'),
    (13, 'Musical'),
    (14, 'Guerra'),
    (15, 'Biografia');

-- plataforma
INSERT INTO plataforma (id_plataforma, nome) VALUES
    (1, 'Netflix'),
    (2, 'Amazon Prime Video'),
    (3, 'Disney+'),
    (4, 'Max'),
    (5, 'Apple TV+'),
    (6, 'Globoplay'),
    (7, 'Paramount+'),
    (8, 'Crunchyroll'),
    (9, 'YouTube'),
    (10, 'Telecine'),
    (11, 'MUBI'),
    (12, 'Pluto TV'),
    (13, 'Claro tv+'),
    (14, 'Looke'),
    (15, 'Belas Artes à La Carte');

-- contatos
INSERT INTO contatos (id_contato, nome, email, senha) VALUES
    (1, 'Ana Souza', 'ana.souza@example.com', 'f5cf299fd63e1433e95b69e5b5b4adef57b17cfd93a01f65c146a5e2cb3e684f'),
    (2, 'Bruno Lima', 'bruno.lima@example.com', '6bd7b855e21c17b0dd2dfb2ce910d50e98974579fcc226960648936af1a1c3e3'),
    (3, 'Carla Mendes', 'carla.mendes@example.com', '3cd578a569e8f99f2a5a1a1748b5e6aaaf3611704c74fc23037abace49ec251e'),
    (4, 'Diego Ferreira', 'diego.ferreira@example.com', '3448cd976cfa929214bbcf938385fd91199798fdec4a9b0a294a8d24b5630678'),
    (5, 'Eduarda Alves', 'eduarda.alves@example.com', '1e1e1754242df3011a6982f0293b6bb5b99d4e697bff50f4a6e2f7185683b37e'),
    (6, 'Felipe Rocha', 'felipe.rocha@example.com', 'fbe2fc6f8a3a92e1d42718465ce85a9359978a39357c175b8887a64e0c5ae8b7'),
    (7, 'Gabriela Martins', 'gabriela.martins@example.com', 'ead777cb8732af9a338957ba81626b39ba4dcbf5c20dc8514c5c164979576fbe'),
    (8, 'Henrique Costa', 'henrique.costa@example.com', 'e479a94e630e2e8ad58e32af339a4ffe05ed86717c65b2c81e71027dfee38db9'),
    (9, 'Isabela Nunes', 'isabela.nunes@example.com', '53fb7756f8db4434a43ea53a02b5ae3d99862625db58a511f8891c92c49e90e7'),
    (10, 'João Pereira', 'joao.pereira@example.com', '5f06d8d88269474fd5e8f4caa4b5f236e04673dd61db67cabcafc0a9f0a414fc'),
    (11, 'Karina Duarte', 'karina.duarte@example.com', '59bc66852ab33d2f9b6940a6ac6e9a602846fdc59d3fbc340457e1ecd8252604'),
    (12, 'Lucas Barbosa', 'lucas.barbosa@example.com', '3f31fa8751a93fff727e1240429a058e22846aaf32c146812d34841c23846612'),
    (13, 'Mariana Teixeira', 'mariana.teixeira@example.com', 'a14ea3ce2ea56535c4d7370c7519fa699a23ff62356a7c8730d3d9e6660d7487'),
    (14, 'Nicolas Ribeiro', 'nicolas.ribeiro@example.com', '47ab767799d7a3be1307b9c5024c06c05ee386f8a02f103e48bb24a50b806b21'),
    (15, 'Olívia Cardoso', 'olivia.cardoso@example.com', '4bd5d5b4dc72f0566c03a4766a8524d5b763e612aa7ae68dd985a1163c00ebb3');

-- ator
INSERT INTO ator (id_ator, nome, id_pais) VALUES
    (1, 'Millie Bobby Brown', 3),
    (2, 'Bryan Cranston', 2),
    (3, 'Song Kang-ho', 4),
    (4, 'Úrsula Corberó', 5),
    (5, 'Alexandre Rodrigues', 1),
    (6, 'Louis Hofmann', 8),
    (7, 'Olivia Colman', 3),
    (8, 'Lee Jung-jae', 4),
    (9, 'Matthew McConaughey', 2),
    (10, 'Tom Hanks', 2),
    (11, 'Jared Harris', 3),
    (12, 'Débora Falabella', 1),
    (13, 'Matheus Nachtergaele', 1),
    (14, 'Fernando Meirelles', 1),
    (15, 'Bong Joon-ho', 4),
    (16, 'Winona Ryder', 2),
    (17, 'David Harbour', 2),
    (18, 'Finn Wolfhard', 10),
    (19, 'Aaron Paul', 2),
    (20, 'Anna Gunn', 2),
    (21, 'Choi Woo-shik', 4),
    (22, 'Álvaro Morte', 5),
    (23, 'Pedro Alonso', 5),
    (24, 'Seu Jorge', 1),
    (25, 'Lisa Vicari', 8),
    (26, 'Baran bo Odar', 8),
    (27, 'Claire Foy', 3),
    (28, 'Hwang Dong-hyuk', 4),
    (29, 'Anne Hathaway', 2),
    (30, 'Christopher Nolan', 3),
    (31, 'Tim Allen', 2),
    (32, 'Stellan Skarsgård', 16),
    (33, 'Murilo Benício', 1),
    (34, 'Selton Mello', 1),
    (35, 'Guel Arraes', 1),
    (36, 'David Attenborough', 3),
    (37, 'Mamoru Miyano', 6);

-- programatv
INSERT INTO programatv (id_programa, titulo, ano, id_tipo) VALUES
    (1, 'Stranger Things', 2016, 2),
    (2, 'Breaking Bad', 2008, 2),
    (3, 'Parasita', 2019, 1),
    (4, 'La Casa de Papel', 2017, 2),
    (5, 'Cidade de Deus', 2002, 1),
    (6, 'Dark', 2017, 2),
    (7, 'The Crown', 2016, 2),
    (8, 'Round 6', 2021, 2),
    (9, 'Interestelar', 2014, 1),
    (10, 'Planeta Terra II', 2016, 4),
    (11, 'Death Note', 2006, 8),
    (12, 'Toy Story', 1995, 5),
    (13, 'Chernobyl', 2019, 3),
    (14, 'Avenida Brasil', 2012, 7),
    (15, 'O Auto da Compadecida', 1999, 3);

-- prog_informacoes
INSERT INTO prog_informacoes (id_prog_inf, titulo_original, sinopse, id_programa, id_pais) VALUES
    (1, 'Stranger Things', 'Em Hawkins, em 1983, um menino desaparece e um grupo de amigos encontra uma garota com poderes psíquicos ligada a um mundo sombrio.', 1, 2),
    (2, 'Breaking Bad', 'Um professor de química com câncer passa a fabricar metanfetamina para garantir o futuro financeiro da família.', 2, 2),
    (3, 'Gisaengchung', 'A família pobre Ki-taek se infiltra aos poucos na casa de uma família rica, e o plano termina em um confronto inesperado.', 3, 4),
    (4, 'La Casa de Papel', 'Um grupo liderado pelo Professor executa um assalto à Casa da Moeda da Espanha com reféns e planejamento detalhado.', 4, 5),
    (5, 'Cidade de Deus', 'A história de Buscapé e do crescimento do crime organizado em uma favela do Rio de Janeiro entre as décadas de 1960 e 1980.', 5, 1),
    (6, 'Dark', 'O desaparecimento de crianças em uma cidade alemã revela viagens no tempo e segredos de quatro famílias.', 6, 8),
    (7, 'The Crown', 'Acompanha o reinado da rainha Elizabeth II e os acontecimentos políticos e pessoais que marcaram a monarquia britânica.', 7, 3),
    (8, 'Ojingeo Geim', 'Centenas de pessoas endividadas disputam jogos infantis mortais por um prêmio bilionário.', 8, 4),
    (9, 'Interstellar', 'Um ex-piloto lidera uma missão através de um buraco de minhoca para encontrar um novo planeta habitável para a humanidade.', 9, 2),
    (10, 'Planet Earth II', 'Documentário narrado por David Attenborough sobre a vida selvagem em ilhas, montanhas, selvas, desertos, pradarias e cidades.', 10, 3),
    (11, 'Desu Noto', 'O estudante Light Yagami encontra um caderno capaz de matar qualquer pessoa cujo nome seja escrito nele.', 11, 6),
    (12, 'Toy Story', 'O boneco de cowboy Woody vê sua posição ameaçada pela chegada do astronauta Buzz Lightyear no quarto de Andy.', 12, 2),
    (13, 'Chernobyl', 'Recria o desastre nuclear de 1986 na Ucrânia soviética e o esforço para conter suas consequências.', 13, 2),
    (14, 'Avenida Brasil', 'Rita volta ao Rio de Janeiro com o nome de Nina para se vingar de Carminha, que a abandonou em um lixão na infância.', 14, 1),
    (15, 'O Auto da Compadecida', 'Os nordestinos João Grilo e Chicó usam a esperteza para sobreviver no sertão e acabam diante do julgamento final.', 15, 1);

-- avaliacao
INSERT INTO avaliacao (id_contato, id_programa, nota) VALUES
    (1, 1, 8.0),
    (1, 6, 10.0),
    (1, 10, 8.0),
    (2, 2, 8.0),
    (2, 7, 8.0),
    (2, 11, 9.0),
    (3, 3, 9.0),
    (3, 8, 9.0),
    (3, 12, 8.0),
    (4, 4, 6.5),
    (4, 9, 9.0),
    (4, 13, 8.0),
    (5, 5, 7.0),
    (5, 10, 9.0),
    (5, 14, 7.0),
    (6, 6, 9.0),
    (6, 11, 7.5),
    (6, 15, 9.0),
    (7, 7, 8.0),
    (7, 12, 8.0),
    (7, 1, 9.5),
    (8, 8, 8.0),
    (8, 13, 7.0),
    (8, 2, 7.5),
    (9, 9, 7.0),
    (9, 14, 10.0),
    (9, 3, 9.0),
    (10, 10, 6.5),
    (10, 15, 9.5),
    (10, 4, 10.0),
    (11, 11, 10.0),
    (11, 1, 6.5),
    (12, 12, 8.0),
    (12, 2, 8.0),
    (13, 13, 10.0),
    (13, 3, 8.0),
    (14, 14, 8.0),
    (14, 4, 8.0),
    (15, 15, 9.5),
    (15, 5, 9.5);

-- pro_elenco
INSERT INTO pro_elenco (id_programa, id_ator, chk_ator, chk_diretor) VALUES
    (1, 1, TRUE, FALSE),
    (1, 16, TRUE, FALSE),
    (1, 17, TRUE, FALSE),
    (1, 18, TRUE, FALSE),
    (2, 2, TRUE, FALSE),
    (2, 19, TRUE, FALSE),
    (2, 20, TRUE, FALSE),
    (3, 3, TRUE, FALSE),
    (3, 15, FALSE, TRUE),
    (3, 21, TRUE, FALSE),
    (4, 4, TRUE, FALSE),
    (4, 22, TRUE, FALSE),
    (4, 23, TRUE, FALSE),
    (5, 5, TRUE, FALSE),
    (5, 14, FALSE, TRUE),
    (5, 13, TRUE, FALSE),
    (5, 24, TRUE, FALSE),
    (6, 6, TRUE, FALSE),
    (6, 25, TRUE, FALSE),
    (6, 26, FALSE, TRUE),
    (7, 7, TRUE, FALSE),
    (7, 11, TRUE, FALSE),
    (7, 27, TRUE, FALSE),
    (8, 8, TRUE, FALSE),
    (8, 28, FALSE, TRUE),
    (9, 9, TRUE, FALSE),
    (9, 29, TRUE, FALSE),
    (9, 30, FALSE, TRUE),
    (10, 36, TRUE, FALSE),
    (11, 37, TRUE, FALSE),
    (12, 10, TRUE, FALSE),
    (12, 31, TRUE, FALSE),
    (13, 11, TRUE, FALSE),
    (13, 32, TRUE, FALSE),
    (14, 12, TRUE, FALSE),
    (14, 33, TRUE, FALSE),
    (15, 13, TRUE, FALSE),
    (15, 34, TRUE, FALSE),
    (15, 35, FALSE, TRUE);

-- prog_genero
INSERT INTO prog_genero (id_programa, id_genero) VALUES
    (1, 4),
    (1, 7),
    (1, 5),
    (2, 1),
    (2, 10),
    (2, 7),
    (3, 7),
    (3, 2),
    (3, 1),
    (4, 10),
    (4, 3),
    (4, 7),
    (5, 10),
    (5, 1),
    (6, 4),
    (6, 7),
    (6, 1),
    (7, 1),
    (7, 15),
    (8, 1),
    (8, 7),
    (8, 3),
    (9, 4),
    (9, 8),
    (9, 1),
    (10, 11),
    (11, 7),
    (11, 12),
    (11, 9),
    (12, 12),
    (12, 2),
    (12, 8),
    (13, 1),
    (13, 15),
    (13, 7),
    (14, 1),
    (14, 6),
    (15, 2),
    (15, 8);

-- disponibilidade
INSERT INTO disponibilidade (id_programa, id_plataforma) VALUES
    (1, 1),
    (1, 9),
    (2, 1),
    (2, 2),
    (3, 2),
    (3, 11),
    (3, 14),
    (4, 1),
    (4, 2),
    (5, 2),
    (5, 10),
    (5, 6),
    (6, 1),
    (7, 1),
    (7, 2),
    (8, 1),
    (9, 2),
    (9, 7),
    (9, 9),
    (10, 4),
    (10, 2),
    (10, 9),
    (11, 1),
    (11, 8),
    (12, 3),
    (12, 2),
    (12, 9),
    (13, 4),
    (13, 2),
    (14, 6),
    (14, 9),
    (14, 12),
    (15, 6),
    (15, 14),
    (15, 10);

-- dados complementares (para as consultas retornarem resultados)
INSERT INTO ator (id_ator, nome, id_pais) VALUES
    (38, 'João Miguel', 1),
    (39, 'Maximiliano Ghione', 11),
    (40, 'Demián Rugna', 11),
    (41, 'Julianne Moore', 2);

INSERT INTO programatv (id_programa, titulo, ano, id_tipo) VALUES
    (16, 'Ensaio sobre a Cegueira', 2008, 1),
    (17, '3%', 2016, 2),
    (18, 'Aterrados', 2017, 1);

INSERT INTO prog_informacoes (id_prog_inf, titulo_original, sinopse, id_programa, id_pais) VALUES
    (16, 'Blindness', 'Uma epidemia de cegueira branca atinge uma cidade e os infectados são colocados em quarentena, onde a ordem social se desfaz.', 16, 1),
    (17, '3%', 'Em um Brasil distópico, jovens de 20 anos passam por um processo seletivo em que apenas 3% chegam ao lado próspero da sociedade.', 17, 1),
    (18, 'Aterrados', 'Moradores de um bairro de Buenos Aires são assombrados por fenômenos sobrenaturais, e um grupo de investigadores tenta entendê-los.', 18, 11);

INSERT INTO prog_genero (id_programa, id_genero) VALUES
    (16, 1), (16, 7), (17, 4), (17, 1), (17, 7), (18, 5);

INSERT INTO pro_elenco (id_programa, id_ator, chk_ator, chk_diretor) VALUES
    (16, 14, FALSE, TRUE), (16, 41, TRUE, FALSE), (17, 38, TRUE, FALSE),
    (18, 39, TRUE, FALSE), (18, 40, FALSE, TRUE);

INSERT INTO disponibilidade (id_programa, id_plataforma) VALUES
    (16, 10), (17, 1), (18, 11);

INSERT INTO avaliacao (id_contato, id_programa, nota) VALUES
    (1, 16, 8.0), (6, 16, 6.5), (2, 17, 8.5), (4, 17, 9.0), (3, 18, 7.5), (5, 18, 8.0);
