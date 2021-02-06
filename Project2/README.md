Bake-off 2 - Seleção de Alvos e Fatores Humanos


Disponível: 23 Março 2020

Sessão de bake-off: aula de laboratório da semana de 20 de Abril

Submissão via Twitter: exclusivamente no dia 24 de Abril, até às 23h59

Desafio: diminuir o tempo de seleção de alvos numa interface abstrata

Resultado esperado: interface que minimize o tempo de seleção de alvos circulares numa grelha de 4 x 4 

Avaliação: 0-20 valores; 10 valores para qualidade do processo de desenho, 10 valores dependentes do tempo de seleção médio dos alvos


Desafio

O objetivo deste bake-off é diminuir o tempo de seleção de alvos numa interface abstrata. É disponibilizado o código-fonte em Processing que: (1) mostra uma grelha de 4x4 alvos (Figura 1); (2) indica qual o alvo a selecionar; (3) quantifica o desempenho do utilizador imprimindo o tempo de seleção (em ms) e taxa de sucesso (0% - 100%). Para vencer este bake-off têm de alterar o código fonte fornecido para que os utilizadores selecionem os alvos o mais rapidamente possível - atenção, soluções com taxas de sucesso abaixo de 95% serão penalizadas!


Figura 1 - Distribuição dos 16 alvos e um deles realçado com o contorno a branco.


Ao desenvolverem a vossa solução, podem aceder à lista de alvos a selecionar. No entanto, só podem aceder ao alvo atual (i), próximo alvo (i+1) e alvo anterior (i-1).

Têm de calcular e imprimir uma métrica adicional: Fitts Index of Performance (Índice de Dificuldade). Devem usar a fórmula proposta por Mackenzie,  log2 (distância-ao-alvo / largura-do-alvo + 1) - ver aula teórica 8 e secção 2.1.4 do Livro - O Movimento. Devem imprimir um valor para cada seleção bem sucedida (Figura 2).


Figura 2 - Exemplo do ecrã de resultados com o Index of Performance para cada alvo.


Funcionamento

O bake-off é um desafio de design em aberto. É crucial que iniciem um processo iterativo de geração e teste de ideias desde o primeiro dia. A vossa solução tem de obedecer às seguintes regras:

    Não podem colocar alvos invisíveis ou impossíveis de selecionar;

    Não podem alterar a hitbox dos alvos; dependendo do alvo a selecionar; isto é, alterações às hitboxs terão de ter o mesmo comportamento para todos os alvos;

    Não podem fazer alterações ao movimento do cursor que seja dependente do alvo a selecionar; isto é, alterações ao movimento do cursor terão de ter o mesmo comportamento para todos os alvos;

    Não podem usar hardware adicional para além do rato;

    Não podem modificar o código que calcula as métricas de desempenho existentes;


É esperado que discutam as vossas ideias com o docente do laboratório para garantirem que não quebram nenhuma das regras.

Lembrem-se, o vosso objetivo de desenho é minimizar o tempo de seleção (ver aulas de Fatores Humanos, Capítulo 2 - Nós, os Humanos - e secção 10.3 - Avaliação Preditiva).


Recursos e Ferramentas

    Processing 3.0: www.processing.org

    Código fonte da aplicação

    Tutoriais: https://processing.org/tutorials/


Competição

O bake-off termina com uma competição que será realizada na aula de laboratório da semana de 20 de Abril.

A sessão de bake-off será realizada online (até confirmação em contrário). A interface será usada por todos os vossos colegas de turno.

Todos os participantes têm de usar um computador com rato  por uma questão de consistência e justiça dos resultados. Os tempos de execução são calculados automaticamente pela aplicação e guardados em formato de imagem. Os participantes serão responsáveis por reportar os seus resultados aos docentes.  Estes serão usados para criar o leaderboard (do turno e da cadeira). Na aula teórica da semana seguinte será anunciado o top 3 da cadeira.


Submissão

A submissão via Twitter tem de ser feita exclusivamente no dia 24 de Abril, até às 23h59. Tem de conter os seguintes elementos:

    Link para Código-fonte da solução;

    Link para Vídeo descritivo do processo de desenho e solução final (com descrição verbal). A captação de vídeo com o telemóvel é suficiente, não é necessário um vídeo de alta qualidade. O docente quer avaliar a(s) ideia(s) e o seu desenvolvimento; as vossas competências cinematográficas não são relevantes. O vídeo deverá incluir:

    Ideias iniciais: quais foram? Descrição rápida ou demonstração de esboços/protótipos é suficiente;

    Refinamento: como evoluíram as ideias através das várias rondas de refinamento? Foram desenvolvidos protótipos intermédios? Como foram testados? Com quantos utilizadores? O que aprenderam?  Etc.

    Solução final: demonstrem a solução final e expliquem todas as vossas opções de desenho;

    O vídeo deverá ter no máximo 3 minutos.


Para promover transparência na competição, a submissão é feita via Twitter no seguinte formato:

LEIC:

    Bake-off 2 @ipm_ist #<turno, ver aqui: LEIC-T> Grupo <grupo>: <link para vídeo>, <link para código-fonte>

    Ex: Bake-off 2 @ipm_ist #IPM171113264L02 Grupo 1: https://www.youtube.com/watch?v=DLzxrzFCyOs, https://bit.ly/2xH0Hch


Não é expectável que existam alterações à interface entre a sessão de bake-off e a submissão via Twitter.


Avaliação

    10.0v, qualidade do processo de desenho. O docente está à espera de um vídeo que ilustre um processo estruturado de ideação-prototipagem-iteração e demonstração da solução final. Devem mostrar/descrever os protótipos usados em cada iteração e como foram sendo refinados. Devem também demonstrar o protótipo final explicando as vossas opções de desenho.

    10.0v, tempo médio de seleção de alvos. Esta componente será calculada através dos resultados dos testes com utilizadores durante o bake-off. A métrica é calculada automaticamente pelo código-fonte fornecido com respetiva penalização de seleções falhadas. O tempo média de seleção (com penalização) será mapeado numa nota: 

        0.0v: >= 0.835

        2.0v: ]0.767 ; 0.835[

        4.0v: ]0.699 ; 0.767]

        6.0v: ]0.631 ; 0.699]

        8.0v: ]0.563 ; 0.631]

        10.0v: <= 0.563

    1.0v BÓNUS, utilizador mais rápido. O utilizador mais rápido de cada turno de laboratório receberá uma bonificação de 1.0v na nota final do bake-off.

    Não calcular e imprimir o Fitts Performance Index terá uma penalização de 2v.