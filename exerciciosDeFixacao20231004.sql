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

