<%@ page language="java" contentType="text/html; charset=BIG5"
    pageEncoding="BIG5"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="BIG5">
<title>Company Name</title>
<jsp:include page="Master.jsp" />
<link rel="stylesheet" type="text/css" href="Style/Unite.css" media="screen" />
	
<script>

function AnalMut()
{
	window.location.href="Analysis_Site.jsp";
}

function AnalPhi()
{
	window.location.href="Analysis_Phi.jsp";
}

</script>

<style>
.menuImg
{
padding:10px;
background-color:white;
}
</style>

</head>
<body class="Home_body">
<div class="Analyis_Menu" id="Analyis_Menu">
<img src="Image/MutSite.png" class="menuImg" title="The distribution of the number of amino acids before and after the mutation at the mutation point." onclick="AnalMut()">
&nbsp;&nbsp;
<img src="Image/PhiDis.png" class="menuImg" title="The numerical interval distribution of the sample Φ value." onclick="AnalPhi()">
</div>
	<footer style="text-align: center; font-size: 20px">
		<a href="#">News</a>&nbsp;&nbsp; <a href="#">Reference</a>&nbsp;&nbsp;
		<a href="#">Contact</a> <br>
		<br>
	</footer>
</body>
</html>