-- Consultas do banco BD_TV_FILMES

-- Questão 1: Programas do tipo Filme do gênero Comédia
SELECT p.titulo, p.ano
FROM programatv p
JOIN tipo t ON t.id_tipo = p.id_tipo
JOIN prog_genero pg ON pg.id_programa = p.id_programa
JOIN genero g ON g.id_genero = pg.id_genero
WHERE t.nome = 'Filme' AND g.nome = 'Comédia';

-- Questão 2: Programas brasileiros do tipo Série, mais atuais primeiro
SELECT p.titulo, p.ano
FROM programatv p
JOIN tipo t ON t.id_tipo = p.id_tipo
JOIN prog_informacoes i ON i.id_programa = p.id_programa
JOIN pais pa ON pa.id_pais = i.id_pais
WHERE pa.nome = 'Brasil' AND t.nome = 'Série'
ORDER BY p.ano DESC;

-- Questão 3: Os 5 gêneros mais bem avaliados
SELECT g.nome AS genero, ROUND(AVG(a.nota), 2) AS media
FROM genero g
JOIN prog_genero pg ON pg.id_genero = g.id_genero
JOIN avaliacao a ON a.id_programa = pg.id_programa
GROUP BY g.id_genero, g.nome
ORDER BY media DESC, g.nome
LIMIT 5;

-- Questão 4: Programas da América do Sul do gênero Terror
SELECT p.titulo, pa.nome AS pais
FROM programatv p
JOIN prog_informacoes i ON i.id_programa = p.id_programa
JOIN pais pa ON pa.id_pais = i.id_pais
JOIN prog_genero pg ON pg.id_programa = p.id_programa
JOIN genero g ON g.id_genero = pg.id_genero
WHERE g.nome = 'Terror'
  AND pa.nome IN ('Brasil', 'Argentina', 'Chile', 'Colômbia', 'Uruguai', 'Peru', 'Paraguai', 'Bolívia', 'Equador', 'Venezuela');

-- Questão 5: Nota média dos programas de TV
SELECT ROUND(AVG(nota), 2) AS nota_media_geral
FROM avaliacao;

-- Questão 6: Os 10 programas mais indicados (mais avaliações)
SELECT p.titulo, COUNT(*) AS qtd_avaliacoes, ROUND(AVG(a.nota), 2) AS media
FROM programatv p
JOIN avaliacao a ON a.id_programa = p.id_programa
GROUP BY p.id_programa, p.titulo
ORDER BY qtd_avaliacoes DESC, media DESC, p.titulo
LIMIT 10;

-- Questão 7: As 10 séries de suspense mais bem avaliadas
SELECT p.titulo, ROUND(AVG(a.nota), 2) AS media
FROM programatv p
JOIN tipo t ON t.id_tipo = p.id_tipo
JOIN prog_genero pg ON pg.id_programa = p.id_programa
JOIN genero g ON g.id_genero = pg.id_genero
JOIN avaliacao a ON a.id_programa = p.id_programa
WHERE t.nome = 'Série' AND g.nome = 'Suspense'
GROUP BY p.id_programa, p.titulo
ORDER BY media DESC, p.titulo
LIMIT 10;

-- Questão 8: Os 15 atores do elenco de filmes mais bem avaliados
SELECT at.nome, ROUND(AVG(a.nota), 2) AS media_dos_filmes
FROM ator at
JOIN pro_elenco e ON e.id_ator = at.id_ator
JOIN programatv p ON p.id_programa = e.id_programa
JOIN tipo t ON t.id_tipo = p.id_tipo
JOIN avaliacao a ON a.id_programa = p.id_programa
WHERE t.nome = 'Filme' AND e.chk_ator = TRUE
GROUP BY at.id_ator, at.nome
ORDER BY media_dos_filmes DESC, at.nome
LIMIT 15;

-- Questão 9: Títulos e tipos de Série, Anime ou Reality Show, por ano decrescente
SELECT p.titulo, t.nome AS tipo, p.ano
FROM programatv p
JOIN tipo t ON t.id_tipo = p.id_tipo
WHERE t.nome IN ('Série', 'Anime', 'Reality Show')
ORDER BY p.ano DESC, p.titulo;

-- Questão 10: Plataformas com mais de 5 programas disponíveis
SELECT pl.nome AS plataforma, COUNT(*) AS qtd_programas
FROM plataforma pl
JOIN disponibilidade d ON d.id_plataforma = pl.id_plataforma
GROUP BY pl.id_plataforma, pl.nome
HAVING COUNT(*) > 5
ORDER BY qtd_programas DESC, pl.nome;

-- Questão 11: Programas com média de nota entre 6 e 8
SELECT p.titulo, ROUND(AVG(a.nota), 2) AS media
FROM programatv p
JOIN avaliacao a ON a.id_programa = p.id_programa
GROUP BY p.id_programa, p.titulo
HAVING AVG(a.nota) BETWEEN 6 AND 8
ORDER BY media DESC, p.titulo;

-- Questão 12: Programas que possuem elenco e já foram avaliados
SELECT p.titulo
FROM programatv p
WHERE EXISTS (SELECT 1 FROM pro_elenco e WHERE e.id_programa = p.id_programa)
  AND EXISTS (SELECT 1 FROM avaliacao a WHERE a.id_programa = p.id_programa)
ORDER BY p.titulo;

-- Questão 13: Soma das notas recebidas por programa (maior para o menor)
SELECT p.titulo, SUM(a.nota) AS soma_notas
FROM programatv p
JOIN avaliacao a ON a.id_programa = p.id_programa
GROUP BY p.id_programa, p.titulo
ORDER BY soma_notas DESC, p.titulo;

-- Questão 14: Programas de Comédia ou Musical disponíveis na plataforma
-- (parâmetro alterado de 'Netflix' para 'Amazon Prime Video', pois nenhuma comédia estava na Netflix)
SELECT DISTINCT p.titulo, g.nome AS genero
FROM programatv p
JOIN prog_genero pg ON pg.id_programa = p.id_programa
JOIN genero g ON g.id_genero = pg.id_genero
JOIN disponibilidade d ON d.id_programa = p.id_programa
JOIN plataforma pl ON pl.id_plataforma = d.id_plataforma
WHERE g.nome IN ('Comédia', 'Musical') AND pl.nome = 'Amazon Prime Video'
ORDER BY p.titulo;

-- Questão 15: Programa mais bem avaliado e menos avaliado (pela média das notas)
WITH m AS (
    SELECT p.titulo, AVG(a.nota) AS media
    FROM programatv p
    JOIN avaliacao a ON a.id_programa = p.id_programa
    GROUP BY p.id_programa, p.titulo
)
SELECT 'Mais bem avaliado' AS situacao, titulo, ROUND(media, 2) AS media
FROM m WHERE media = (SELECT MAX(media) FROM m)
UNION ALL
SELECT 'Menos avaliado', titulo, ROUND(media, 2)
FROM m WHERE media = (SELECT MIN(media) FROM m);

-- Questão 16: Programas com mais de dois atores no elenco
SELECT p.titulo, COUNT(*) AS qtd_no_elenco
FROM programatv p
JOIN pro_elenco e ON e.id_programa = p.id_programa
GROUP BY p.id_programa, p.titulo
HAVING COUNT(*) > 2
ORDER BY qtd_no_elenco DESC, p.titulo;

-- Questão 17: Programas com mais de um gênero e com avaliações registradas
SELECT p.titulo, COUNT(DISTINCT pg.id_genero) AS qtd_generos
FROM programatv p
JOIN prog_genero pg ON pg.id_programa = p.id_programa
WHERE EXISTS (SELECT 1 FROM avaliacao a WHERE a.id_programa = p.id_programa)
GROUP BY p.id_programa, p.titulo
HAVING COUNT(DISTINCT pg.id_genero) > 1
ORDER BY qtd_generos DESC, p.titulo;

-- Questão 18: Os 5 atores que mais participaram de programas como atores (não diretores)
SELECT at.nome, COUNT(*) AS total_programas
FROM ator at
JOIN pro_elenco e ON e.id_ator = at.id_ator
WHERE e.chk_ator = TRUE
GROUP BY at.id_ator, at.nome
ORDER BY total_programas DESC, at.nome
LIMIT 5;

-- Questão 19: Programas com média acima da média geral das avaliações
SELECT p.titulo, ROUND(AVG(a.nota), 2) AS media
FROM programatv p
JOIN avaliacao a ON a.id_programa = p.id_programa
GROUP BY p.id_programa, p.titulo
HAVING AVG(a.nota) > (SELECT AVG(nota) FROM avaliacao)
ORDER BY media DESC, p.titulo;

-- Questão 20: Programas lançados entre 2000 e 2010, com país de origem e sinopse
SELECT pa.nome AS pais, p.titulo, p.ano, i.sinopse
FROM programatv p
JOIN prog_informacoes i ON i.id_programa = p.id_programa
JOIN pais pa ON pa.id_pais = i.id_pais
WHERE p.ano BETWEEN 2000 AND 2010
ORDER BY pa.nome, p.titulo;

-- Questão 21: Programas exibidos em pelo menos 3 plataformas distintas
SELECT p.titulo, COUNT(DISTINCT d.id_plataforma) AS qtd_plataformas
FROM programatv p
JOIN disponibilidade d ON d.id_programa = p.id_programa
GROUP BY p.id_programa, p.titulo
HAVING COUNT(DISTINCT d.id_plataforma) >= 3
ORDER BY qtd_plataformas DESC, p.titulo;

-- Questão 22: Diretores que dirigiram mais de 1 programa do gênero Drama
SELECT at.nome AS diretor, COUNT(DISTINCT p.id_programa) AS qtd_programas
FROM ator at
JOIN pro_elenco e ON e.id_ator = at.id_ator
JOIN programatv p ON p.id_programa = e.id_programa
JOIN prog_genero pg ON pg.id_programa = p.id_programa
JOIN genero g ON g.id_genero = pg.id_genero
WHERE e.chk_diretor = TRUE AND g.nome = 'Drama'
GROUP BY at.id_ator, at.nome
HAVING COUNT(DISTINCT p.id_programa) > 1;

-- Questão 23: Países com programas avaliados e soma das notas por país
SELECT pa.nome AS pais, SUM(a.nota) AS soma_notas
FROM pais pa
JOIN prog_informacoes i ON i.id_pais = pa.id_pais
JOIN avaliacao a ON a.id_programa = i.id_programa
GROUP BY pa.id_pais, pa.nome
ORDER BY soma_notas DESC, pa.nome;
