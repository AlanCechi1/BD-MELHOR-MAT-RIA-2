Função para Contagem de Livros por Gênero:

DELIMITER //

CREATE FUNCTION total_livros_por_genero(genero_nome VARCHAR(255)) RETURNS INT
BEGIN
    DECLARE total INT;
    DECLARE genero_id INT;

    -- Encontre o ID do gênero com base no nome fornecido
    SELECT id INTO genero_id FROM Genero WHERE nome = genero_nome;

    -- Inicialize o contador
    SET total = 0;

    -- Crie um cursor para percorrer os livros com o gênero especificado
    DECLARE cursor_livros CURSOR FOR
    SELECT l.id
    FROM Livro l
    INNER JOIN Livro_Genero lg ON l.id = lg.id_livro
    WHERE lg.id_genero = genero_id;

    -- Percorra o cursor e conte os livros
    OPEN cursor_livros;
    FETCH cursor_livros INTO total;
    CLOSE cursor_livros;

    RETURN total;
END;

//

DELIMITER ;

Função para Listar Livros de um Autor Específico:

DELIMITER //

CREATE FUNCTION listar_livros_por_autor(primeiro_nome VARCHAR(255), ultimo_nome VARCHAR(255)) RETURNS TEXT
BEGIN
    DECLARE lista_livros TEXT;
    DECLARE autor_id INT;

    -- Encontre o ID do autor com base no primeiro e último nome fornecidos
    SELECT id INTO autor_id FROM Autor WHERE primeiro_nome = primeiro_nome AND ultimo_nome = ultimo_nome;

    -- Inicialize a lista
    SET lista_livros = '';

    -- Crie um cursor para percorrer os livros do autor
    DECLARE cursor_livros CURSOR FOR
    SELECT l.titulo
    FROM Livro l
    INNER JOIN Livro_Autor la ON l.id = la.id_livro
    WHERE la.id_autor = autor_id;

    -- Percorra o cursor e adicione os títulos dos livros à lista
    OPEN cursor_livros;
    FETCH cursor_livros INTO lista_livros;
    CLOSE cursor_livros;

    RETURN lista_livros;
END;

//

DELIMITER ;

Função para Atualizar Resumos de Livros:

DELIMITER //

CREATE FUNCTION atualizar_resumos() RETURNS INT
BEGIN
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE livro_id INT;
    DECLARE resumo_atual VARCHAR(1000);

    -- Crie um cursor para percorrer os livros
    DECLARE cursor_livros CURSOR FOR
    SELECT id, resumo
    FROM Livro;

    -- Percorra o cursor e atualize os resumos
    OPEN cursor_livros;
    update_loop: LOOP
        FETCH cursor_livros INTO livro_id, resumo_atual;
        IF done THEN
            LEAVE update_loop;
        END IF;
        -- Atualize o resumo adicionando a frase desejada
        UPDATE Livro SET resumo = CONCAT(resumo_atual, ' Este é um excelente livro!') WHERE id = livro_id;
    END LOOP update_loop;
    CLOSE cursor_livros;

    RETURN 1;
END;

//

DELIMITER ;




