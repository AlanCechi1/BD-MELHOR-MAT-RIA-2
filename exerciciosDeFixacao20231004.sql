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

Função para Obter a Média de Livros por Editora:

DELIMITER //

CREATE FUNCTION media_livros_por_editora() RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE media DECIMAL(10, 2);
    DECLARE total_livros INT;
    DECLARE total_editoras INT;

    -- Inicialize as variáveis
    SET media = 0;
    SET total_livros = 0;
    SET total_editoras = 0;

    -- Crie um cursor para percorrer as editoras
    DECLARE cursor_editoras CURSOR FOR
    SELECT id FROM Editora;

    -- Percorra o cursor e calcule a média
    OPEN cursor_editoras;
    average_loop: LOOP
        FETCH cursor_editoras INTO total_editoras;
        IF total_editoras IS NULL THEN
            LEAVE average_loop;
        END IF;
        -- Conte os livros publicados pela editora atual
        SELECT COUNT(*) INTO total_livros FROM Livro WHERE id_editora = total_editoras;
        -- Atualize a média
        SET media = media + total_livros;
    END LOOP average_loop;
    CLOSE cursor_editoras;

    -- Calcule a média
    SET media = media / total_editoras;

    RETURN media;
END;

//

DELIMITER ;

Função para Listar Autores sem Livros Publicados:


DELIMITER //

CREATE FUNCTION autores_sem_livros() RETURNS TEXT
BEGIN
    DECLARE lista_autores TEXT;

    -- Inicialize a lista
    SET lista_autores = '';

    -- Crie um cursor para percorrer os autores
    DECLARE cursor_autores CURSOR FOR
    SELECT a.primeiro_nome, a.ultimo_nome
    FROM Autor a
    LEFT JOIN Livro_Autor la ON a.id = la.id_autor
    WHERE la.id_livro IS NULL;

    -- Percorra o cursor e adicione os autores à lista
    OPEN cursor_autores;
    author_loop: LOOP
        DECLARE primeiro_nome VARCHAR(255);
        DECLARE ultimo_nome VARCHAR(255);
        FETCH cursor_autores INTO primeiro_nome, ultimo_nome;
        IF primeiro_nome IS NULL THEN
            LEAVE author_loop;
        END IF;
        -- Adicione o autor à lista
        SET lista_autores = CONCAT(lista_autores, primeiro_nome, ' ', ultimo_nome, ', ');
    END LOOP author_loop;
    CLOSE cursor_autores;

    RETURN lista_autores;
END;

//

DELIMITER ;





