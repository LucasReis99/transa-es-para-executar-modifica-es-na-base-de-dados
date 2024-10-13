SET autocommit = 0;

START TRANSACTION;

-- Exemplo de inserção de venda
INSERT INTO vendas (produto_id, quantidade, data_venda) VALUES (1, 2, NOW());

-- Exemplo de atualização de estoque
UPDATE produtos SET estoque = estoque - 2 WHERE id = 1;

-- Se tudo estiver correto, confirme as alterações
COMMIT;
ROLLBACK;

DELIMITER //

CREATE PROCEDURE realizar_venda(IN p_produto_id INT, IN p_quantidade INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- ROLLBACK em caso de erro
        ROLLBACK;
        SELECT 'Erro ao realizar a venda, transação revertida.' AS mensagem;
    END;

    START TRANSACTION;

    -- Inserindo a venda
    INSERT INTO vendas (produto_id, quantidade, data_venda) VALUES (p_produto_id, p_quantidade, NOW());

    -- Atualizando o estoque
    UPDATE produtos SET estoque = estoque - p_quantidade WHERE id = p_produto_id;

    -- Se tudo estiver correto, confirme as alterações
    COMMIT;
    SELECT 'Venda realizada com sucesso!' AS mensagem;
END //

DELIMITER ;

CALL realizar_venda(1, 2);

mysqldump -u usuario -p ecommerce > ecommerce_backup.sql
mysql -u usuario -p ecommerce < ecommerce_backup.sql
mysqldump -u usuario -p --routines --events --databases db1 db2 > multi_db_backup.sql
