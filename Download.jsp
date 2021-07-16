<%@ page language="java" contentType="text/html; charset=BIG5"
	pageEncoding="BIG5"%>
<%@ page language="java" import="java.io.*"%>
<%@ page language="java" import="java.sql.*"%>
<%@ page language="java" import="java.util.*"%>
<%@ page language="java" import="com.mysql.jdbc.Driver"%>
<%@ page language="java" import="java.text.*"%>
<%@ page language="java" import="jxl.*"%>
<%@ page language="java" import="jxl.write.*"%>
<%@ page language="java" import="jxl.write.biff.RowsExceededException"%>
<%@ page language="java" import="jxl.format.*"%>

<%!private void putRow(WritableSheet ws, int rowNum, ArrayList cells) throws RowsExceededException, WriteException {
		for (int j = 0; j < cells.size(); j++) {
			Label cell = new Label(j, rowNum, "" + cells.get(j));
			ws.addCell(cell);
		}
	}%>

<%
String driverName = "com.mysql.jdbc.Driver"; //ÅX°Ê

String DB_URL = "jdbc:mysql://localhost:3306/phivalue?serverTimezone=UTC";
String Account = "root";
String Password = "root";
Connection connDB = null;

String SqlCommand = "";
if (!request.getParameter("Sql").equals("")) {
	SqlCommand = request.getParameter("Sql");
	SqlCommand = new String(SqlCommand.getBytes("iso-8859-1"), "UTF-8");
}

SimpleDateFormat ft = new SimpleDateFormat("yyyyMMdd");
String Today = ft.format(new java.util.Date());

response.reset();
response.setHeader("Content-disposition", "attachment; filename=phivalue_" + Today + ".xls");
OutputStream os = response.getOutputStream();
WritableWorkbook workbook = Workbook.createWorkbook(os);
WritableSheet sheet = workbook.createSheet("Sheet1", 0);

try {
	Class.forName(driverName).newInstance();
	connDB = DriverManager.getConnection(DB_URL, Account, Password);
	Statement stfiler = connDB.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet result = stfiler.executeQuery(SqlCommand);
	
    ArrayList list = new ArrayList();
    list.add("Protein");
    list.add("Location");
    list.add("Mutant before");
    list.add("Mutant after");
    list.add("Phi Value");
    list.add("Paper name");
    list.add("Author");   
    list.add("PubMed ID");
    list.add("Year");
    
    putRow(sheet, 0, list);
    int rowNum = 1;
    while(result.next()){
        list = new ArrayList();
        list.add(result.getString("protein_name"));
        list.add(result.getString("location"));
        list.add(result.getString("before"));
        list.add(result.getString("after"));
        list.add(result.getString("phi_value"));
        list.add(result.getString("Title"));
        list.add(result.getString("Description"));
        list.add(result.getString("EntrezUID"));
        list.add(result.getString("Year"));
        
        putRow(sheet, rowNum, list);
        rowNum++;
    }
    workbook.write();
    workbook.close();
    os.flush();
    os.close();
} catch (ClassNotFoundException e) {
	out.write("Driver loading failed! <br/>");
} catch (SQLException sqle) {
	out.write("DB linking failed! <br/>");
	out.write("SQL Exception : " + sqle.toString() + "<br/>");
}catch(Exception e){
    out.print(e);
}
%>