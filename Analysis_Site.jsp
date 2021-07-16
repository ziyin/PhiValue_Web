<%@ page language="java" contentType="text/html; charset=BIG5"
	pageEncoding="BIG5"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.mysql.jdbc.Driver"%>

<!DOCTYPE html>
<html>
<head>
<title>Company Name</title>
<jsp:include page="Master.jsp" />
<link rel="stylesheet" type="text/css" href="Style/Unite.css"
	media="screen" />

<script src="https://d3js.org/d3.v3.min.js"></script>


<script>
	var data = new Array();
</script>
<%
String driverName = "com.mysql.jdbc.Driver";
String DB_URL = "jdbc:mysql://localhost:3306/phivalue?serverTimezone=UTC";
String Account = "root";
String Password = "root";

String acid[] = {"A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
		"W", "Y"};

Connection connDB = null;
String protein_name = "";
try {
	Class.forName(driverName).newInstance();
	connDB = DriverManager.getConnection(DB_URL, Account, Password);

	for (int i = 0; i < 22; i++) {
		for (int j = 0; j < 22; j++) {
	Statement cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet result = null;

	if (request.getParameter("Protein_name") != null) {
		result = cmd
				.executeQuery("SELECT DISTINCT count(*) as num FROM phivalue.mutant1  WHERE mutant1.before ='"
						+ acid[i] + "' AND mutant1.after ='" + acid[j] + "' AND mutant1.protein_name = '"
						+ request.getParameter("Protein_name") + "'");
		protein_name = request.getParameter("Protein_name");
	} else {
		result = cmd
				.executeQuery("SELECT DISTINCT count(*) as num FROM phivalue.mutant1  WHERE mutant1.before ='"
						+ acid[i] + "' AND mutant1.after ='" + acid[j] + "'");
	}

	if (result.next()) {
%>
<script>
			var test= new Array();
			test["From"] = "<%=acid[i]%>";
			test["To"] =  "<%=acid[j]%>";
			test["From_no"] =  "<%=i%>";
			test["To_no"] = "<%=j%>";
			test["count"] = "<%=result.getString("num")%>
	";
	data.push(test);
</script>
<%
}
result.close();
cmd.close();
}
}
connDB.close();
} catch (ClassNotFoundException e) {
out.println("Driver loading failed! <br/>");
} catch (SQLException sqle) {
out.println("DB linking failed! <br/>");
}
%>
<script>
	function Load_scottor() {
		var svg = d3.select("#scottor").append("svg").attr("width", 1000).attr(
				"height", 1000);

		var mapX = d3.scale.linear().domain([ 0, 700 ]).range([ 50, 1000 ]);

		var mapY = d3.scale.linear().domain([ 450, 0 ]).range([ 0, 800 ]);

		svg.selectAll("circle").data(data).enter().append("circle").attr("cx",
				function(d) {
					return mapX(d["From_no"] * 32);
				}).attr("cy", function(d) {
			return mapY(d["To_no"] * 20);
		}).attr("r", function(d) {
			if (d["count"] == 0)
				return 0;
			else if (d["count"] < 30)
				return 5;
			else if (d["count"] < 80)
				return 10;
			else if (d["count"] < 150)
				return 15;
			else
				return 20;
		}).attr("fill", "#59e3a0").on("click", function(d) {
			document.search_protein.MUTA1.value = d["From"];
			document.search_protein.MUTA2.value = d["To"];
			document.search_protein.submit();
		});

		var texts = svg.selectAll("text").data(data).enter();
		texts.append("text").text(function(d) {
			if (d["count"] > 0)
				return d["count"];
		}).attr("x", function(d) {
			return mapX(d["From_no"] * 32) + 12;
		}).attr("y", function(d) {
			return mapY(d["To_no"] * 20) + 6;
		}).attr("font-family", "sans-serif").attr("font-size", "12px").attr(
				"fill", "#e35b59");

		texts.append('text').text(function(d) {
			return d["To"];
		}).attr({
			'fill' : '#000',
			'x' : 0,
			'y' : function(d) {
				return mapY(d["To_no"] * 20 - 2);
			}
		});

		texts.append('text').text(function(d) {
			return d["From"];
		}).attr("x", function(d) {
			return mapX(d["From_no"] * 32);
		}).attr("y", function(d) {
			return mapY(0) + 20;
		})
	}
</script>

<script>
	function change_protein(protein_name) {
		document.protein_inform.Protein_name.value = protein_name;
		document.protein_inform.submit();
	}

	function Cancel_Protein() {
		window.location.replace("Analysis_Site.jsp");
	}
</script>

<script>
	function Open_Protein() {
		$(".Protein_Div").slideToggle("slow");
	}
</script>

</head>
<body onload="Load_scottor()">
	<div>
		<form id="protein_inform" name="protein_inform"
			action="Analysis_Site.jsp" method="POST">
			<input type='hidden' name='Protein_name' id='Protein_name' value="">
		</form>
		<form action="Result.jsp" id="search_protein" name="search_protein"
			method="POST">
			<input type='hidden' name='protein_name' id='protein_name'
				value="<%=protein_name%>"> <input type='hidden' name='MUTA1'
				id='MUTA1' value=""> <input type='hidden' name='MUTA2'
				id='MUTA2' value=""> <input type='hidden' name='showop'
				id='showop' value="0,1,2,4,5,6"> <input type='hidden'
				name='shownum' id='shownum' value="10"> <input type='hidden'
				name='now_page' id='now_page' value='1'> <input
				type='hidden' name='ordsort' id='ordsort' value="">
		</form>
	</div>
	<div class="Center_DIV">
		<a href="Analysis_Site.jsp"
			title="The distribution of the number of amino acids before and after the mutation at the mutation point.">Mutation
			site</a> <a href="Analysis_Phi.jsp"
			title="The numerical interval distribution of the sample £X value.">£X
			value</a>
	</div>
	<hr>
	<div class="Scrrenline_DIV">
		<font size="4">Introduction:</font> <br>
		<p>
			<font size="4">X axis: amino acid before mutation</font>
		</p>
		<p>
			<font size="4">Y axis: amino acid after mutation</font>
		</p>
		<p>
			<font size="4">In order to understand the distribution of the
				number of amino acids before and after mutation in this database,
				use this chart for presentation, and observe the number distribution
				of amino acids before and after mutation according to specific
				protein types.</font>
		</p>
		<br>
		<br> <a onclick="Open_Protein()"
			style="font-size: 20px; text-decoration: underline;">Types of
			protein¡¿</a>
		<div class="Protein_Div">
			<%
			connDB = null;
			try {
				Class.forName(driverName).newInstance();
				connDB = DriverManager.getConnection(DB_URL, Account, Password);
				Statement cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet result = null;
				result = cmd.executeQuery("SELECT DISTINCT mutant1.protein_name FROM mutant1");
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
	<div class="class="Result_DIV">
		<%
		if (protein_name != "")
			out.println("<a herf='#' onclick='Cancel_Protein()'>(X)¡i" + protein_name + "¡j</a>¡@");
		%>
		<div id="scottor"></div>
	</div>
</body>
</html>