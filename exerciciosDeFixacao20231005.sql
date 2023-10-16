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