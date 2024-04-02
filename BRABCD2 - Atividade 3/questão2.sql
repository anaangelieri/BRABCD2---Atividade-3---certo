DROP DATABASE banco_escolar;
create schema banco_escolar;
use banco_escolar;

create table ALUNO (
  Nome VARCHAR(255) NOT NULL,
  Numero_aluno INT NOT NULL,
  Tipo_aluno VARCHAR(50) NOT NULL,
  Curso VARCHAR(50) NOT NULL,
  PRIMARY KEY (Numero_aluno)
);

create table DISCIPLINA (
  Nome_disciplina VARCHAR(255) NOT NULL,
  Numero_disciplina VARCHAR(50) NOT NULL,
  Creditos INT NOT NULL,
  Departamento VARCHAR(50) NOT NULL,
  PRIMARY KEY (Numero_disciplina)
);

create table TURMA (
  Identificacao_turma VARCHAR(50) NOT NULL,
  Numero_disciplina VARCHAR(50) NOT NULL,
  Semestre VARCHAR(50) NOT NULL,
  Ano INT NOT NULL,
  Professor VARCHAR(255) NOT NULL,
  PRIMARY KEY (Identificacao_turma)
);

create table HISTORICO_ESCOLAR (
  Numero_aluno INT NOT NULL,
  Identificacao_turma VARCHAR(50) NOT NULL,
  Nota char(1),
  FOREIGN KEY (Numero_aluno) REFERENCES ALUNO(Numero_aluno),
  FOREIGN KEY (Identificacao_turma) REFERENCES TURMA(Identificacao_turma)
);

create table PRE_REQUISITO (
  Numero_disciplina VARCHAR(50) NOT NULL,
  Numero_pre_requisito VARCHAR(50) NOT NULL,
  FOREIGN KEY (Numero_disciplina) REFERENCES DISCIPLINA(Numero_disciplina),
  FOREIGN KEY (Numero_pre_requisito) REFERENCES DISCIPLINA(Numero_disciplina) 
);

insert into ALUNO (Nome, Numero_aluno, Tipo_aluno, Curso)
values ('Silva', 17, 'B', 'CC'),
       ('Braga', 8, 'A', 'CC');

insert into DISCIPLINA (Nome_disciplina, Numero_disciplina, Creditos, Departamento)
values ('Introd. à ciência da computação', 'CC1310', 4, 'CC'),
       ('Estruturas de dados', 'CC3320', 4, 'CC'),
       ('Matemática discreta', 'MAT2410', 3, 'MAT'),
       ('Banco de dados', 'CC3380', 3, 'CC');

insert into TURMA (Identificacao_turma, Numero_disciplina, Semestre, Ano, Professor)
values ('85', 'MAT2410', 'Segundo', 07, 'Kleber'),
       ('92', 'CC1310', '102', 112, 'CC3020'),
       ('102', 'CC3380', 'Segundo', 07, 'Anderson'),
       ('112', 'MAT2410', 'Segundo', 08, 'Chang'),
       ('119', 'CC1310', 'Segundo', 08, 'Anderson'),
       ('135', 'CC3380', 'Segundo', 08, 'Santos');

insert into HISTORICO_ESCOLAR (Numero_aluno, Identificacao_turma, Nota)
values (17, '112', 'B'),
       (17, '119', 'C'),
       (8, '85', 'A'),
       (8, '92', 'A'),
       (8, '102', 'B'),
       (8, '135', 'A');

insert into PRE_REQUISITO (Numero_disciplina, Numero_pre_requisito)
values ('CC3380', 'CC3320'),
       ('CC3380', 'MAT2410'),
       ('CC3320', 'CC1310');

#1. Crie uma consulta de Natural Join entre as tabelas DISCIPLINA e TURMA.
select * from DISCIPLINA natural join TURMA;

#2. Crie uma consulta que mostre os pré-requisitos de todas as DISCIPLINAS. 
#Se uma disciplina não contiver pré-requisito, ela deve ser listada mesmo assim.
select D.nome_disciplina, D.Numero_disciplina, P.Numero_pre_requisito 
from DISCIPLINA D 
left join PRE_REQUISITO P on D.Numero_disciplina = P.Numero_disciplina;

#3. Crie uma consulta que mostre as DISCIPLINAs com notas no HISTORICO_ESCOLAR e seus ALUNOs 
#(Todas as DISCIPLINAS devem ser listadas).
select D.Nome_disciplina, H.Nota, A.Nome
from DISCIPLINA D 
left join TURMA t on D.Numero_disciplina = T.Numero_disciplina
left join HISTORICO_ESCOLAR H on T.Identificacao_turma = H.Identificacao_turma
left join ALUNO A on H.Numero_aluno = A.Numero_aluno;

#4. Crie uma consulta que retorne o nome, numero_disciplina e creditos de todas as disciplinas em que o aluno 'Silva'
# está matriculado. Utilize algum JOIN para isso.
select d.Nome_disciplina, d.Numero_disciplina, d.Creditos
from DISCIPLINA d
join TURMA t on d.Numero_disciplina = t.Numero_disciplina
join HISTORICO_ESCOLAR he on t.Identificacao_turma = he.Identificacao_turma
join ALUNO a on he.Numero_aluno = A.Numero_aluno
where a.Nome = 'Silva';

#5. Crie uma consulta que mostre as DISCIPLINAs com notas no HISTORICO_ESCOLAR e seus ALUNOs 
#(Todas as DISCIPLINAS devem ser listadas).
select D.Nome_disciplina, H.Nota, A.Nome
from DISCIPLINA D 
left join TURMA t on D.Numero_disciplina = T.Numero_disciplina
left join HISTORICO_ESCOLAR H on T.Identificacao_turma = H.Identificacao_turma
left join ALUNO A on H.Numero_aluno = A.Numero_aluno;

#5. Escreva uma Stored Procedure para ler o nome de um aluno e imprimir sua média de notas, 
#considerando que A=4, B=3, C=2 e D=1 ponto. 

DELIMITER //
create procedure Stored_pro(in aluno_nome varchar(255))
BEGIN
    declare media decimal(3,2);
    
    select avg(
		case when H.Nota = 'A' then 4
        when H.Nota = 'B' then 3
        when H.Nota = 'C' then 2
        when H.Nota = 'D' then 1
        else 0
        end)
	into media from HISTORICO_ESCOLAR H 
    join ALUNO A on H.Numero_aluno = A.Numero_aluno
    where A.Nome = aluno_nome;
    
	select concat('A média de notas do aluno ', aluno_nome, ' é: ', media);
	
END //
DELIMITER ;

call Stored_pro('Braga');

#6. Crie uma Function que retorne a nota média de um aluno dado o seu nome.
DELIMITER //

create function CalcularMedia(aluno_nome varchar(255))
returns float
deterministic
BEGIN
    declare media float;

    select avg(
		case when H.Nota = 'A' then 4
        when H.Nota = 'B' then 3
        when H.Nota = 'C' then 2
        when H.Nota = 'D' then 1
        else 0
        end)
    into media
    from HISTORICO_ESCOLAR H
    join ALUNO A on H.Numero_aluno = A.Numero_aluno
    where A.Nome = aluno_nome;

    return media;
END //

DELIMITER ;

select CalcularMedia('Silva');

#7. Utilizando a Function criada na atividade anterior, 
#crie uma consulta que liste as disciplinas em que o aluno de Nome `BRAGA` possua pontuação acima da média de suas notas.
select d.Nome_disciplina, h.Nota, A.Nome
from HISTORICO_ESCOLAR H
join ALUNO A on H.Numero_aluno = A.Numero_aluno
join TURMA T on H.Identificacao_turma = T.Identificacao_turma
join DISCIPLINA D on T.Numero_disciplina = D.Numero_disciplina
where A.Nome = 'Braga' and H.Nota > (select CalcularMedia('Braga'));


SELECT d.Nome_disciplina
FROM DISCIPLINA d
JOIN TURMA t ON d.Numero_disciplina = t.Numero_disciplina
JOIN HISTORICO_ESCOLAR he ON t.Identificacao_turma = he.Identificacao_turma
JOIN ALUNO a ON he.Numero_aluno = a.Numero_aluno
WHERE a.Nome = 'Braga'
GROUP BY d.Nome_disciplina
HAVING AVG(
    CASE 
        WHEN he.Nota = 'A' THEN 4.0
        WHEN he.Nota = 'B' THEN 3.0
        WHEN he.Nota = 'C' THEN 2.0
        WHEN he.Nota = 'D' THEN 1.0
        ELSE 0.0
    END
) > (select CalcularMedia('Braga'));


