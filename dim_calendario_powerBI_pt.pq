let
    // limites vindos da fato
    MinTabela1 = List.Min(receitas_despesas[data]),
    MaxTabela1 = List.Max(receitas_despesas[data]),
   
    DataInicio = List.Min({MinTabela1}),
    DataFim    = List.Max({MaxTabela1}),

    // lista diária contínua
    QuantidadeDias = Duration.Days(DataFim - DataInicio) + 1,
    ListaDatas     = List.Dates(DataInicio, QuantidadeDias, #duration(1,0,0,0)),

    // transformar em TABELA com a coluna data
    to_table = Table.FromList(ListaDatas, Splitter.SplitByNothing(), {"data"}),
    typed    = Table.TransformColumnTypes(to_table, {{"data", type date}}),

    // colunas essenciais
    ano         = Table.AddColumn(typed, "ano", each Date.Year([data]), Int64.Type),
    mes_num     = Table.AddColumn(ano, "mes_num", each Date.Month([data]), Int64.Type),
    mes_nome    = Table.AddColumn(mes_num, "mes_nome", each Date.ToText([data], "MMMM", "pt-PT"), type text),
    mes_abrev   = Table.AddColumn(mes_nome, "mes_abrev", each Date.ToText([data], "MMM", "pt-PT"), type text),
    mes_ano     = Table.AddColumn(mes_abrev, "mes_ano", each Date.ToText([data], "MMM yyyy", "pt-PT"), type text),
    mes_ano_num = Table.AddColumn(mes_ano, "mes_ano_num", each Number.FromText(Date.ToText([data], "yyyyMM")), Int64.Type),

    // trimestre numérico e texto
    trimestre_num = Table.AddColumn(mes_ano_num, "trimestre_num", each Date.QuarterOfYear([data]), Int64.Type),
    trimestre     = Table.AddColumn(trimestre_num, "trimestre", each "T" & Number.ToText([trimestre_num]), type text),

    // chaves e granularidades
    data_key = Table.AddColumn(trimestre, "data_key", each Number.FromText(Date.ToText([data], "yyyyMMdd")), Int64.Type),

    // dia e semana
    dia_mes         = Table.AddColumn(data_key, "dia_mes", each Date.Day([data]), Int64.Type),
    dia_semana_num  = Table.AddColumn(dia_mes, "dia_semana_num", each Date.DayOfWeek([data], Day.Monday) + 1, Int64.Type), // 1=segunda … 7=domingo
    dia_semana_nome = Table.AddColumn(dia_semana_num, "dia_semana_nome", each Date.DayOfWeekName([data], "pt-PT"), type text),

    // indicadores úteis
    eh_fim_semana = Table.AddColumn(dia_semana_nome, "eh_fim_semana", each ([dia_semana_num] >= 6), type logical),
    eh_dia_util   = Table.AddColumn(eh_fim_semana, "eh_dia_util", each not [eh_fim_semana], type logical),

    hoje         = Date.From(DateTime.LocalNow()),
    eh_hoje      = Table.AddColumn(eh_dia_util, "eh_hoje", each [data] = hoje, type logical),
    eh_mes_atual = Table.AddColumn(eh_hoje, "eh_mes_atual", each Date.Year([data]) = Date.Year(hoje) and Date.Month([data]) = Date.Month(hoje), type logical),

    // primeiros/últimos dias do mês
    inicio_mes = Table.AddColumn(eh_mes_atual, "inicio_mes", each Date.StartOfMonth([data]), type date),
    fim_mes    = Table.AddColumn(inicio_mes, "fim_mes", each Date.EndOfMonth([data]), type date),

    // tipagem final garantida
    final = Table.TransformColumnTypes(
        fim_mes,
        {
            {"mes_nome", type text}, {"mes_abrev", type text}, {"mes_ano", type text},
            {"trimestre", type text}, {"eh_fim_semana", type logical}, {"eh_dia_util", type logical},
            {"eh_hoje", type logical}, {"eh_mes_atual", type logical},
            {"inicio_mes", type date}, {"fim_mes", type date}
        }
    )
in
    final
