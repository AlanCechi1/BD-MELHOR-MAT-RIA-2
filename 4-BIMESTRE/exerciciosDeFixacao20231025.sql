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
