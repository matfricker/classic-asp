<!--#include file="includes/functions.asp"-->
<% pageTitle = "SQLite Data" %>
<!--#include file="includes/header.asp"-->

<div class="content">
    <p>The following is extracted from a SQLite database, using the SQLite3 ODBC Driver.</p>
    <%
        Set conn = Server.CreateObject("ADODB.Connection")

        Dim path 
        path = Server.MapPath("data\data.sqlite3")
        conn.Open "DRIVER=SQLite3 ODBC Driver;Database=" & path & ";LongNames=0;Timeout=1000;NoTXN=0;SyncPragma=NORMAL;StepAPI=0;"

        Dim sqlStatementCount
        sqlStatementCount = "SELECT COUNT(*) As Count FROM Accounts"

        Set recordSetCount = conn.Execute(sqlStatementCount)

        Dim recordCount
        If Not recordSetCount.EOF Then
            recordCount = recordSetCount.Fields("Count")
        Else
            recordCount = 0
        End IF

        If recordCount > 0 Then

            Dim sqlStatement
            sqlStatement = "SELECT * FROM Accounts"

            Set recordSet = Server.CreateObject("ADODB.recordset")
            recordSet.Open sqlStatement, conn

            Response.Write("<p>Accounts: (" & recordCount & ")</p>")

            Response.Write("<table class='table'>")
            Response.Write("<thead>")
            Response.Write("<tr>")
            Response.Write("<th>Account Number</th>")
            Response.Write("<th>First Name</th>")
            Response.Write("<th>Last Name</th>")
            Response.Write("</tr>")
            Response.Write("</thead>")
            Response.Write("<tbody>")
            
            Do While Not recordSet.EOF
                Response.Write("<tr>")
                Response.Write("<td><a href='data.asp?id=" & recordSet("Id") & "'>" & cstr(recordSet("AccountNumber")) & "</a></td>")
                Response.Write("<td>" & recordSet("FirstName") & "</td>")
                Response.Write("<td>" & recordSet("LastName") & "</td>")
                Response.Write("</tr>")
                recordSet.MoveNext
            Loop

            recordSet.Close
            
            Response.Write("</tbody>")
            Response.Write("</table>")
        Else
            Response.Write("<p>No Records</p>")
        End If

        If Request.QueryString("id") <> "" Then
            Dim accountId
            accountId = Request.QueryString("id")

            sqlStatement = "SELECT AccountNumber, TransactionDate, Amount FROM Accounts JOIN Transactions ON Accounts.Id = Transactions.AccountId WHERE AccountId = " & accountId
            recordSet.Open sqlStatement, conn

            Response.Write("<table class='table'>")
            Response.Write("<thead>")
            Response.Write("<tr>")
            Response.Write("<th>Account Number</th>")
            Response.Write("<th>Transaction Date</th>")
            Response.Write("<th>Amount</th>")
            Response.Write("</tr>")
            Response.Write("</thead>")
            Response.Write("<tbody>")
            
            Do While Not recordSet.EOF
                Response.Write("<tr>")
                Response.Write("<td>" & cstr(recordSet("AccountNumber")) & "</td>")
                Response.Write("<td>" & recordSet("TransactionDate") & "</td>")
                Response.Write("<td>" & recordSet("Amount") & "</td>")
                Response.Write("</tr>")
                recordSet.MoveNext
            Loop

            recordSet.Close
            
            Response.Write("</tbody>")
            Response.Write("</table>")
        End If

    %>
</div>

<!--#include file="includes/footer.asp"-->