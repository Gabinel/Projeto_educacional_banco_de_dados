
# PROJETO - UNIVERSIDADE

O projeto simula o funcionamento de um __banco de dados__ de uma universidade.

### 

Estão presentes no sistema as seguintes entidades:

| Principal | Complemento    |
| --------- | -------------- |
| Aluno | Endereço, Contato  |
| Curso | Departamento       |
| Disciplina | N/A           |

Endereço e Contato são duas tabelas separadas que foram criadas com o fito de normalizar o sistema

Cada curso está inserido em um determinado departamento da faculdade

Além dessas entidades, existem também as Entidades de Relacionamento (que relacionam as demais entidades entre si):

| Entidade-Relacionamento | Entidades relacionadas |
| ---- | ---- |
| Alunos_Cursos | Aluno, Curso |
| Alunos_Disciplinas | Aluno, Disciplina |
| Cursos_Disciplinas | Curso, Disciplina |

### Ferramentas utilizadas:
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-000?style=for-the-badge&logo=postgresql)
