<%@ page language="java" contentType="text/html; charset=BIG5"
	pageEncoding="BIG5"%>

<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="com.mysql.jdbc.Driver"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<style>
hr {
	height: 2px;
	border: none;
	border-bottom: 2px dotted #000;
}
</style>

<script src="jsmol/JSmol.min.js"></script>
<script src="jsmol/js/Jmol2.js"></script>
<script>jmolInitialize("jsmol");</script>

<%
String PDBID = "", location_s = "";
int location = 0;

String driverName = "com.mysql.jdbc.Driver";
String DB_URL = "jdbc:mysql://localhost:3306/phivalue?serverTimezone=UTC";
String Account = "root";
String Password = "root";

if (request.getParameter("PDBID") != null) {
	PDBID = request.getParameter("PDBID");
	PDBID = new String(PDBID.getBytes("iso-8859-1"), "UTF-8");

	location_s = request.getParameter("location");
	location_s = new String(location_s.getBytes("iso-8859-1"), "UTF-8");
	location = Integer.valueOf(location_s).intValue();
}
%>

<script>
function Get_PDBID()
{
	if('<%=PDBID%>'!="")
		 Check_PDB();
	else
		{
		var url = location.href;
		var PDBID=(url.split('?'))[1];
		document.getElementById("PDBID").value=(PDBID.split('_'))[0].toUpperCase();
		document.getElementById("location").value=(PDBID.split('_'))[1];
		document.Tran_Pdb.submit()
		}
		
	//Init Page
	var Show_DIV=document.getElementById("Show_DIV");
	Show_DIV.style.width=document.body.clientWidth*0.265;
}

function Check_PDB()
{
	url="https://data.rcsb.org/rest/v1/core/entry/"+"<%=PDBID%>";
	console.log(PDBID);
	  $.ajax({
	        url: url,
	        cache: false,
	        success: function () {
	        	show_3D();
	        },
			error : function(){
	        	document.getElementById("JSMOL_SHOW").innerHTML="No PDB file..";
			}
	    });
}

function show_3D()
{
		var script = 'load "https://files.rcsb.org/download/'+'<%=PDBID%>'+'.pdb'
			+'";'
			+ 'spin on;' //旋轉
		    + 'select (*:A); colour [192,192,192];'
		    + 'select (*:B); colour [192,192,192];'
		    + 'select (*:C); colour[192,192,192];'
		    + 'select (*:D); colour [192,192,192];'
		    + 'select (*:E); colour [192,192,192];'
		    + 'select (*:F); colour[192,192,192];'
		    + 'select (*:G); colour [192,192,192];'
		    + 'select (*:H); colour [192,192,192];'
		    + 'select (*:I); colour[192,192,192];'
		    + 'select (*:J); colour [192,192,192];'
		    + 'select (*:K); colour [192,192,192];'
		    + 'select (*:L); colour[192,192,192];'
		    + 'select (*:M); colour [192,192,192];'
		    + 'select (*:N); colour [192,192,192];'
		    + 'select (*:O); colour[192,192,192];'
		    + 'select (*:P); colour [192,192,192];'
		    + 'select (*:Q); colour [192,192,192];'
		    + 'select (*:R); colour[192,192,192];'
		    + 'select (*:S); colour [192,192,192];'
		    + 'select (*:T); colour [192,192,192];'
		    + 'select (*:U); colour[192,192,192];'
		    + 'select (*:V); colour [192,192,192];'
		    + 'select (*:W); colour [192,192,192];'
		    + 'select (*:X); colour[192,192,192];'
		    + 'select (*:Y); colour [192,192,192];'
		    + 'select (*:Z); colour [192,192,192];'
		    + '' ;
		Info = {
			    spin:true,			
				j2sPath: "jsmol/j2s",
				use: "HTML5",
				readyFunction: null,
			        script
			        }
		$("#JSMOL_SHOW").html(Jmol.getAppletHtml("jmolApplet0",Info));
}

function MutationCheck()
{
	jmolCheckbox("select "+<%=location%>+"; colour atoms [255,51,51]", "select "+<%=location%>+"; colour atoms [192,192,192]", "Mutant", false, "S1");
}

function jmolCheckbox(script1, script0, text, ischecked, id) 
{
	Jmol.jmolCheckbox("jmolApplet0", script1, script0, text, ischecked, id);
}
</script>

</head>
<body onload="Get_PDBID()">
	<form action="Adv_Inform.jsp" method="POST" name="Tran_Pdb"
		id="Tran_Pdb">
		<input type='hidden' name='PDBID' id='PDBID' value=""> <input
			type='hidden' name='location' id='location' value="">
	</form>

	<div id="Show_DIV" style="text-align:center">
		<table style="width: 100%;margin:auto">
			<tr>
				<td align="center"><span id="JSMOL_SHOW"><font size="5">Wait...</font></span>
				</td>
			</tr>
			<tr>
				<td><script>MutationCheck();</script></td>
			</tr>
		</table>
	</div>
</body>
</html>