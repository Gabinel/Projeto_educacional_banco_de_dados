-------------------------------------
----------- COMANDOS DDL ------------
-------- CRIANDO AS TABELAS ---------
-------------------------------------

CREATE TABLE alunos (
	id_aluno SERIAL PRIMARY KEY,
	nome_aluno varchar(50) NOT NULL,
	cpf varchar(14) UNIQUE NOT NULL,
	idade int NOT NULL,
	formado boolean NOT NULL
);

-- O comando "ALTER TABLE" a seguir se repetirá em todas as tabelas, pois
-- o varchar foi dado com o n de caracteres entre "[]", porém o certo era com "()"
ALTER TABLE alunos ALTER COLUMN nome_aluno TYPE varchar(50);
ALTER TABLE alunos ALTER COLUMN cpf TYPE varchar(14);

-- FORMADO faz mais sentido estar na tabela "alunos_cursos, pois um aluno pode estar formado em vários cursos diferentes."
ALTER TABLE alunos DROP COLUMN formado;

-- Armazena as formas de contato de um aluno
-- Recebe o ID do aluno como FK, o contato é dado em uma única coluna
-- O contato pode ser via e-mail e telefone, desta forma
CREATE TABLE contato (
	id_contato SERIAL PRIMARY KEY,
	id_aluno int REFERENCES alunos,
	contato varchar[20] UNIQUE
);

-- O contato deve ser único (não faz sentido ter emails ou números de telefones iguais)
ALTER TABLE contato ADD UNIQUE (contato);

-- Fez-se necessário aumentar a quantidade de caracteres, caso seja um email
ALTER TABLE contato ALTER COLUMN contato TYPE varchar(30);

-- No fim das contas, é melhor criar uma coluna para email e outra para o telefone
	-- Caso query's específicas venham a ser feitas
ALTER TABLE contato DROP COLUMN contato;
ALTER TABLE contato ADD COLUMN email varchar(30)

-- Armazena o endereço do aluno
-- Recebe o ID do aluno como FK e as demais informações são distribuídas nas colunas
CREATE TABLE endereco (
	id_endereco SERIAL PRIMARY KEY,
	id_aluno int REFERENCES alunos,
	logradouro varchar[20] NOT NULL,
	numero int NOT NULL,
	cidade varchar[15] NOT NULL,
	uf varchar[2] NOT NULL
);

-- A seguinte alteração adiciona uma restrição UNIQUE à FK "id_aluno"
-- Dessa forma, um aluno não pode cadastrar mais de um endereço
ALTER TABLE endereco ADD UNIQUE (id_aluno);
-- O tamanho do logradouro do endereço também se fez necesário
ALTER TABLE endereco ALTER COLUMN logradouro TYPE varchar(30);
ALTER TABLE endereco ALTER COLUMN cidade TYPE varchar(15);
ALTER TABLE endereco ALTER COLUMN uf TYPE varchar(2);

CREATE TABLE departamentos (
	id_departamento SERIAL PRIMARY KEY,
	nome_departamento varchar[10],
	coordenador varchar[20]
);

ALTER TABLE departamentos ALTER COLUMN nome_departamento TYPE varchar(10);
ALTER TABLE departamentos ALTER COLUMN coordenador TYPE varchar(20);

-- Cursos recebem seu respectivo departamento pela fk "id_departamentos"
CREATE TABLE cursos (
	id_curso SERIAL PRIMARY KEY,
	id_departamento int REFERENCES departamentos,
	nome_curso varchar[15],
	formacao varchar[10]
);

-- Fez-se necessário aumentar o tamanho do nome do curso e o tamanho da formacao
ALTER TABLE cursos ALTER COLUMN nome_curso TYPE varchar(35);
ALTER TABLE cursos ALTER COLUMN formacao TYPE varchar(13);

CREATE TABLE disciplinas (
	id_disciplina SERIAL PRIMARY KEY,
	nome_disciplina varchar[20],
	obrigatorio boolean,
	professor varchar[20]
);

-- Fez-se necessário aumentar o tamanho do nome do curso
ALTER TABLE disciplinas ALTER COLUMN nome_disciplina TYPE varchar(35);
ALTER TABLE disciplinas ALTER COLUMN professor TYPE varchar(20);

-- Relaciona alunos com seus respectivos cursos
CREATE TABLE alunos_cursos (
	registro_aluno varchar(14) PRIMARY KEY,
	id_curso int REFERENCES cursos,
	id_aluno int REFERENCES alunos
);

-- O status "formado" faz mais sentido estar nessa tabela, pois um aluno pode estar formado em vários cursos
-- "formado" faz mais sentido ser uma string "status", deixando de ser boolean, pois o aluno pode estar:
		-- formado, ativo e desistente
ALTER TABLE alunos_cursos ADD COLUMN status varchar(10);

-- Relaciona os cursos com suas disciplinas, sejam elas obrigatórias ou não
CREATE TABLE cursos_disciplinas (
	id_aula SERIAL PRIMARY KEY,
	id_curso int REFERENCES cursos,
	id_disciplina int REFERENCES disciplinas
);

-- Relaciona os alunos com as disciplinas que eles escolheram para compor sua grade em cada "semestre", por exemplo
CREATE TABLE alunos_disciplinas (
	id_disciplina_aluno SERIAL PRIMARY KEY,
	id_aluno int REFERENCES alunos,
	id_disciplina int REFERENCES disciplinas
);

-------------------------------------
----------- COMANDOS DML ------------
------- POVOANDO AS TABELAS ---------
-------------------------------------

INSERT INTO alunos (nome_aluno, cpf, idade, formado) VALUES
('João da Silva', '123.456.789-00', 20, false),
('Maria Souza', '987.654.321-00', 22, true),
('Pedro Oliveira', '111.222.333-44', 19, false),
('Ana Santos', '555.666.777-88', 21, true),
('Carlos Almeida', '222.333.444-55', 18, false),
('Jéssica Ferreira', '666.777.888-99', 23, true),
('Paulo Cardoso', '333.444.555-66', 20, false),
('Roberta Costa', '777.888.999-00', 20, true),
('Felipe Lima', '444.555.666-77', 19, false),
('Cainã Antunes', '321.654.987-00', 25, true);

INSERT INTO endereco (id_aluno, logradouro, numero, cidade, uf) VALUES
(1, 'Rua das Flores', 123, 'São Paulo', 'SP'),
(2, 'Avenida Paulista', 987, 'São Paulo', 'SP'),
(3, 'Rua da Paz', 456, 'Rio de Janeiro', 'RJ'),
(4, 'Avenida Atlântica', 789, 'Rio de Janeiro', 'RJ'),
(5, 'Rua dos Pinheiros', 321, 'Belo Horizonte', 'MG'),
(6, 'Avenida Afonso Pena', 654, 'Belo Horizonte', 'MG'),
(7, 'Rua das Acácias', 567, 'Salvador', 'BA'),
(8, 'Aveinda Afonso Vergueiro', 890, 'Salvador', 'BA'),
(9, 'Rua dos Cravos', 234, 'Recife', 'PE'),
(10, 'Avenida Boa Viagem', 765, 'Recife', 'PE');

INSERT INTO contato (id_aluno, contato) VALUES
(1, 'joao.silva@email.com'),
(2, '(11) 91234-5678'),
(2, 'maria_souza@email.com'),
(3, '(11) 99876-5432'),
(3, 'ricardo.mendes@email.com'),
(4, '(11) 98765-4321'),
(4, 'pedro.pereira@email.com'),
(5, 'ana.rocha@email.com'),
(6, '(11) 99665-1234'),
(7, 'lucas.santos@email.com'),
(8, '(11) 97654-3210'),
(9, 'carla.almeida@email.com'),
(9, '(11) 94567-8901'),
(10, 'fernanda.oliveira@email.com'),
(10, '(11) 92345-6789');

INSERT INTO departamentos (nome_departamento, coordenador) VALUES
('Saúde', 'Rafaela Santos'),
('Tecnologia', 'Felipe Oliveira'),
('Engenharia', 'Ana Carolina Lima'),
('Humanas', 'Thiago Silva');

INSERT INTO cursos (id_departamento, nome_curso, formacao) VALUES
(3, 'Engenharia Civil', 'Graduação'),
(2, 'Técnico em Informática', 'Técnico'),
(4, 'Mestrado em Economia', 'Mestrado'),
(4, 'Administração de Empresas', 'Graduação'),
(1, 'Técnico em Enfermagem', 'Técnico'),
(4, 'Direito Penal Avançado', 'Pós-graduação'),
(1, 'Medicina Veterinária', 'Graduação'),
(2, 'Técnico em Mecânica Industrial', 'Técnico'),
(2, 'Mestrado em Ciência da Computação', 'Mestrado'),
(4, 'MBA em Gestão de Projetos', 'Pós-graduação');

INSERT INTO disciplinas (nome_disciplina, obrigatorio, professor) VALUES
('Cálculo I', true, 'Hudson'),
('Introdução à Programação', true, 'Cainã Antunes'),
('História da Arte', false, 'Dilze Duarte'),
('Química Orgânica', true, 'Joyci Pessoa'),
('Literatura Brasileira', false, 'Thiago Silva'),
('Álgebra Linear', true, 'Daniel Jelin'),
('Psicologia Organizacional', false, 'José Francisco'),
('Economia Internacional', true, 'Keile Dummont'),
('Programação Avançada', true, 'André Souza'),
('Ética Profissional', false, 'Gabriel Silva'),
('Física Experimental', true, 'Tiago Toledo'),
('Marketing Digital', false, 'André Rusconi'),
('Anatomia Humana', true, 'Jonas Dimas'),
('Redes de Computadores', true, 'Geraldo Sacconi'),
('Geopolítica Mundial', false, 'Júlia Souza');

INSERT INTO alunos_cursos (registro_aluno, id_aluno, id_curso, status) VALUES
('000056789423-1',1,1,'ativo'), ('000010987652-1',1,2,'formado'),
('000097854324-1',2,2,'ativo'), ('000078563215-1',2,8,'ativo'),
('000067891011-1',3,3,'desistente'), ('000045319872-1',3,7,'desistente'),
('000089562347-1',4,3,'formado'),
('000022154698-1',5,4,'ativo'), ('000011225566-1',5,10,'ativo'),
('000077654452-1',6,2,'ativo'), ('000098765432-1',6,8,'ativo'),
('000012345678-1',7,2,'formado'),
('000055555555-1',8,5,'ativo'),
('000099999999-1',9,5,'formado'), ('000077777777-1',9,9,'desistente'),
('000088888888-1',10,6,'ativo'), ('000044444444-1',10,2,'ativo'), ('000022222222-1',10,7,'formado');

INSERT INTO cursos_disciplinas (id_curso, id_disciplina) VALUES
(1,1), (1,6), (1,3), (1,7), (1,10),
(2,2), (2,9), (2,14),
(3,15), (3,8),
(4,7), (4,10),
(5,13), (5,7),
(6,5), (6,8), (6,15),
(7,16),
(8,6), (8,10),
(9,2), (9,9), (9,15),
(10,7), (10,10);

INSERT INTO alunos_disciplinas (id_aluno, id_disciplina) VALUES
(1,1), (1,2), (1,6),
(2,2), (2,10),
(3,8), (3,15),
(4,8), (4,15),
(5,7), (5,10),
(6,2), (6,10),
(7,2), (7,9),
(8,13), (8,7),
(9,9), (9,13),
(10,2), (10,10), (10,5);

---------------------------------------
------------ COMANDOS DQL -------------
-- EXTRAINDO INFORMAÇÕES DAS TABELAS --
---------------------------------------

-- 1- Dado o RA ou o Nome do Aluno, buscar no BD todos os demais dados do aluno.
-- SELECIONANDO INDIVIDUALMENTE NOME OU RA --
SELECT nome_aluno, cpf, idade, formado, logradouro, numero, cidade, uf, contato
FROM alunos INNER JOIN endereco USING (id_aluno) 
INNER JOIN contato USING (id_aluno) WHERE nome_aluno = 'João da Silva' OR registro_aluno = '000010987652-1';

SELECT nome_aluno, cpf, idade, formado, logradouro, numero, cidade, uf, contato
FROM alunos_cursos INNER JOIN alunos USING (id_aluno) INNER JOIN endereco USING (id_aluno)
INNER JOIN contato USING (id_aluno) WHERE registro_aluno = '000010987652-1';

-- SELECIONANDO PELOS DOIS (um OU outro) --
SELECT DISTINCT nome_aluno, cpf, idade, formado, logradouro, numero, cidade, uf, contato
FROM alunos_cursos INNER JOIN alunos USING (id_aluno) INNER JOIN endereco USING (id_aluno) 
INNER JOIN contato USING (id_aluno) WHERE nome_aluno = 'João da Silva' OR registro_aluno = '000010987652-1';

---------------------------------------------------------------------------------------------------------------------------

-- 2 - Dado o nome de um departamento, exibir o nome de todos os cursos associados a ele.
SELECT nome_curso FROM cursos INNER JOIN departamentos USING (id_departamento) WHERE nome_departamento = 'Humanas'

---------------------------------------------------------------------------------------------------------------------------

-- 3 - Dado o nome de uma disciplina, exibir a qual ou quais cursos ela pertence.
SELECT nome_curso FROM cursos INNER JOIN cursos_disciplinas USING (id_curso)
INNER JOIN disciplinas USING (id_disciplina) WHERE nome_disciplina = 'Introdução à Programação';

---------------------------------------------------------------------------------------------------------------------------

-- 4 - Dado o CPF de um aluno, exibir quais disciplinas ele está cursando.
SELECT nome_disciplina FROM disciplinas INNER JOIN alunos_disciplinas USING (id_disciplina) 
INNER JOIN alunos USING (id_aluno) WHERE cpf = '987.654.321-00';

---------------------------------------------------------------------------------------------------------------------------

-- 5 - Filtrar todos os alunos matriculados em um determinado curso.
SELECT nome_aluno FROM alunos INNER JOIN alunos_cursos USING (id_aluno)
INNER JOIN cursos USING (id_curso) WHERE nome_curso = 'Técnico em Informática';

---------------------------------------------------------------------------------------------------------------------------

-- 6 - Filtrar todos os alunos matriculados em determinada disciplina.
SELECT nome_aluno FROM alunos INNER JOIN alunos_disciplinas USING (id_aluno)
INNER JOIN disciplinas USING (id_disciplina) WHERE nome_disciplina = 'Introdução à Programação';

---------------------------------------------------------------------------------------------------------------------------

-- 7 - Filtrar alunos formados.
SELECT nome_aluno, registro_aluno FROM alunos INNER JOIN alunos_cursos USING(id_aluno) WHERE status = 'formado';

---------------------------------------------------------------------------------------------------------------------------

-- 8 - Filtrar alunos ativos.
SELECT nome_aluno, registro_aluno FROM alunos INNER JOIN alunos_cursos USING(id_aluno) WHERE status = 'ativo';

---------------------------------------------------------------------------------------------------------------------------

-- 9 - Apresentar a quantidade de alunos ativos por curso.

-- "GROUP BY" agrupa as contagens pelos seus respectivos cursos (nome_curso)
SELECT COUNT(*), nome_curso FROM alunos_cursos INNER JOIN alunos USING (id_aluno)
INNER JOIN cursos USING (id_curso) WHERE formado = false GROUP BY nome_curso;

---------------------------------------------------------------------------------------------------------------------------

-- 10 - Apresentar a quantidade de alunos ativos por disciplina.
SELECT COUNT(*), nome_disciplina FROM alunos_disciplinas INNER JOIN alunos USING(id_aluno) 
INNER JOIN disciplinas USING (id_disciplina) WHERE formado = false GROUP BY nome_disciplina;