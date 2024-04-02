drop schema teste_produto;
create schema teste_produto;
use teste_produto;

create table PRODUTO(
	codigo int(2),
    descricao varchar(20)
);

insert into PRODUTO 
values	(1, 'maça'),
		(2, 'cenoura'),
        (3, 'bola'),
        (4, 'smartphone'),
        (5, 'notebook'),
        (6, 'garrafa de água'),
        (7, 'relógio');
        
DELIMITER //

create procedure ExibirProdutoOferta()
BEGIN
    declare dia_semana varchar(20);
    declare produto_oferta varchar(100);
    declare codigo_produto int;

    set lc_time_names = 'pt_PT';
    set dia_semana = DAYNAME(SYSDATE());

    select case dia_semana
        when 'Domingo' then 1
        when 'Segunda' then 2
        when 'Terça' then 3
        when 'Quarta' then 4
        when 'Quinta' then 5
        when 'Sexta' then 6
        when 'Sábado' then 7
    end into codigo_produto;
    
    select DESCRICAO into produto_oferta
    from PRODUTO
    where CODIGO = codigo_produto;

    select concat('Hoje é ', dia_semana, ' e o produto em oferta é ', produto_oferta, '.') as mensagem;
END //
DELIMITER ;

call ExibirProdutoOferta();
