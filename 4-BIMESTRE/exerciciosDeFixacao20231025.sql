Trigger para inserção de um novo cliente na tabela Clientes:

DELIMITER //
CREATE TRIGGER cliente_insert_trigger
AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Novo cliente inserido em ', NOW()));
END;
//
DELIMITER ;

Trigger para tentativa de exclusão de um cliente da tabela Clientes:

DELIMITER //
CREATE TRIGGER cliente_delete_trigger
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Tentativa de exclusão de cliente com ID ', OLD.id, ' em ', NOW()));
END;
//
DELIMITER ;

Trigger para atualização do nome de um cliente na tabela Clientes:

DELIMITER //
CREATE TRIGGER cliente_update_trigger
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido atualizar o nome para uma string vazia ou NULL.';
    ELSE
        INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Nome do cliente com ID ', OLD.id, ' atualizado de "', OLD.nome, '" para "', NEW.nome, '" em ', NOW()));
    END IF;
END;
//
DELIMITER ;

Trigger para impedir a atualização do nome do cliente para uma string vazia ou NULL e inserir uma mensagem na tabela Auditoria:

DELIMITER //
CREATE TRIGGER cliente_name_check_trigger
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é permitido atualizar o nome para uma string vazia ou NULL.';
    END IF;
END;
//
DELIMITER ;

