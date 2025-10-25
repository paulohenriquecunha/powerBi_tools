# How to Use the DimCalendar

The **DimCalendar** is a Date Dimension table built in **Power Query (M Language)** that automatically generates a complete calendar based on the dates found in your fact table.  
Even beginners can apply this model in just a few simple steps.

---

## 🧭 Step-by-step

1. In Power BI, go to **Home → Transform Data → Power Query Editor**.  
2. From the top menu, select **New Source → Blank Query**.  
3. Open the **Advanced Editor** (top-right icon).  
4. Delete the default content and paste the **full DimCalendar code**.  
5. Replace `fTable[date]` with the name of your date column in your fact table (for example, `FactSales[SaleDate]`).  
6. Click **Done → Close & Apply**.  
7. In Power BI Desktop, mark the table as a **Date Table**.

---

## 🧩 When you have more than one date table or multiple date columns

If you have **one or more tables containing multiple date columns** (for example, *admission date* and *termination date*), you need to make a small adjustment to the original code.

In the standard DimCalendar, we use only one date field (`fTable[date]`) to determine the minimum and maximum range.  
When multiple tables or date fields exist, we must combine these values before generating the date list.

Here’s how you can do it:

```powerquery
let
    
    MinTable1 = List.Min(income_expenses[date]),  
    MinTable2 = List.Min(cash_balance[date]),  
    MinTable3 = List.Min(future_cash_balance[date]),  

    MaxTable1 = List.Max(income_expenses[date]),
    MaxTable2 = List.Max(cash_balance[date]),
    MaxTable3 = List.Max(future_cash_balance[date]),

    StartDate = List.Min({MinTable1, MinTable2, MinTable3}),
    EndDate = List.Max({MaxTable1, MaxTable2, MaxTable3}),

    TotalDays = Duration.Days(EndDate - StartDate) + 1,
    DateList = List.Dates(StartDate, TotalDays, #duration(1,0,0,0))
 
in
    DateList
This small modification ensures that the calendar covers all dates from all related tables, generating a full and consistent date range.

After obtaining the date list, simply continue with the regular DimCalendar code to add columns like Year, Month, Quarter, and others.

📚 Tip
You can also find this example in the same repository, in the file named “how_to_use”, next to the main DimCalendar script.

✍️ Author
Paulo Henrique Pereira da Cunha
Data Analyst | Power BI | Python | SQL
📍 Cascais, Portugal
