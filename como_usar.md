# Como Usar o DimCalendário

O **DimCalendário** é uma tabela de datas criada em **Power Query (M Language)** que gera automaticamente um calendário completo com base nas datas existentes na sua tabela fato.  
Mesmo quem está começando pode aplicar este modelo em poucos passos.

---

## 🧭 Passo a passo

1. No Power BI, vá até **Página Inicial → Transformar Dados → Editor do Power Query**.  
2. No menu superior, clique em **Nova Fonte → Consulta em Branco**.  
3. Abra o **Editor Avançado** (ícone no canto superior direito).  
4. Apague o conteúdo padrão e cole o **código completo do DimCalendário**.  
5. Substitua o campo `fTabela[data]` pelo nome da sua coluna de data na tabela fato (por exemplo, `FatoVendas[DataVenda]`).  
6. Clique em **Concluir → Fechar e Aplicar**.  
7. No Power BI Desktop, marque a tabela como **Tabela de Datas**.

---

## 🧩 Caso com mais de uma tabela de datas

Se houver **uma ou mais tabelas com várias colunas de data** (por exemplo, *data de admissão* e *data de demissão*), será necessário fazer uma pequena alteração no código original.

No seu DimCalendário padrão, usamos apenas uma fonte de data (`fTabela[data]`) para definir o intervalo mínimo e máximo.  
Quando há várias tabelas ou campos de data, precisamos combinar esses valores antes de gerar a lista de datas.

Veja o exemplo abaixo:

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
Essa modificação permite que o calendário cubra automaticamente todas as datas de todas as tabelas, garantindo um intervalo completo.

Depois de obter a lista de datas, basta continuar o código normal do DimCalendário, adicionando colunas de ano, mês, trimestre, etc.

✍️ Autor
Paulo Henrique Pereira da Cunha
Data Analyst | Power BI | Python | SQL
📍 Cascais, Portugal
