<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<%@ page language="java" import="java.math.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.mysql.jdbc.Driver"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>Company Name</title>
<jsp:include page="Master.jsp" />
<link rel="stylesheet" type="text/css" href="Style/Unite.css"
	media="screen" />

<script src="https://d3js.org/d3.v4.min.js"></script>

<script>
	var data = new Array();
</script>
<%
String driverName = "com.mysql.jdbc.Driver";
String DB_URL = "jdbc:mysql://localhost:3306/phivalue?serverTimezone=UTC";
String Account = "root";
String Password = "root";

Connection connDB = null;
String protein_name = "",condition="";

if (request.getParameter("Protein_name") != null) 
{
	protein_name=request.getParameter("Protein_name");
	condition=" AND mutant1.protein_name = '"+protein_name+"'";
}

try {
	Class.forName(driverName).newInstance();
	connDB = DriverManager.getConnection(DB_URL, Account, Password);

	Statement cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet result = null;

	result = cmd.executeQuery("SELECT DISTINCT count(*) as num FROM phivalue.mutant1  WHERE mutant1.phi_value <= -0.9"+condition);

	if (result.next()) {
%>
<script>
	var dbData = new Array();
	dbData["No"] = 0;
	dbData["From"] = -3.0;
	dbData["To"] = -0.9;
	dbData["count"] =
<%=result.getString("num")%>
	;
	data.push(dbData);
</script>
<%
}
result.close();
cmd.close();

int count = 1;

for (double i = -0.8; i < 2.5; i += 0.1) {
double from = i;
BigDecimal b = new BigDecimal(from);
from = b.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue();

double to = i +0.09;
b = new BigDecimal(to);
to = b.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();

cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
result = cmd.executeQuery("SELECT DISTINCT count(*) as num FROM phivalue.mutant1  WHERE mutant1.phi_value <= " + to
		+ " AND mutant1.phi_value >= " + from+condition);
if (result.next()) {
%>
<script>
	var dbData = new Array();
	dbData["No"] =
<%=count%>
	;
	dbData["From"] =
<%=from%>
	;
	dbData["To"] =
<%=to%>
	;
	dbData["count"] =
<%=result.getString("num")%>
	;
	data.push(dbData);
</script>
<%
count++;
}
result.close();
cmd.close();
}
cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
result = cmd.executeQuery("SELECT DISTINCT count(*) as num FROM phivalue.mutant1  WHERE mutant1.phi_value >= 2.6"+condition);

if (result.next()) {
%>
<script>
	var dbData = new Array();
	dbData["No"] =
<%=count%>
	;
	dbData["From"] = 2.6;
	dbData["To"] = -3.0;
	dbData["count"] =
<%=result.getString("num")%>
	;
	data.push(dbData);
</script>
<%
}

result.close();
cmd.close();
connDB.close();
} catch (ClassNotFoundException e) {
out.println("Driver loading failed! <br/>");
} catch (SQLException sqle) {
out.println("DB linking failed! <br/>");
}
%>

<script>
	function Load_Bar() {
		var padding = {
			top : 20,
			right : 20,
			bottom : 50,
			left : 40
		};
		var width = 910, height = 400;

		var svg = d3.select("#Bar").append("svg").attr('width',
				width + padding.left + padding.right).attr('height',
				height + padding.top + padding.bottom);

		svg.selectAll("rect").data(data).enter().append("rect").attr("y",
				function(d) {
					return height - (d["count"]/1.5);
				}).attr("x", function(d) {
			return d["No"] * 24;
		}).attr("height", function(d) {
			return d["count"]/1.5;
		}).attr("width", 20).attr("fill", "#5F4B8B")
		.on("click",function(d)
				{
			document.search_protein.PHIV1.value = d["From"];
			document.search_protein.PHIV2.value = d["To"];
			document.search_protein.submit();
				});

		var texts = svg.selectAll("text").data(data).enter();

		texts.append("text").text(function(d) {
			if (d["To"] == -0.9)
				return "<" + "-0.9";
			else if (d["From"] == 2.6)
				return ">" + "2.6";
			else
				return d["From"] + "~" + d["To"];
		}).attr("x", function(d) {
			return (d["No"] * 24) + 10;
		}).attr("y", height + 2).attr("font-family", "sans-serif").attr(
				"font-size", "12px").attr("fill", "black").attr("style",
				"writing-mode: tb; glyph-orientation-vertical: 0");

		texts.append("text").text(function(d) {
			return d["count"];
		}).attr("x", function(d) {
			var resi=d["count"]/10;
			if(resi>10)
				return d["No"] * 24;
			else if(resi>1)
				return (d["No"] * 24)+2;
			else
				return (d["No"] * 24)+7;
					
		}).attr("y", function(d) {
			return height - (d["count"]/1.5) - 2;
		}).attr("font-family", "sans-serif").attr("font-size", "12px").attr(
				"fill", "#444444").on("click",function(d)
						{
					document.search_protein.PHIV1.value = d["From"];
					document.search_protein.PHIV2.value = d["To"];
					document.search_protein.submit();
						});;
	}
</script>

<script>
function change_protein(protein_name) {
	document.protein_inform.Protein_name.value = protein_name;
	document.protein_inform.submit();
}

function Cancel_Protein()
{
	window.location.replace("Analysis_Phi.jsp");
}
</script>

<script>
	function Open_Protein() {
		$(".Protein_Div").slideToggle("slow");
	}
</script>

</head>
<body onload="Load_Bar()">
	<div>
		<form id="protein_inform" name="protein_inform"
			action="Analysis_Phi.jsp" method="POST">
			<input type='hidden' name='Protein_name' id='Protein_name' value="">
		</form>
		<form action="Result.jsp" id="search_protein" name="search_protein" method="POST">
		<input type='hidden' name='protein_name' id='protein_name' value="<%=protein_name%>">
		<input type='hidden' name='PHIV1' id='PHIV1' value="">
		<input type='hidden' name='PHIV2' id='PHIV2' value="">	
		<input type='hidden' name='showop' id='showop' value="0,1,2,4,5,6">
		<input type='hidden' name='shownum' id='shownum' value="10">
		<input type='hidden' name='now_page' id='now_page' value='1'>
		<input type='hidden' name='ordsort' id='ordsort' value="">
		</form>
	</div>
	<div class="Center_DIV">
		<a href="Analysis_Site.jsp"
			title="The distribution of the number of amino acids before and after the mutation at the mutation point.">Mutation
			site</a> <a href="Analysis_Phi.jsp"
			title="The numerical interval distribution of the sample Φ value.">Φ
			value</a>
	</div>
	<hr>
	<div class="Scrrenline_DIV">
		<font size="4">Introduction:</font> <br>
		<p>
			<font size="4">By directly observing the Φ value distribution of the database samples through the numerical interval, it can be found that most of them are concentrated in the value 0~1,and observe the number distribution
				of amino acids before and after mutation according to specific
				protein types.</font>
		</p>
		<br>
		<br> <a onclick="Open_Protein()"
			style="font-size: 20px; text-decoration: underline;">Types of
			protein▼</a>
		<div class="Protein_Div">
		<%
		connDB = null;
		try {
			Class.forName(driverName).newInstance();
			connDB = DriverManager.getConnection(DB_URL, Account, Password);
			Statement cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet result = null;
			result = cmd.executeQuery("SELECT DISTINCT mutant1.protein_name FROM mutant1 Order by mutant1.protein_name");
			while (result.next()) {
				String PName = result.getString("protein_name");
		%>
		<li><a href="javascript:change_protein('<%=PName%>')"><%=PName%></a></li>
		<%
		}
		result.close();
		cmd.close();
		connDB.close();
		} catch (ClassNotFoundException e) {
		out.println("Driver loading failed! <br/>");
		} catch (SQLException sqle) {
		out.println("DB linking failed! <br/>");
		}
		%>
		</div>
	</div>
	<div class="Result_DIV">
	<%
	if(protein_name!="")
		out.println("<a herf='#' onclick='Cancel_Protein()'>(X)【" + protein_name + "】</a>　");
	%>
		<div id="Bar"></div>
	</div>
</body>
</html>