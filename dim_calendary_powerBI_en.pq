let
    // limits from fact table
    min_date    = Date.From(List.Min(fTable[date])),
    max_date    = Date.From(List.Max(fTable[date])),

    // continuous daily list
    total_days  = Duration.Days(max_date - min_date) + 1,
    date_list   = List.Dates(min_date, total_days, #duration(1,0,0,0)),

    // convert list to TABLE with date column
    to_table = Table.FromList(date_list, Splitter.SplitByNothing(), {"date"}),
    typed    = Table.TransformColumnTypes(to_table, {{"date", type date}}),

    // essential columns
    year_col        = Table.AddColumn(typed, "year", each Date.Year([date]), Int64.Type),
    month_num       = Table.AddColumn(year_col, "month_num", each Date.Month([date]), Int64.Type),
    month_name      = Table.AddColumn(month_num, "month_name", each Date.ToText([date], "MMMM", "en-US"), type text),
    month_abbr      = Table.AddColumn(month_name, "month_abbr", each Date.ToText([date], "MMM", "en-US"), type text),
    month_year      = Table.AddColumn(month_abbr, "month_year", each Date.ToText([date], "MMM yyyy", "en-US"), type text),
    month_year_num  = Table.AddColumn(month_year, "month_year_num", each Number.FromText(Date.ToText([date], "yyyyMM")), Int64.Type),

    // quarter (numeric and text)
    quarter_num = Table.AddColumn(month_year_num, "quarter_num", each Date.QuarterOfYear([date]), Int64.Type),
    quarter     = Table.AddColumn(quarter_num, "quarter", each "Q" & Number.ToText([quarter_num]), type text),

    // keys and granularities
    date_key    = Table.AddColumn(quarter, "date_key", each Number.FromText(Date.ToText([date], "yyyyMMdd")), Int64.Type),

    // day and week
    day_of_month    = Table.AddColumn(date_key, "day_of_month", each Date.Day([date]), Int64.Type),
    weekday_num     = Table.AddColumn(day_of_month, "weekday_num", each Date.DayOfWeek([date], Day.Monday) + 1, Int64.Type), // 1=Monday … 7=Sunday
    weekday_name    = Table.AddColumn(weekday_num, "weekday_name", each Date.DayOfWeekName([date], "en-US"), type text),

    // useful indicators
    is_weekend  = Table.AddColumn(weekday_name, "is_weekend", each ([weekday_num] >= 6), type logical),
    is_workday  = Table.AddColumn(is_weekend, "is_workday", each not [is_weekend], type logical),

    today           = Date.From(DateTime.LocalNow()),
    is_today        = Table.AddColumn(is_workday, "is_today", each [date] = today, type logical),
    is_current_month = Table.AddColumn(is_today, "is_current_month", each Date.Year([date]) = Date.Year(today) and Date.Month([date]) = Date.Month(today), type logical),

    // first and last day of month
    month_start = Table.AddColumn(is_current_month, "month_start", each Date.StartOfMonth([date]), type date),
    month_end   = Table.AddColumn(month_start, "month_end", each Date.EndOfMonth([date]), type date),

    // final type assurance
    final = Table.TransformColumnTypes(
        month_end,
        {
            {"month_name", type text}, {"month_abbr", type text}, {"month_year", type text},
            {"quarter", type text}, {"is_weekend", type logical}, {"is_workday", type logical},
            {"is_today", type logical}, {"is_current_month", type logical},
            {"month_start", type date}, {"month_end", type date}
        }
    )
in
    final
