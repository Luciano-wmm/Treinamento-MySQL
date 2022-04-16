# --- AULA 3: ANÁLISES DE DADOS COM SQL --- #

-- Agrupamentos
-- Filtragem avançada
-- Joins
-- Subqueries
-- Criação de Views

-- Lembrando das tabelas do banco de dados...

SELECT * FROM alugueis;
SELECT * FROM atores;
SELECT * FROM atuacoes;
SELECT * FROM clientes;
SELECT * FROM filmes;

# =======        PARTE 1:        =======#
# =======  CRIANDO AGRUPAMENTOS  =======#

-- CASE 1. Você deverá começar fazendo uma análise para descobrir o preço médio de aluguel dos filmes.

select round(avg(preco_aluguel), 2) from filmes;

-- Agora que você sabe o preço médio para se alugar filmes na hashtagmovie, você deverá ir além na sua análise e descobrir qual é o preço médio para cada gênero de filme.

/*
genero                   | preco_medio
______________________________________
Comédia                  | X
Drama                    | Y
Ficção e Fantasia        | Z
Mistério e Suspense      | A
Arte                     | B
Animação                 | C
Ação e Aventura          | D
*/

select
	genero,
    round(avg(preco_aluguel),2) as preço_medio
from 
	filmes
group by
	genero;

-- Você seria capaz de mostrar os gêneros de forma ordenada, de acordo com a média?

select
	genero,
    round(avg(preco_aluguel),2) as preço_medio
from 
	filmes
group by
	genero 
order by
	preço_medio desc;
    


-- Altere a consulta anterior para mostrar na nossa análise também a quantidade de filmes para cada gênero, conforme exemplo abaixo.

/*
genero                   | preco_medio      | qtd_filmes
_______________________________________________________
Comédia                  | X                | .
Drama                    | Y                | ..
Ficção e Fantasia        | Z                | ...
Mistério e Suspense      | A                | ....
Arte                     | B                | .....
Animação                 | C                | ......
Ação e Aventura          | D                | .......
*/

select
	genero,
    round(avg(preco_aluguel),2) as preço_medio,
    count(*) as qtd_filmes
from 
	filmes
group by
	genero 
order by
	preço_medio desc;


-- CASE 2. Para cada filme, descubra a classificação média, o número de avaliações e a quantidade de vezes que cada filme foi alugado. Ordene essa consulta a partir da avaliacao_media, em ordem decrescente.

/*
id_filme  | avaliacao_media   | num_avaliacoes  | num_alugueis
_______________________________________________________
1         | X                 | .               | .
2         | Y                 | ..              | ..
3         | Z                 | ...             | ...
4         | A                 | ....            | ....
5         | B                 | .....           | .....
...
*/

select 
	id_filme,
    avg(nota) as avaliaçao_media,
    count(nota) as num_avaliaçoes,
    count(*) as num_alugeis
from
	alugueis
group by
	id_filme
order by
	avaliaçao_media desc;



# =======              PARTE 2:               =======#
# =======  FILTROS AVANÇADOS EM AGRUPAMENTOS  =======#

-- CASE 3. Você deve alterar a consulta DO CASE 1 e considerar os 2 cenários abaixo:

-- Cenário 1: Fazer a mesma análise, mas considerando apenas os filmes com ANO_LANCAMENTO igual a 2011.

select
	genero,
    round(avg(preco_aluguel),2) as preço_medio,
    count(*) as qtd_filmes
from 
	filmes
where
	ano_lancamento = 2011
group by
	genero 
order by
	preço_medio desc;

-- Cenário 2: Fazer a mesma análise, mas considerando apenas os filmes dos gêneros com mais de 10 filmes.

select
	genero,
    round(avg(preco_aluguel),2) as preço_medio,
    count(*) as qtd_filmes
from 
	filmes
group by
	genero 
having 
	qtd_filmes >= 10
order by
	preço_medio desc;


# =======              PARTE 3:              =======#
# =======  RELACIONANDO TABELAS COM O JOIN   =======#


-- CASE 4. Selecione a tabela de Atuações. Observe que nela, existem apenas os ids dos filmes e ids dos atores. Você seria capaz de completar essa tabela com as informações de títulos dos filmes e nomes dos atores?

select 
	atuacoes.*,
    filmes.titulo,
    atores.nome_ator
from atuacoes
left join filmes
on atuacoes.id_filme = filmes.id_filme
left join atores
on atuacoes.id_ator = atores.id_ator;

-- CASE 5. Média de avaliações dos clientes

select 
	clientes.nome_cliente,
    round(avg(alugueis.nota),2) as avaliacao_media
from alugueis
left join clientes
on alugueis.id_cliente = clientes.id_cliente
group by clientes.nome_cliente
order by avaliacao_media desc;



# =======                         PARTE 4:                           =======#
# =======  SUBQUERIES: UTILIZANDO UM SELECT DENTRO DE OUTRO SELECT   =======#

-- CASE 6. Você precisará fazer uma análise de desempenho dos filmes. Para isso, uma análise comum é identificar quais filmes têm uma nota acima da média. Você seria capaz de fazer isso?

select avg(nota) from alugueis; 		-- 7.94

select 
	filmes.titulo,
    avg(alugueis.nota) as avaliacao_media
from alugueis
left join filmes
on alugueis.id_filme = filmes.id_filme
group by filmes.titulo
having avaliacao_media >= (select avg(nota) from alugueis);


-- CASE 7. A administração da MovieNow quer relatar os principais indicadores de desempenho (KPIs) para o desempenho da empresa em 2018. Eles estão interessados em medir os sucessos financeiros, bem como o envolvimento do usuário. Os KPIs importantes são, portanto, a receita proveniente da locação de filmes, o número de locações de filmes e o número de clientes ativos (descubra também quantos clientes não estão ativos).




# =======   PARTE 5:     =======#
# =======  CREATE VIEW   =======#


-- CREATE/DROP VIEW: Guardando o resultado de uma consulta no nosso banco de dados


-- CASE 8. Crie uma view para guardar o resultado do SELECT abaixo.

create view resultados as
SELECT
	titulo,
    COUNT(*) AS num_alugueis,
    AVG(nota) AS media_nota,
    SUM(preco_aluguel) AS receita_total
FROM alugueis
LEFT JOIN filmes
ON alugueis.id_filme = filmes.id_filme
GROUP BY titulo
ORDER BY num_alugueis DESC;

select * from resultados;
