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