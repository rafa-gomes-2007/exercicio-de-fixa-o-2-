DELIMITER //
CREATE FUNCTION total_livros_por_genero(nome_genero VARCHAR(255))
RETURNS INT
BEGIN
    DECLARE total_livros INT;
    SET total_livros = 0;

    DECLARE done INT DEFAULT FALSE;
    DECLARE livro_id INT;

   
    DECLARE cur CURSOR FOR SELECT id FROM Livro WHERE id_genero = (SELECT id FROM Genero WHERE nome_genero = nome_genero);

   
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO livro_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

       
        SET total_livros = total_livros + 1;
    END LOOP;

    CLOSE cur;

    RETURN total_livros;
END //
DELIMITER ;

SELECT total_livros_por_genero('Romance') AS total_romance;

DELIMITER //
CREATE FUNCTION listar_livros_por_autor(first_name VARCHAR(255), last_name VARCHAR(255))
RETURNS TEXT
BEGIN
    DECLARE lista_titulos TEXT DEFAULT '';
    DECLARE done INT DEFAULT FALSE;
    DECLARE livro_titulo VARCHAR(255);

    
    DECLARE cur CURSOR FOR
        SELECT Livro.titulo
        FROM Livro_Autor
        JOIN Livro ON Livro_Autor.id_livro = Livro.id
        JOIN Autor ON Livro_Autor.id_autor = Autor.id
        WHERE Autor.primeiro_nome = first_name AND Autor.ultimo_nome = last_name;

   
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO livro_titulo;
        IF done THEN
            LEAVE read_loop;
        END IF;

        
        SET lista_titulos = CONCAT(lista_titulos, livro_titulo, ', ');
    END LOOP;

    CLOSE cur;

    RETURN lista_titulos;
END //
DELIMITER ;

SELECT listar_livros_por_autor('João', 'Silva') AS livros_joao_silva;


DELIMITER //
CREATE FUNCTION atualizar_resumos()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE livro_id INT;
    DECLARE livro_resumo TEXT;

    
    DECLARE cur CURSOR FOR SELECT id, resumo FROM Livro;

  
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO livro_id, livro_resumo;
        IF done THEN
            LEAVE read_loop;
        END IF;


        UPDATE Livro SET resumo = CONCAT(livro_resumo, ' Este é um excelente livro!') WHERE id = livro_id;
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

CALL atualizar_resumos();


DELIMITER //
CREATE FUNCTION media_livros_por_editora()
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total_livros INT;
    DECLARE total_editoras INT;

    -- Inicializar contadores
    SET total_livros = 0;
    SET total_editoras = 0;

    DECLARE done INT DEFAULT FALSE;
    DECLARE editora_id INT;
    DECLARE editora_nome VARCHAR(255);


    DECLARE cur CURSOR FOR SELECT id, nome_editora FROM Editora;

   
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO editora_id, editora_nome;
        IF done THEN
            LEAVE read_loop;
        END IF;

       
        SELECT COUNT(*) INTO total_livros FROM Livro WHERE id_editora = editora_id;
        SET total_editoras = total_editoras + total_livros;
    END LOOP;

    CLOSE cur;

 
    IF total_editoras > 0 THEN
        RETURN total_editoras / (SELECT COUNT(*) FROM Editora);
    ELSE
        RETURN 0;
    END IF;
END //
DELIMITER ;

SELECT media_livros_por_editora() AS media_livros_editora;


DELIMITER //
CREATE FUNCTION autores_sem_livros()
RETURNS TEXT
BEGIN
    DECLARE lista_autores TEXT DEFAULT '';
    DECLARE done INT DEFAULT FALSE;
    DECLARE autor_nome VARCHAR(255);

   
    DECLARE cur CURSOR FOR
        SELECT CONCAT(primeiro_nome, ' ', ultimo_nome) AS nome
        FROM Autor
        WHERE id NOT IN (SELECT DISTINCT id_autor FROM Livro_Autor);

  
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO autor_nome;
        IF done THEN
            LEAVE read_loop;
        END IF;

       
        SET lista_autores = CONCAT(lista_autores, autor_nome, ', ');
    END LOOP;

    CLOSE cur;

    RETURN lista_autores;
END //
DELIMITER ;


SELECT autores_sem_livros() AS autores_sem_livros;
