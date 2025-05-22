#import "resources/report.typ" as report

#show: report.styling.with(
    hasFooter: false
)

#report.index()

#import "@preview/diagraph:0.3.1" as dgraph

= Objetivos
#v(10pt)
Este relatório tem como objetivo analisar e compreender o funcionamento do Internet Protocol(IP), nas suas principais vertentes, sendo elas a estrutura e formato dos datagramas ou pacotes IP, o encaminhamento e endereçamento de pacotes IP e a fragmentação de pacotes. 

Além disso, este trabalho foi realizado através da execução de experimentos práticos utilizando ferramentas como o traceroute e Wireshark, que possibilitaram a captura e análise do tráfego de rede. 
#pagebreak()

= 1º Parte

== Exercício 1
#v(10pt)
Prepare uma topologia CORE para verificar o comportamento do traceroute. Na topologia deve existir: um host (pc) cliente designado Lost, cujo router de acesso é RA1; o router RA1 está simultaneamente ligado a dois routers no core da rede RC1 e RC2; estes estão conectados a um router de acesso RA2, que por sua vez, se liga a um host (servidor) designado Found. Ajuste o nome dos equipamentos atribuídos por defeito para o enunciado. Apenas nas ligações (links) da rede de core, estabeleça um tempo de propagação de 15ms. Após ativar a topologia, note que pode não existir conectividade IP imediata entre Lost e Found até que o anúncio de rotas entre routers estabilize. 
#figure(
  image("images/topologiav2.png", width: 150%),
  caption: [Topologia core(exercício 1)],
)

#pagebreak()
*a) Ative o Wireshark no host Lost. Numa shell de Lost execute o comando traceroute -I para o endereço IP do Found. Registe e analise o tráfego ICMP enviado pelo sistema Lost e o tráfego ICMP recebido como resposta. Explique os resultados obtidos tendo em conta o princípio de funcionamento do traceroute.*
#figure(
  image("images/trafegov2.png", width: 125%),
  caption: [Output Wireshark(exercico 1.a) ],
)

#figure(
  image("images/traceroutev2.png", width: 125%),
  caption: [Output traceroute(exercico 1.a) ],
)

O traceroute é uma ferramenta de diagnóstico de rede que utiliza pacotes ICMP 
com TTL (Time To Live) cada vez maior para determinar a rota que os pacotes estão 
a seguir de um dispositivo de origem para um determinado destino. 
Como podemos observar na figura 2, os pacotes vão sendo enviados com TTL cada 
vez maior do endereço de ip do host Lost e as respostas a esses pacotes são 
registadas. Quando o TTL é igual a 4 uma resposta é obtida como podemos, mais uma vez, ver na 
figura 2. 

#v(10pt)
*b) Qual deve ser o valor inicial mínimo do campo TTL para alcançar o servidor Found? Esboce um esquema com o valor do campo TTL à chegada a cada um dos routers percorridos até ao servidor Found. Verifique na prática que a sua resposta está correta. *

O valor inicial mínimo do campo TTL para alcançar o servidor Found deve ser 4 uma vez que é o número mínimo de ligações que o pacote tem de passar entre o host Lost e o servidor Found. Podemos ver na figura 2 que quando o TTL é igual a 4 o pacote chega ao destino sem retornar erros.
#v(10pt)
Host(PC) Lost --> TTL 4

Router RA1 --> TTL 3

Router RC1 ou RC2 --> TTL2

Router RA2 --> TTL 1

Host(Servidor) Found --> Chegou ao destino

#v(10pt)
*c) Calcule o valor médio do tempo de ida-e-volta (RTT - Round-Trip Time) obtido no acesso ao servidor. Por modo a obter uma média mais confiável, poderá alterar o número pacotes de prova com a opção -q.* 

#figure(
  image("images/1cv2.png", width: 125%),
  caption: [Output traceroute(exercico 1.c) ],
)

(60.778+64.301+64.256+64.241+64.229)/5=63.561 ms.

Como podemos ver pela figura 4, o RTT médio é 63.561 ms. 

#v(10pt)
*d) O valor médio do atraso num sentido (One-Way Delay) poderia ser calculado com precisão dividindo o RTT por dois? O que torna difícil o cálculo desta métrica numa rede real? *

O valor médio do atraso num sentido não pode ser calculado ao dividir o RTT por 2, pois as rotas de ida e de volta podem ser diferentes, os dispositivos de rede como routers introduzem latência o que afeta o cálculo do atraso num sentido. Numa rede real o cálculo torna-se ainda mais difícil devido ao congestionamento da rede que varia com o tempo, routing dinâmico e o jitter. 
#pagebreak()#v(10pt)
== Exercício 2

Usando o wireshark capture o tráfego gerado pelo traceroute sem especificar o tamanho do pacote, i.e., quando é usado o tamanho do pacote de prova por defeito. Utilize como máquina destino o host marco.uminho.pt. Pare a captura. Com base no tráfego capturado, identifique os pedidos ICMP Echo Request e o conjunto de mensagens devolvidas como resposta.  

Selecione a primeira mensagem ICMP capturada e centre a análise no nível protocolar IP e, em particular, do cabeçalho IP (expanda o tab correspondente na janela de detalhe do wireshark). 

#v(10pt)
*a) Qual é o endereço IP da interface ativa do seu computador? *
#figure(
  image("images/ipa.png", width: 120%),
  caption: [Output do comando ’ip a’ ],
)
Como podemos ver na figura 5, ao usar o comando ‘ip a’ no terminal do linux somos capazes de obter o endereço IP da interface ativa do computador que estamos a utilizar, onde, neste caso, conseguimos ver que, neste momento, o enderelo IP da máquina usada como exemplo é 172.26.7.91. 

#pagebreak()
*b) Qual é o valor do campo protocol? O que permite identificar?*
#figure(
  image("images/ex2.jpg", width: 120%),
  caption: [Análise da primeira mensagem ICMP capturada],
)

Como podemos ver na figura 6, o valor do campo protocol é ICMP (1) e ele permite-nos identificar o protocolo usado no envio da mensagem. 

#v(10pt)
*c) Quantos bytes tem o cabeçalho IPv4? Quantos bytes tem o campo de dados (payload) do datagrama? Como se calcula o tamanho do payload? *

Como podemos ver na figura 6, o tamanho do cabeçalho IPv4 é 20 bytes, enquanto que o tamanho total é 60 bytes, logo o tamanho do payload é 60-20 bytes, ou seja, 40 bytes. 

#v(10pt)
*d) O datagrama IP foi fragmentado? Justifique. *

O datagrama não foi fragmentado, pois como podemos ver na figura 6, o campo “Fragment Offset” é 0, e o campo “More fragments” tem valor 0 e está como “Not set”, o que nos leva a concluir que o pacote não foi fragmentado, pois no wireshark, em pacotes fragmentados, o campo “More fragments” é igual a 1 para todos os fragmentos exceto o último. 

#v(10pt)
*e) Analise a sequência de tráfego ICMP gerado a partir do endereço IP atribuído à interface da sua máquina. Para a sequência de mensagens ICMP enviadas pelo seu computador, indique que campos do cabeçalho IP variam de pacote para pacote. Justifique estas mudanças. *

#figure(
  image("images/trafego2.png", width: 125%),
  caption: [Output wireshark (exercicio 2)],
)

Os campos que variam de pacote para pacote são os campos “Identification”, “TTL” e o o “Header Checksum”. O campo “TTL” vai aumentando devido ao traceroute que envia pacotes ICMP com TTL cada vez maior, o campo “Identification” varia, pois cada pacote tem uma identificação única e o campo “Header Checksum”, representado por 16 bits, varia, pois ele é calculado como a soma complementar para 1 de todos os campos do cabeçalho, divididos em palavras de 16 bits, logo como de pacote para pacote, certos campos como o “TTL” e o “Identification” variam, o campo “Header Checksum” acaba também por variar. 

#v(10pt)
*f) Observa algum padrão nos valores do campo de Identificação do datagrama IP e TTL? *

Após analisar o tráfego ICMP fomos capazes de notar que a cada pacote recebido, o campo “Identification” incrementava de 1 em 1, enquanto que o campo “TTL” é incrementado a cada 3 pacotes enviados.

#v(10pt)
*g) Ordene o tráfego capturado por endereço destino e encontre a série de respostas ICMP TTL Exceeded enviadas ao seu computador. *

#figure(
  image("images/exceed.png", width: 150%),
  caption: [Respostas ICMP TTL Exceeded],
)

#v(10pt)
*i. Qual é o valor do campo TTL recebido no seu computador? Esse valor permanece constante para todas as mensagens de resposta ICMP TTL Exceeded recebidas no seu computador? Porquê? *

O valor do TTL das mensagens de resposta ICMP TTL Exceed, varia entre 255 e 253. Isso acontece devido a estas mensagens serem respostas a um traceroute. Na prática, o TTL destas mensagens é igual a 256 menos o TTL da mensagem a que estão a responder, o que significa que estas mensagens de resposta ICMP TTL Exceeded estão a responder a mensagens que originalmente teriam entre 1 e 3 de TTL e não foram capazes de chegar ao seu destino, uma vez que, assim como podemos ver na figura 7, apenas existe uma resposta quando o TTL é igual a 4 ou superior.

 #v(10pt)
*ii. Por que razão as mensagens de resposta ICMP TTL Exceeded são sempre enviadas na origem com um valor relativamente alto? *

Uma vez que o TTL da mensagem a que estão a responder não foi suficiente para chegar ao destino não é possível saber qual o TTL necessário entre a fonte e o destino. Assim, envia-se a resposta com um TTL bastante elevado para que tenhamos a certeza de que este chega ao seu destino. 

#v(10pt)
*h) A informação contida no cabeçalho ICMP poderia ser incluída no cabeçalho IPv4? Se sim, quais seriam as suas vantagens/desvantagens? *

Seria teoricamente possível incluir a informação do protocolo ICMP no cabeçalho IPv4. A única vantagem seria a simplificação do processamento. As desvantagens seriam o aumento do tamanho do cabeçalho, complexidade de implementação e menor flexibilidade. Assim considera-se que existem mais desvantagens que vantagens e por isso a inclusão da informação do cabeçalho ICMP no cabeçalho IPv4 seria prejudicial e por isso não deve ser feita. 

 
#v(10pt)
== Exercício 3
Pretende-se agora analisar a fragmentação de pacotes IP. Usando o wireshark, capture e observe o tráfego gerado depois do tamanho de pacote ter sido definido para (3800 + X) bytes, em que X é o número do grupo de trabalho (e.g., X=22 para o grupo PL22). De modo a poder visualizar os fragmentos, aceda a Edit -> Preferences -> Protocols e em IPv4 desative a opção “Reassemble fragmented IPv4 datagrams”. 
#figure(
  image("images/trafego3.png", width: 125%),
  caption: [Output wireshark(exercício 3)],
)

*a) Localize a primeira mensagem ICMP. Porque é que houve necessidade de fragmentar o pacote inicial? *

O pacote inicial foi fragmentado porque o seu tamanho é maior que o MTU (Maximum transmission unit), ou seja, o tamnho que queremos transmitir é de 3882 bytes que é demasiado grande para ser transmitido, visto que o limite máximo é 1500 bytes(MTU), por isso o pacote inicial teve de ser dividido de maneira que nenhum dos fragmentos resultantes exceda o MTU. 

#v(10pt)
*b) Imprima o primeiro fragmento do datagrama IP segmentado. Que informação no cabeçalho indica que o datagrama foi fragmentado? Que informação no cabeçalho IP indica que se trata do primeiro fragmento? Qual é o tamanho deste datagrama IP? *
#figure(
  image("images/1.png", width: 120%),
  caption: [Primeiro fragmento do diagrama IP segmentado],
)

A fragmentação é identificada por dois campos no cabeçalho IP. No campo Flags temos o campo “More fragments” com valor 1 e como “Set”, o que significa que o pacote ainda tem mais fragmentos a seguir e temos o “Fragment Offset” com valor 0, sendo 0 a posição do fragmento dentro do datagrama original, o que confirma que este se trata do primeiro fragmento. Por fim, na figura 10 também somos capazes de ver que o tamanho total deste datagrama IP é de 1500 bytes.

#v(10pt)
*c) Imprima o segundo fragmento do datagrama IP original. Que informação do cabeçalho IP indica que não se trata do 1º fragmento? Existem mais fragmentos? O que nos permite afirmar isso? *
#figure(
  image("images/2.png", width: 120%),
  caption: [Segundo fragmento do diagrama IP segmentado],
)
Como podemos ver na figura 11, o campo “Fragment Offset” tem valor igual a 1480, o que nos permite concluir que este não é o primeiro fragmento, além disso o campo “More fragments” tem valor 1 e está como “Set”, logo ainda existem mais fragmentos.

#v(10pt)
*d) Quantos fragmentos foram criados a partir do datagrama original? Como se detecta o último fragmento correspondente ao datagrama original? Estabeleça um filtro no Wireshark que permita listar apenas o último fragmento do primeiro datagrama IP segmentado.*
#figure(
  image("images/3.png", width: 120%),
  caption: [Terceiro fragmento do diagrama IP segmentado],
)

Como podemos ver na figura 12, o terceiro fragmento da primeira mensagem ICMP tem o campo “More fragments” com valor 0, o que nos permite concluir que este fragmento se trata do último.  

Se o datagrama tiver o campo “More fragments” com valor 0, mas tiver um “Fragment Offset” diferente de 0 este é o último datagrama fragmentado. O filtro no Wireshark que permite listar apenas o último fragmento do primeiro datagrama IP segmentado é *ip.flags.mf == 0 and ip.frag_offset != 0 and ip.id == 0x271f*. 
#figure(
  image("images/filtro.png", width: 150%),
  caption: [Utilização do filtro no wireshark],
)

#v(10pt)
*e) Indique, resumindo, os campos que mudam no cabeçalho IP entre os diferentes fragmentos, e explique a forma como essa informação permite reconstruir o datagrama original. *

Nos diferentes fragmentos de um datagrama IP os campos que mudam num cabeçalho IP são o “Total Length”, o “Header Checkseum”, os valores do campo “Flags” e o campo “Fragment Offset”. A reconstrução do datagrama original é possível porque cada fragmento contém informações suficientes para determinar sua posição relativa dentro do datagrama original. No destino são identificados todos os fragmentos pertencentes ao mesmo datagrama IP com base no valor do campo “Identification”, onde são ordenados com base no campo “Fragment Offset” até encontrar o fragmento com a flag “More fragments” igual a zero, que corresponde ao último fragmento. 

#v(10pt)
*f) Estime teoricamente o número de fragmentos gerados e o número de bytes transportados em cada um dos fragmentos. Apresente todos os cálculos efetuados, incluindo os campos do cabeçalho IP relevantes para cada um dos fragmentos. *

Como pretendemos enviar 3882 bytes, o pacote gera 3 fragmentos pois 3882/1480 é aproximadamente igual a 2.623, onde os dois primeiros fragmentos irão transportar 1480 bytes dos 3882 mais 20 bytes do Cabeçalho IPv4 e o último fragmento irá transportar 3882-2960=922 bytes mais os restantes 20 bytes. Através das figuras 10, 11 e 12, somos capazes de ver a partir do campo “Fragment Offset” quantos bytes dos 3882 foram transportados por cada fragmento.

Como podemos ver na figura 9, onde é apresentado uma parte do output do wireshark usado e analisado no exercício 3, o wireshark, assim como estimamos, gera 3 fragmentos por pacote.

*g) Por que razão apenas o primeiro fragmento de cada pacote é identificado pelo Wireshark como sendo um pacote ICMP? Justifique a sua resposta com base no conceito de Fragmentação apresentado nas aulas teóricas. *

Quando um pacote é fragmentado em vários fragmentos menores para serem transmitidos através de uma rede que não suporta o tamanho total do pacote, apenas o primeiro fragmento retém o cabeçalho original do protocolo de transporte (neste caso o protocolo ICMP). Os fragmentos seguintes têm apenas informações sobre a fragmentação e não tem cabeçalhos completos do protocolo transporte. 

#v(10pt)
*h) Com que valor é o tamanho do datagrama comparado a fim de se determinar se este deve ser fragmentado? Quais seriam os efeitos na rede ao aumentar/diminuir este valor? *

Para se determinar se um certo datagrama deve ser fragmentado, deve-se comparar o tamanho deste com o valor MTU (Maximum Transmission Unit) da interface de rede. O MTU representa o tamanho máximo do pacote que pode ser transmitido em uma interface de rede específica sem fragmentação. Aumentar o MTU iria diminuir a quantidade de fragmentação necessária para a transmissão de pacotes nessa rede e a diminuição vice-versa. 

#v(10pt)
*i) Sabendo que no comando ping a opção “-f” (Windows), “-M do” (Linux) ou “–D” (Mac) ativa a flag “Don’t Fragment” (DF) no cabeçalho do IPv4, usando ping 'opção DF' 'opção pkt_size' SIZE marco.uminho.pt, (opção pkt_size = –l (Windows) ou –s (Linux, Mac), determine o valor máximo de SIZE sem que ocorra fragmentação do pacote? Justifique o valor obtido. *

#figure(
  image("images/wireshark3.png", width: 150%),
  caption: [Output do comando 'ping -M do -s 1472 marco.uminho.pt' no wireshark],
)

#figure(
  image("images/terminal3.png", width: 125%),
  caption: [Outputs do comando ping com fiferentes valores de SIZE],
)


O valor máximo de SIZE foi de 1472 pois o MTU é igual a 1500, o cabeçalho IPv4 tem 20 bytes de tamanho e o cabeçalho ICMP tem tamanho igual a 8 bytes. Assim, 1500 – (20 + 8) = 1472.

Além disso, como podemos ver na figura 15, ao usar o comando ping com um SIZE maior que 1472(1473 no exemplo usado), retorna erro, pois o tamanho total do pacote ultrapassa o MTU, que é 1500, mas também podemos ver que o mesmo não acontece com SIZE igual 1472, onde também na figura 15, somos capazes de ver que os pacotes são enviados. Assim, provamos que 1472 é o valor máximo de SIZE que se pode usar sem que ocorra fragmentação de pacote.

#pagebreak()
= 2º Parte

== Exercício 1
Com os avanços da Inteligência Artificial, D. Afonso Henriques termina todas as suas tarefas mais cedo e vê-se com algum tempo livre. Decide então fazer remodelações no reino:
#v(10pt)

*a) De modo a garantir uma posição estrategicamente mais vantajosa e ter casa de férias para relaxar entre batalhas,ordena a construção de um segundo Castelo, em Braga. Não tendo qualquer queixa do serviço prestado, recorre aos serviços do ISP ReiDaNet, que já utiliza no condado, para ter acesso à rede no segundo Castelo. O ISP atribuiu-lhe o endereço de rede IP 172.68.XX.192/26 em que XX corresponde ao seu número de grupo (PLXX).*

*Defina um esquema de endereçamento que permita o estabelecimento de pelo menos 6 redes e que garanta que cada uma destas possa ter 5 ou mais hosts. Assuma que todos os endereços de sub-redes são utilizáveis.*

Como fazemos parte do grupo 82, significa que nos foi atribuída a rede 172.68.82.192/26, onde como estamos a utilizar uma máscara de 26 bits, significa que temos um espaço de endereçamento de 2⁶=64 endereços, onde 62 são utilizáveis devido a termos 2 endereços de broadcast.

Como na rede que nos foi atribuída originalmente tínhamos uma máscara de 26 bits (/26), significa que temos 6 bits que podemos manipular (32-26=6), onde desses 6, podemos usar 3 bits para criar até 8 sub-redes com máscaras de 29 bits, o que nos deixa com 3 bits livres para manipular em cada sub-rede, o que significa que cada sub-rede teria 2³=8 endereços, onde 6 seriam utilizáveis, o que atende aos nossos requisitos de ter pelo menos 6 redes e que cada uma destas tenha 5 ou mais hosts.

#v(10pt)
Rede atribuída: 172.68.82.192/26

#v(10pt)
Exemplos de 6 sub-redes com 6 endereços/hosts cada:

#v(10pt)
172.68.82.192/29 → Hosts: 193 a 198

172.68.82.200/29 → Hosts: 201 a 206 

172.68.82.208/29 → Hosts: 209 a 214 

172.68.82.216/29 → Hosts: 217 a 222 

172.68.82.224/29 → Hosts: 225 a 230  

172.68.82.248/29 → Hosts: 249 a 254

#v(10pt)
*b) Ligue um novo host Castelo2 diretamente ao router ReiDaNet. Associe-lhe um endereço, à sua escolha, pertencente a uma sub-rede disponível das criadas na alínea anterior (garanta que a interface do router ReiDaNet utiliza o primeiro endereço válido da sub-rede escolhida). Verifique que tem conectividade com os dispositivos do Condado Portucalense.*

#figure(
  image("images2/topologia condado.png", width: 125%),
  caption: [Topologia com o Castelo2],
)

#figure(
  image("images2/conetividade.png", width: 125%),
  caption: [Prova da conetividade entre o Castelo e Castelo2],
)

Como podemos ver na figura 16, adicionamos um novo host Castelo2 diretamente ao router ReiDaNet dando-lhe um endereço da sub-rede 172.68.82.192/29, nomeadamente o segundo utilizável, enquanto que na interface do router ReiDaNet utilizámos o primeiro endereço válido da sub-rede que escolhemos.

Por fim, na figura 17 somos capazes de ver que existe conetividade entre os hosts Castelo e Castelo2, pois ao utilizar o comando ping para enviar pacotes do host Castelo2 para o endereço do host Castelo, os pacotes foram recebidos, o que nos permite concluir que o host Castelo2 tem conetividade com os dispositivos do Condado Portucalense.

#v(10pt)
*c) Não estando satisfeito com a decoração deste novo Castelo, opta por eliminar a sua rota default. Adicione as rotas necessárias para que o Castelo2 continue a ter acesso ao Condado Portucalense e à rede Institucional. Mostre que a conectividade é restabelecida, assim como a tabela de encaminhamento resultante. Explicite ainda a utilidade de uma rota default.*

#figure(
  image("images2/rotas.png", width: 125%),
  caption: [Remoção da rota default e adição de novas rotas],
)

#figure(
  image("images2/newtabela.png", width: 125%),
  caption: [Tabela de encaminhamento resultante],
)

#figure(
  image("images2/condado.png", width: 125%),
  caption: [Prova de conetividade com o Condado Portucalense],
)

#figure(
  image("images2/institucional.png", width: 125%),
  caption: [Prova de conetividade com a Rede Institucional ],
)



Como podemos ver nas figuras 20 e 21, existe conetividade entre o host Castelo2 e o Condado Portucalense e a rede Institucional, uma vez que os pacotes enviados do host Castelo2, com o comando ping, para certos endereços das respetivas zonas onde queremos provar a existência de conetividade, como os endereços dos hosts UMinho, DI, Bombeiros e Castelo, assim como o router RACondado, foram recebidos. Além disso, também somos capazes de ver a tabela de encaminhamento na figura 19, e na figura 18 somos capazes de ver os comandos usados para remover a rota default e adicionar novas rotas que conectassem o host Castelo2 às sub-redes Condado Portucalense e Rede Institucional.

Por fim, a rota default, é uma rota que especifica para onde enviar pacotes quando não há uma rota específica para o destino pretendida na tabela de encaminhamento. É bastante útil pois facilita o roteamento, já que em vez de adicionar rotas individuais para cada destino externo, todos os pacotes desconhecidos são enviados para um gateway padrão, além disso, evita configuração manual excessiva, pois sem uma rota default, cada destino teria que ser especificado manualmente.
#v(10pt)
== Exercício 2
D.Afonso Henriques quer enviar fotos do novo Castelo à sua mãe, D.Teresa, mas está a ter alguns problemas de comunicação.
Este alega que o problema deverá estar no dispositivo de D.Teresa, uma vez que no dia anterior conseguiu fazer stream de
Fortnite para todos os seus subscritores da Twitch, e acabou de sair de uma discussão política no Reddit.

#v(10pt)
*a) Confirme, através do comando ping, que AfonsoHenriques tem efetivamente conectividade com os servidores Reddit e Twitch*

#figure(
  image("images2/red.png", width: 125%),
  caption: [Prova de conetividade com o servidor Reddit],
)

#figure(
  image("images2/twi.png", width: 125%),
  caption: [Prova de conetividade com o servidor Twitch],
)
Como podemos ver nas figuras 22 e 23, ao utilizar o comando ping para enviar pacotes do host AfonsoHenriques para os endereços dos servidores Reddit e Twitch, os pacotes foram recebidos, logo existe conetividade.

#v(10pt)
*b) Recorrendo ao comando netstat -rn, analise as tabelas de encaminhamento dos dispositivos AfonsoHenriques e Teresa. Existe algum problema com as suas entradas? Identifique e descreva a utilidade de cada uma das entradas destes dois hosts.*

#figure(
  image("images2/tabelaAfonso.png", width: 125%),
  caption: [Tabela de encaminhamento do host AfonsoHenriques],
)

#figure(
  image("images2/tabelaTeresa.png", width: 125%),
  caption: [Tabela de encaminhamento do host Teresa],
)

As tabelas de encaminhamento do host AfonsoHenriques e do host Teresa não têm erros nem problemas com as suas entradas. Cada dispositivo possui, na sua tabela de encaminhamento, uma rota default, neste caso na primeira entrada das tabelas, que permite encaminhar pacotes para redes externas através do roteador local conectado à sua sub-rede. Além disso, também neste caso, a segunda entrada indica que o tráfego para a rede local não precisa de encaminhamento, pois o dispositivo já está dentro da mesma sub-rede que os hosts, garantindo que pacotes destinados a IPs dentro da mesma sub-rede sejam entregues diretamente, sem precisar de roteamento adicional.

#v(10pt)
*c) Analise o comportamento dos routers do core da rede (n1 a n6) quando tenta estabelecer comunicação entre os hosts AfonsoHenriques e Teresa. Indique que dispositivo(s) não permite(m) o encaminhamento correto dos pacotes. Seguidamente, avalie e explique a(s) causa(s) do funcionamento incorreto do dispositivo.*

*Utilize o comando ip route add/del para adicionar as rotas necessárias ou remover rotas incorretas. Verifique a sintaxe completa do comando a usar com man ip-route ou man route. Poderá também utilizar o comando traceroute para se certificar do caminho nó a nó. Considere a alínea resolvida assim que houver tráfego a chegar ao ISP CondadOnline.
*

#figure(
  image("images3/AfonsoTeresa.png", width: 125%),
  caption: [Envio de pacotes do host AfonsoHenriques para o host Teresa],
)

#figure(
  image("images3/TeresaAfonso.png", width: 125%),
  caption: [Envio de pacotes do host Teresa para o host AfonsoHenriques],
)

Após usar o comando ping para enviar pacotes entre os hosts AfonsoHenriques e Teresa, como é possível ver nas figuras 26 e 27, verificamos que não foi possível enviar os pacotes, o que significa que não deverá existir conetividade entre os dois hosts.

Assim como é referido na alínea decidimos inspecionar os routers do core da rede(n1 a n6) para tentar encontrar possíveis problemas que nos estejam a impossibilitar de fazer o envio de pacotes entre os hosts.


#v(10pt)
*Router n1*

#figure(
  image("images3/n1Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n1(Antes)],
)

#figure(
  image("images3/delN1.png", width: 125%),
  caption: [Remoção de rota incorreta],
)

#figure(
  image("images3/addN1.png", width: 125%),
  caption: [Adição da rota correta],
)

#figure(
  image("images3/n1Depois.png", width: 100%),
  caption: [Tabela de encaminhamento do router n1(Depois)],
)

Ao analisar o router n1, fomos capazes de verificar que possuía uma rota incorreta devido a uma Gateway incorreto(10.0.0.14/30), o que impossibilitava a continuação do percurso. Para resolver este problema adicionamos outra rota com o GateWay correto(10.0.0.9/30) e removemos a incorreta.

#v(10pt)
*Router n2*

#figure(
  image("images3/n2Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n2(Antes)],
)

#figure(
  image("images3/DelN2.png", width: 125%),
  caption: [Remoção de rota incorreta],
)

#figure(
  image("images3/n2Depois.png", width: 100%),
  caption: [Tabela de encaminhamento do router n2(Depois)],
)

Depois de analisar o router n2, verificamos que a sua tabela de encaminhamento possuía uma entrada incorreta, com o campo Destination(192.168.0.130/31) e o campo Gateway(10.0.0.25/30) errados, o que nos levou a remover a rota incorreta. Como a tabela já possuía uma entrada com uma rota com o destino correto e o campo Gateway também com o endereço certo, depois de remover-mos a rota incorreta fomos capazes de resolver o problema no router n2.

#v(10pt)
*Router n3*

#figure(
  image("images3/n3Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n3(Antes)],
)

#figure(
  image("images3/addN3.png", width: 125%),
  caption: [Adição da rota em falta],
)

#figure(
  image("images3/n3Depois.png", width: 100%),
  caption: [Tabela de encaminhamento do router n3(Depois)],
)

Após analisar o router n3, fomos capazes de notar que faltava uma rota para a sub-rede do host Teresa, o que impossibilitava o envio de pacotes para o mesmo, para corrigir esse problema adicionamos uma rota para a sub-rede onde se encontra o host Teresa(192.168.0.128/29) com o Gateway correto(10.0.0.5).

#pagebreak()
*Routers n4, n5 e n6*

#figure(
  image("images3/n4Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n4],
)

#figure(
  image("images3/n5Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n5],
)

#figure(
  image("images3/n6Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n6],
)

Depois de verificar os router n4, n5 e n6, concluímos que nenhum apresentava erros que impossibilitassem o envio de pacotes do host AfonsoHenriques para o host Teresa, visto que todos os três routers possuíam uma rota com o campo Destination com a sub-rede do host Teresa e o campo Gateway com o endereço do próximo dispositivo correto.

#v(10pt)
#figure(
  image("images3/trafegoCondadoOnline.png", width: 125%),
  caption: [Envio de pacotes para o endereço do router CondadoOnline],
)

Como podemos ver na figura 41, ao usar o comando ping fomos capazes de enviar pacotes do host AfonsoHenriques para  endereço do host CondadoOnline(10.0.0.1/30), o que nos permite concluir que os routers do core da rede não possuem mais qualquer problema ou erro.

#v(10pt)
*d) Uma vez que o core da rede esteja a encaminhar corretamente os pacotes enviados por AfonsoHenriques, confira com o Wireshark se estes são recebidos por Teresa.*

#figure(
  image("images5/wireTeresa.png", width: 125%),
  caption: [Prova de que o host Teresa recebeu os pacotes],
)

Como é possível ver na figura 42, os pacotes são recebidos.

#v(10pt)
*i) Em caso afirmativo, porque é que continua a não existir conectividade entre D.Teresa e D.Afonso Henriques? Efetue as alterações necessárias para garantir que a conectividade é restabelecida e o confronto entre os dois é evitado.*

Após analisar melhor a topologia, fomos capazes de detetar que o problema que impedia a existência de conetividade entre o host AfonsoHenriques e o host Teresa estava no router RAGaliza, onde , embora fosse possível enviar pacotes para o host Teresa(request), os pacotes resposta(reply) não chegavam ao host AfonsoHenriques, devido ao facto de faltar a entrada correta na tabela de encaminhamento do router RAGaliza.

#figure(
  image("images5/galiza.png", width: 100%),
  caption: [Tabela de encaminhamento do router RAGaliza(Antes)],
)

#figure(
  image("images5/addGaliza.png", width: 150%),
  caption: [Adição da rota em falta],
)

#figure(
  image("images5/tabelaGalizaAtualizado.png", width: 100%),
  caption: [Tabela de encaminhamento do router RAGaliza(Depois)],
)

O problema no router RAGaliza devia-se ao fato de não haver uma rota com a sub-rede do host AfonsoHenriques como destino. Depois de adicionar uma rota com o destino e gateway correspondentes, fomos capazes de obter conetividade entre D.Teresa e D.Afonso Henriques, assim como é mostrado nas figuras 46 e 47 abaixo.

#figure(
  image("images5/AfonsoTeresaCorreto.png", width: 120%),
  caption: [Envio de pacotes do host AfonsoHenriques para o host Teresa],
)

#figure(
  image("images5/TeresaAfonsoCorreto.png", width: 120%),
  caption: [Envio de pacotes do host Teresa para o host AfonsoHenriques],
)

#v(10pt)
*ii) As rotas dos pacotes ICMP echo reply são as mesmas, mas em sentido inverso, que as rotas dos pacotes ICMP echo request enviados entre AfonsoHenriques e Teresa? (Sugestão: analise as rotas nos dois sentidos com o traceroute). Mostre graficamente a rota seguida nos dois sentidos por esses pacotes ICMP.*

#figure(
  image("images5/traceAfonso.png", width: 125%),
  caption: [Output do traceroute do host AfonsoHenriques para o endereço do host Teresa],
)

#figure(
  image("images3/rotaAfonso.png", width: 150%),
  caption: [Rota de envio de pacotes do host AfonsoHenriques para o host Teresa],
)

Como podemos ver nas figuras 48 e 49, os pacotes que vão do host AfonsoHenriques para o host Teresa seguem a rota:

-> Host AfonsoHenriques

-> switche n11

-> Router RACondado

-> Router ReiDaNet

-> Router n5

-> Router n2

-> Router n1

-> Router n3

-> Router n6

-> Router CondadoOnline

-> Router RAGaliza

-> switche n13

-> Host Teresa 

#v(10pt)

#figure(
  image("images5/traceTeresa.png", width: 125%),
  caption: [Output do traceroute do host Teresa para o endereço do host AfonsoHenriques],
)

#figure(
  image("images3/rotaTeresa.png", width: 150%),
  caption: [Rota de envio de pacotes do host Teresa para o host AfonsoHenriques],
)

Como é possível observar nas figuras 50 e 51, os pacotes que vão do host Teresa para o host AfonsoHenriques seguem a seguinte rota;

-> Host Teresa

-> switche n13

-> Router RAGaliza

-> Router CondadoOnline

-> Router n6

-> Router n3

-> Router n4

-> Router n2

-> Router n5

-> Router ReiDaNet

-> Router RACondado

-> switche n11

-> Host AfonsoHenriques
#v(10pt)
Por fim, embora as duas rotas sejam semelhentes elas não são iguais.

#v(10pt)

*e) Estando restabelecida a conectividade entre os dois hosts, obtenha a tabela de encaminhamento de n5 e foque-se na seguinte entrada:*
#figure(
  image("images5/e.png", width: 100%),
)
*Existe uma correspondência (match) nesta entrada para pacotes enviados para o polo Galiza? E para CDN? Caso seja essa a entrada utilizada para o encaminhamento, permitirá o funcionamento esperado do dispositivo? Ofereça uma explicação pela qual essa entrada é ou não utilizada.*

#figure(
  image("images3/n5Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n5],
)

Existe uma correspondência para pacotes enviados para os polos Galiza e CDN, visto que a sub-rede 192.168.0.128/29 do polo Galiza e as sub-redes 192.168.0.152/29, 192.168.0.144/29 e 192.168.0.136/29 do CDN fazem parte da sub-rede 192.168.0.0/24. 

No entanto, essa entrada não garantiria o funcionamento esperado, uma vez que ela tem como próximo dispositivo o router ReiDaNet que apenas leva ao polo Condado Portucalense e ao Institucional e, além disso, existem rotas mais específicas, como as quatro mencionadas anteriormente, visto que que tem máscara /29, que seriam escolhidas ao invés da entrada dada, que tem máscara /24, visto que os routers sempre tem preferência por rotas mais específicas.

Devido aos motivos anteriormente referidos, a entrada não seria utilizada.


#v(10pt)
*f) Os endereços utilizados pelos quatro polos são endereços públicos ou privados? E os utilizados no core da rede/ISPs? Justifique convenientemente.*

Os endereços usados nos quatro polos pertencem seguem o padrão 192.168.0.X/29, que pertence à faixa 192.168.0.0/16 que é reservada a redes privadas (RFC 1918).

Já os endereços usados nos ISPs seguem o padrão 172.16.142.X/30 e 172.16.143.X/30, que pertence à faixa 172.16.0.0/12 que também é reservada a redes privadas.

Por último, os endereços usados no core da rede seguem o padrão 10.0.0.X/30, que pertence à faixa 10.0.0.0/8 que é reservada a redes privadas (RFC 1918).


#v(10pt)
*g) Os switches localizados em cada um dos polos têm um endereço IP atribuído? Porquê?*

Os switches não têm um endereço IP atribuído, visto que são dispositivos de nível/Layer 2(LinK Layer), enquanto que o IP reside no nível 3, logo não há necessidade dos switches terem um endereço IP.

#v(10pt)
== Exercício 3

Ao ver as fotos no CondadoGram, D. Teresa não ficou convencida com as novas alterações e ordena que Afonso Henriques vá arrumar o castelo. Inconformado, este decide planear um novo ataque, mas constata que o seu exército não só perde bastante tempo a decidir que direção tomar a cada salto como, por vezes, inclusivamente se perde.

#v(10pt)
*a) De modo a facilitar a travessia, elimine as rotas referentes a Galiza e CDN no dispositivo n6 e defina um esquema de sumarização de rotas (Supernetting) que permita o uso de apenas uma rota para ambos os polos. Confirme que a conectividade é mantida.*

#figure(
  image("images3/n6Antes.png", width: 100%),
  caption: [Tabela de encaminhamento do router n6(Antes)],
)
#v(10pt)

Na figura 54, somos capazes de ver a tabela de encaminhamento do router n6 antes de definirmos um esquema de sumarização de rotas. 
#v(10pt)

#figure(
  image("images5/Novo.png", width: 100%),
  caption: [Rotas para os polos Galiza e CDN removidas]
)

#v(10pt)
Já na figura 55, é mostrado o processo de remoção de rotas da tabela de encaminhamento, que tinham como destino sub-redes pertencentes aos polos Galiza e CDN.
#v(10pt)

#figure(
  image("images5/addRouter3a.png", width: 125%),
  caption: [Rota para os polos Galiza e CDN adicionada usando Supernetting]
)

#v(10pt)
Depois de remover as rotas referentes a Galiza e CDN no dispositivo n6, definimos um esquema de sumarização de rotas(Supernetting) usando uma rota menos específica no lugar das rotas originais mais específicas, assim como é possível ver na figura 56 onde adicionamos a rota com destino para a rede 192.168.0.128/27 que engloba as sub-redes 192.168.0.128/29, 192.168.0.136/29, 192.168.0.144/29 e 192.168.0.152/29, que pertencem aos polos Galiza e CDN, permitindo-nos o uso de apenas uma rota para ambos os polos.
#v(10pt)

#figure(
  image("images5/3aISP.png", width: 120%),
  caption: [Rotas alteradas nos ISPs]
)

#v(10pt)
Além disso, também definimos um esquema de supernetting para as rotas para os routers RAGaliza e RACDN, eliminando as rotas com destino para as sub-redes 172.16.142.0/30 e 172.16.142.4/30 e adicionando a rota 172.16.142.0/29 que engloba as duas, permitindo-nos ter apenas uma rota para esses routers, como é possível observar na figura 57.
#v(10pt)

#figure(
  image("images5/tabelaN6Nova.png", width: 100%),
  caption: [Tabela de encaminhamento do router n6(Depois)],
)

#v(10pt)
Na figura 58, somos capazes de ver a tabela de encaminhamento do dispositivo n6 após as alterações nas suas rotas.

#figure(
  image("images5/prova3a.png", width: 120%),
  caption: [Prova de conetividade com os polos Galiza e CDN],
)
#v(10pt)
Por fim, na figura 59 podemos ver o output do comando ping quando usado para enviar pacotes do host AfonsoHneriques para vários endereços nos polos Galiza e CDN, como os hosts Teresa(192.168.0.130/29), Panda(192.168.0.154/29), Twitch(192.168.0.146/29) e CondadoGram(192.168.0.138/29), onde é possível observar que os pacotes são recebidos, o que nos permite concluir que a conetividade entre o host AfonsoHenriques e os polos Galiza e CDN é mantida.

#v(10pt)
*b) Repita o processo descrito na alínea anterior para CondadoPortucalense e Institucional, também no dispositivo n6.*

#v(10pt)
#figure(
  image("images5/3bRouter1.png", width: 100%),
  caption: [Rotas para os polos Condado Portucalense e Institucional removidas]
)

#v(10pt)
Assim como feito na alínea a), na figura 60 é mostrado o processo de remoção de rotas da tabela de encaminhamento, que tinham como destino sub-redes pertencentes aos polos CondadoPortucalense e Institucional.

#v(10pt)

#figure(
  image("images5/addRouter3b.png", width: 120%),
  caption: [Rota para os polos Condado Portucalense e Institucional adicionada usando Supernetting]
)

#v(10pt)
Apoś remover as rotas referentes ao CondadoPortucalense e Institucional no dispositivo n6, definimos um esquema de sumarização de rotas(Supernetting) usando uma rota menos específica no lugar das rotas originais mais específicas, assim como é possível ver na figura 61 onde adicionamos a rota com destino para a rede 192.168.0.224/27 que engloba as sub-redes 192.168.0.224/29, 192.168.0.232/29, 192.168.0.240/29 e 192.168.0.248/29, que pertencem aos polos CondadoPortucalense e Institucional, permitindo-nos o uso de apenas uma rota para ambos os polos.
#v(10pt)

#figure(
  image("images5/3bISP.png", width: 120%),
  caption: [Rotas alteradas nos ISPs]
)

#v(10pt)
Tal e qual fizemos na alínea a), também definimos um esquema de sumarização de rotas (supernetting) para as rotas para os routers RACondado e RAInstitucional, eliminando as rotas com destino para as sub-redes 172.16.143.0/30 e 172.16.143.4/30 e adicionando a rota 172.16.143.0/29 que engloba as duas, permitindo-nos ter apenas uma rota para esses routers, como é possível observar na figura 62.
#v(10pt)

#figure(
  image("images5/tabela3b.png", width: 100%),
  caption: [Tabela de encaminhamento do router n6(Final)],
)

#v(10pt)
Na figura 63, somos mais uma vez capazes de ver a tabela de encaminhamento do dispositivo n6 após as alterações nas suas rotas.
#v(10pt)

#figure(
  image("images5/prova3b.png", width: 100%),
  caption: [Prova de conetividade com os polos Condado Portucalense e Institucional],
)

#v(10pt)
Por fim, na figura 64 podemos ver o output do comando ping quando usado para enviar pacotes do host Teresa para vários endereços nos polos CondadoPortucalense e Institucional, como os hosts AfonsoHneriques(192.168.0.226/29), Uminho(192.168.0.234/29), DI(192.168.0.242/29) e Bombeiros(192.168.0.252/29), onde é possível observar que os pacotes são recebidos, o que nos permite concluir que a conetividade entre o host Teresa e os polos CondadoPortucalense e Institucional é mantida. 

#v(10pt)
*c) Comente os aspetos positivos e negativos do uso do Supernetting.*

Supernetting é uma técnica que permite a sumarização de múltiplas redes IP menores, com endereços IP contíguos, em uma rede maior. Ao fazer isso, este método simplifica o processo de roteamento reduzindo o número de entradas individuais nas tabelas de encaminhamento, o que resulta numa maior eficiência no roteamento. No entanto, além de *aspetos positivos*, Supernetting também possui *aspetos negativos*.


#v(10pt)
*Aspetos Positivos*

- Redução da Tabela de Encaminhamento: Supernetting reduz significativamente o tamanho da tabela de encaminhamento, já que múltiplos blocos de endereços são representados por uma única entrada na tabela. Isso melhora o desempenho dos routers, reduzindo a sobrecarga de processamento e os recursos de memória necessários nos routers para manter as tabelas de encaminhamento.

- Uso mais eficiente dos endereços IP: Ao agregar várias sub-redes em uma única super-rede, evita-se a fragmentação do espaço de endereçamento, otimizando o uso dos endereços disponíveis.

- Diminuição da quantidade de atualizações de roteamento: Como menos rotas precisam ser anunciadas entre os routers, há menos atualizações de tabelas de encaminhamento, o que simplifica a sua gestão ao reduzir a complexidade das configurações de roteamento.

#v(10pt)
*Aspetos Negativos*

- Complexidade na Configuração: Configurar e manter redes supernetting pode ser mais complexo do que o roteamento tradicional, especialmente para redes grandes e complexas. Requer um planeamento cuidadoso para evitar problemas de roteamento e garantir que as rotas sejam agregadas corretamente.

- Risco de Roteamento Ineficiente: Se as rotas forem agregadas de forma inadequada, isso pode resultar em roteamento ineficiente ou problemas de conetividade. Por exemplo, se um único bloco de endereços for agregado a um bloco maior, isso pode causar problemas de roteamento para redes menores dentro do bloco original.

- Dificuldade na Escalabilidade: Embora o método de supernetting seja eficaz em reduzir a tabela de encaminhamento, pode ser difícil escalar a implementação em redes muito grandes ou em constante mudança. À medida que a rede cresce, torna-se cada vez mais difícil manter a agregação de rotas de forma eficiente e precisa.

- Pode levar a desperdício de endereços em alguns casos: Se uma organização agregar muitas redes pequenas em uma única super-rede maior, pode acabar reservando mais endereços do que realmente precisa, resultando em desperdício.


#pagebreak()
= Conclusão

Neste trabalho, exploramos e abordamos diversos conceitos essenciais em redes de computadores, tais como o estudo do formato de um pacote ou datagrama IP, a fragmentação de pacotes IP, o endereçamento IP e por último o encaminhamento IP. A execução dos exercícios, no decorrer da realização do projeto, permitiu-nos aprender e compreender o comportamento de pacotes durante o seu envio através da utilização de comandos como o traceroute ou o ping, assim como do software wireshark. Além disso, este projeto também nos deu a conhecer procedimentos a tomar na avaliação do funcionamento de uma rede local e na análise de tabelas de encaminhamento de forma a poder identificar erros e aplicar possíveis correções, assim como a usar o método de sumarização de rotas(Supernetting) e conhecer alguns dos seus aspetos positivos e negativos.

Concluindo, a partir da realização deste trabalho, fomos capazes de aprender mais sobre o IPv4 e as suas principais vertentes, o que nos permitiu ter uma pequena ideia de como funciona esta área na realidade.
