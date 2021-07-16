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
String PDBID = "",location_s="";
int location=0;

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
		var script = 'load https://files.rcsb.org/download/' + "<%=PDBID%>"+".pdb";
		Info = {
			    spin:true,			
				j2sPath: "jsmol/j2s",
				use: "HTML5",
				readyFunction: null,
			        script
			        }
		$("#JSMOL_SHOW").html(Jmol.getAppletHtml("jmolApplet0",Info));
		document.getElementById("Knowledge").setAttribute("style","display");
}
</script>

</head>
<body onload="Get_PDBID()">
	<form action="Adv_Inform.jsp" method="POST" name="Tran_Pdb"
		id="Tran_Pdb">
		<input type='hidden' name='PDBID' id='PDBID' value="">
		<input type='hidden' name='location' id='location' value="">
	</form>

	<div id="Show_DIV">
		<center>
			<span id="JSMOL_SHOW"><font size="5">Wait...</font></span>
		</center>

		<div id="Knowledge" style="display: none">
			<hr>
			<%
			if(PDBID!="")
			{
				Connection connDB = null;
				try
				{
					Class.forName(driverName).newInstance();
					connDB = DriverManager.getConnection(DB_URL, Account, Password);
					Statement cmd = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					ResultSet result = null, number = null;
					result = cmd.executeQuery("SELECT DISTINCT Seq FROM mutant1 WHERE PDB_ID = \""+PDBID+"\"");
					if(result.next())
					{
						String Seq=result.getString("Seq");
						for(int i=0;i<Seq.length();i++)
						{
							if(i==location)
							{
								out.println("<font color='red' size='4'>"+Seq.charAt(i)+"</font>");
							}
							else
							{
								out.println("<font size='4'>"+Seq.charAt(i)+"</font>");
							}
						}
					}
					else
					{
						out.println("No data!");
					}
				}
				catch(ClassNotFoundException e)
				{
					out.println("Driver loading failed! <br/>");
				}catch(SQLException sqle)
				{
					out.println("Driver loading failed! <br/>");
				}	
			}
			%>
		</div>
	</div>
</body>
</html>