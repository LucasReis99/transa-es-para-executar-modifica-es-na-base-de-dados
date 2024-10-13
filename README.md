# Projeto de Transações em MySQL

Este projeto tem como objetivo demonstrar o uso de transações no MySQL, incluindo a execução de transações simples e transações em procedimentos, bem como a realização de backup e recuperação de um banco de dados.

## Estrutura do Projeto

O projeto é dividido em três partes:

### PARTE 1 – TRANSAÇÕES

Nesta parte, foram realizadas transações diretamente no banco de dados sem o uso de procedimentos. As principais etapas incluídas foram:

1. Desabilitação do autocommit.
2. Início de uma transação.
3. Inserção de dados em uma tabela de vendas.
4. Atualização do estoque de produtos.
5. Confirmação das alterações ou reversão em caso de erro.

**Código de Exemplo:**

SET autocommit = 0;

START TRANSACTION;

INSERT INTO vendas (produto_id, quantidade, data_venda) VALUES (1, 2, NOW());
UPDATE produtos SET estoque = estoque - 2 WHERE id = 1;

COMMIT; -- ou ROLLBACK em caso de erro


# PARTE 2 – TRANSAÇÃO COM PROCEDURE
Nesta parte, foi criada uma procedure que encapsula a lógica de transação e inclui tratamento de erros. A procedure verifica se houve erros durante a execução e realiza um rollback, se necessário.
DELIMITER //

CREATE PROCEDURE realizar_venda(IN p_produto_id INT, IN p_quantidade INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro ao realizar a venda, transação revertida.' AS mensagem;
    END;

    START TRANSACTION;

    INSERT INTO vendas (produto_id, quantidade, data_venda) VALUES (p_produto_id, p_quantidade, NOW());
    UPDATE produtos SET estoque = estoque - p_quantidade WHERE id = p_produto_id;

    COMMIT;
    SELECT 'Venda realizada com sucesso!' AS mensagem;
END //

DELIMITER ;

# PARTE 3 – BACKUP E RECOVERY
Esta parte do projeto envolve a criação de backups e recuperação do banco de dados ecommerce. Utilizamos o mysqldump para realizar o backup e a restauração.

Comandos de Backup e Recuperação:
# Backup do banco de dados
mysqldump -u usuario -p ecommerce > ecommerce_backup.sql

# Recuperação do banco de dados
mysql -u usuario -p ecommerce < ecommerce_backup.sql

