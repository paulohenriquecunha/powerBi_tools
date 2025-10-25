# Como Usar o DimCalendário (Power Query)

A tabela **DimCalendário** cria uma lista contínua de datas que se ajusta automaticamente  
ao intervalo de datas existente na sua tabela fato.  
Mesmo quem está começando pode aplicar esse modelo em poucos passos.

---

## 🪜 Passo a Passo

1. No Power BI, vá até **Página Inicial → Transformar Dados → Editor do Power Query**.  
2. No menu superior, clique em **Nova Fonte → Consulta em Branco**.  
3. Abra o **Editor Avançado** (ícone no canto superior direito).  
4. Apague o conteúdo padrão e cole o código completo do DimCalendário.  
5. Substitua `fStatus[data]` pelo nome da sua coluna de data na tabela fato.  
6. Clique em **Concluir → Fechar e Aplicar**.

---

## 📅 Quando Existem Várias Colunas de Data

Se você tiver uma ou mais tabelas com várias colunas de data  
(por exemplo, *data de admissão* e *data de demissão*),  
é preciso fazer uma pequena alteração: definir a **menor** e a **maior** data  
entre todas as tabelas antes de gerar a lista de datas.

Veja o exemplo:

```powerquery
let
    
    MinTabela1 = List.Min(receitas_despesas[data]),  
    MinTabela2 = List.Min(saldo_caixa[data]),  
    MinTabela3 = List.Min(saldo_caixa_futuro[data]),  

    MaxTabela1 = List.Max(receitas_despesas[data]),
    MaxTabela2 = List.Max(saldo_caixa[data]),
    MaxTabela3 = List.Max(saldo_caixa_futuro[data]),

    DataInicio = List.Min({MinTabela1, MinTabela2, MinTabela3}),
    DataFim = List.Max({MaxTabela1, MaxTabela2, MaxTabela3}),

    QuantidadeDias = Duration.Days(DataFim - DataInicio) + 1,
    ListaDatas = List.Dates(DataInicio, QuantidadeDias, #duration(1,0,0,0))
 
in

ListaDatas
```

Essa modificação garante que o seu calendário cubra todo o intervalo
de todas as colunas de data (por exemplo, admissão e demissão).

🔢 Sobre Classificação e Formatação

As colunas de texto, como o nome do mês (Janeiro, Fevereiro),
têm uma coluna equivalente em formato numérico (Mês Número) para manter a ordem correta.
Sempre que criar ou renomear colunas, lembre-se de manter a versão numérica correspondente,
para que os gráficos e visuais do Power BI mostrem os meses na sequência certa.

🧭 Como Fazer a Classificação no Power BI

Para garantir que os meses ou dias da semana fiquem na ordem correta:
1. Vá até a Exibição de Dados no Power BI.
2. Selecione a coluna Mês Nome.
3. No menu superior, clique em Classificar por Coluna → Mês Número.
4. Repita o mesmo processo para outras colunas de texto (como Dia da Semana → Dia da Semana Número).
Isso garante que o Power BI exiba os valores em ordem cronológica, e não alfabética.
