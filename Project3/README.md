Bake-off 3 - Escrita em Smartwatches

Disponível: 20 Abril 2020

Sessão de bake-off: aula de laboratório da semana de 18 de Maio

Submissão via Discord: exclusivamente no dia 22 de Maio, até às 23h59

Desafio: diminuir o tempo de escrita numa interface para smartwatches

Resultado esperado: interface que minimize o tempo de escrita de texto numa área com 40mmx40mm 

Avaliação: 0-20 valores; 10 valores qualidade do processo de desenho, 10 valores dependentes do número médio de palavras por minuto

FAQ: Frequently Asked Questions

Desafio

O objetivo deste bake-off é desenhar e implementar uma técnica de escrita de texto em smartwatches. É disponibilizado o código-fonte em Processing (Figura 1) que: (1) mostra um teclado navegacional com duas direções e uma caixa de texto, (2) indica qual a frase a transcrever (i.e. frase objetivo); (3) quantifica o desempenho do utilizador imprimindo as palavras por minuto e taxa de erros. Para vencer este bake-off têm de alterar o código fonte fornecido para que os utilizadores escrevam texto o mais rapidamente possível - atenção, taxa de erros acima de 5% serão penalizadas. 

Figura 1 - Exemplo do teclado disponibilizado no código-fonte.

Os caracteres disponíveis incluem apenas letras de 'a' - 'z', espaço ('_') e apagar (' ´ '). Não são necessários outros caracteres para transcrever as frases objetivo (maísculas, símbolos, números, acentos, etc.). Ao desenvolverem a vossa solução, não podem aceder à frase objetivo. Têm apenas acesso aos caracteres que já foram escritos pelo utilizador.

Têm de calcular e imprimir uma métrica adicional: Caracteres por Segundo.

Funcionamento

O bake-off é um desafio de design em aberto. É crucial que iniciem um processo iterativo de geração e teste de ideias desde o primeiro dia. A vossa solução tem de obedecer às seguintes regras:

    Não podem alterar o tamanho do ecrã (40mm x 40mm) ou teclado (40mm x 30mm);

    Não podem alterar o código que simula a ocultação e seleção com um dedo (a área de toque do dedo simula o 'fat finger problem' e a incerteza da seleção);

    Não podem aceder à frase objetivo ou ao corpus de frases durante a escrita. Ou seja, a solução não sabe à priori o que o utilizador quer escrever, mas pode tentar prever;

    Não podem usar mais nenhum botão para além do botão esquerdo do rato.


As mudanças ao código fonte estão restringidas à área do teclado ecrã (40mm x 3040mm). Apenas os toques dentro da área do teclado (40mm x 30mm) são válidos.

É esperado que discutam as vossas ideias com o docente do laboratório para garantirem que não quebram nenhuma das regras.

Recursos e Ferramentas

    Processing 3.0: www.processing.org

    Código fonte da aplicação

    Frequências de letras e palavras: http://norvig.com/ngrams/


Competição

O bake-off termina com uma competição que será realizada na aula de laboratório da semana de 18 de Maio. A sessão de bake-off será realizada online. A interface será usada por todos os vossos colegas de turno. 

Todos os participantes têm de usar um computador com rato  por uma questão de consistência e justiça dos resultados. As métricas de desempenho são calculadas automaticamente pela aplicação e guardadas em formato de imagem. Os participantes serão responsáveis por reportar os seus resultados aos docentes.  Estes serão usados para criar o leaderboard (do turno e da cadeira). Na aula teórica serão anunciados os grupos vencedores.

Submissão

A submissão via Discord tem de ser feita exclusivamente no dia 22 de Maio, até às 23h59. Tem de conter os seguintes elementos:

    Link para Código-fonte da solução;

    Link para Vídeo descritivo do processo de desenho e solução final (com descrição verbal). A captação de vídeo com o telemóvel é suficiente, não é necessário um vídeo de alta qualidade. O docente quer avaliar a(s) ideia(s) e o seu desenvolvimento; as vossas competências cinematográficas não são relevantes. O vídeo deverá incluir:

    Ideias iniciais: quais foram e porquê? Descrição rápida ou demonstração de esboços é suficiente;

    Refinamento: como evoluíram as ideias através das várias rondas de refinamento? Foram desenvolvidos protótipos intermédios (em papel ou funcionais)? Como foram testados? Com quantos utilizadores? O que aprenderam? Que implicações teve no vosso protótipo? Etc.

    Solução final: demonstrem a solução final e expliquem todas as vossas opções de desenho.

    O vídeo deverá ter no máximo 3 minutos.


Para promover transparência na competição, a submissão é feita via Discord. Enviem uma mensagem para o vosso canal de laboratório no seguinte formato:

    Bake-off 3 Grupo <XX>: <link para vídeo>, <link para código fonte>

    Ex: Bake-off 3 Grupo 1: https://www.youtube.com/watch?v=DLzxrzFCyOs, https://tinyurl.com/yc4gluqg


Não é expectável que existam alterações à interface entre a sessão de bake-off e a submissão.

Avaliação

    10.0v, qualidade do processo de desenho. O docente está à espera de um vídeo que ilustre um processo estruturado de ideação-prototipagem-iteração e demonstração da solução final. Devem descrever os protótipos usados em cada iteração, como foram sendo refinados e justificar todas as opções de desenho. Devem também demonstrar o protótipo final.

    10.0v, velocidade de escrita. Esta componente será calculada através das palavras por minuto dos resultados dos testes com utilizadores durante o bake-off. A métrica é calculada automaticamente pelo código-fonte fornecido com respetiva penalização por taxas de erro acima de 5%. O número médio de palavras por minuto (com penalização) será mapeada numa nota:

        0.0v: <= 3.0 palavra por minuto (PPM)

        2.0v: ]3.0 ; 5.25[

        4.0v: [5.25 ; 7.5[

        6.0v: [7.5 ; 9.75[ 

        8.0v: [9.75 ; 12.0[

        10.0v: >= 12.0 PPM


    1.0v BÓNUS, utilizador mais rápido. O utilizador mais rápido de cada turno de laboratório receberá uma bonificação de 1.0v na nota final do bake-off.

    Não calcular e imprimir a métrica de Caracteres por Segundo terá uma penalização de 2v.