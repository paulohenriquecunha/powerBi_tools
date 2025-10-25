# How to Use the DimCalendar (Power Query)

The **DimCalendar** table generates a continuous list of dates that automatically adjusts to the date range in your fact table.  
Even if you're new to Power BI, you can apply this model in just a few steps.

---

## 🪜 Steps

1. In Power BI, go to **Home → Transform Data → Power Query Editor**.  
2. From the top menu, click **New Source → Blank Query**.  
3. Open the **Advanced Editor** (icon in the upper right corner).  
4. Delete the default content and paste the full DimCalendar code.  
5. Replace `fStatus[data]` with the name of your date column from your fact table.  
6. Click **Done → Close & Apply**.

---

## 📅 When You Have Multiple Date Columns

If you have one or more tables that include multiple date fields  
(for example, *admission date* and *termination date*),  
you just need a small adjustment — define the **minimum** and **maximum** date  
from all those tables before creating the date list.

Here’s a clear example:

```powerquery
let
    
    MinTable1 = List.Min(receitas_despesas[data]),  
    MinTable2 = List.Min(saldo_caixa[data]),  
    MinTable3 = List.Min(saldo_caixa_futuro[data]),  

    MaxTable1 = List.Max(receitas_despesas[data]),
    MaxTable2 = List.Max(saldo_caixa[data]),
    MaxTable3 = List.Max(saldo_caixa_futuro[data]),

    StartDate = List.Min({MinTable1, MinTable2, MinTable3}),
    EndDate = List.Max({MaxTable1, MaxTable2, MaxTable3}),

    TotalDays = Duration.Days(EndDate - StartDate) + 1,
    DateList = List.Dates(StartDate, TotalDays, #duration(1,0,0,0))
 
in

DateList
```

This adjustment ensures your calendar covers the entire range of all date columns
(e.g., both admission and termination dates).

🔢 Sorting and Formatting Notes

Text columns such as Month Name ("January", "February")
have a corresponding numeric column (Month Number) to keep sorting correct.
If you add or rename columns, always create both text and numeric versions,
so that charts and visuals in Power BI display correctly (for example, months in the right order).

🧭 How to Set Column Sorting in Power BI

To make sure that months or weekdays appear in the correct order in visuals:
1. Go to the Data View in Power BI.
2. Select the Month Name column.
3. On the toolbar, click Sort by Column → Month Number.
4. Do the same for other text columns (like Day of Week → Day of Week Number).
This ensures proper chronological order instead of alphabetical sorting.
