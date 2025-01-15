/*
 * package deto1.web;
 * 
 * import jakarta.servlet.ServletException; import
 * jakarta.servlet.annotation.WebServlet; import
 * jakarta.servlet.http.HttpServlet; import
 * jakarta.servlet.http.HttpServletRequest; import
 * jakarta.servlet.http.HttpServletResponse;
 * 
 * import java.io.IOException; import deto1.in.*;
 * 
 * @SuppressWarnings("serial")
 * 
 * @WebServlet("/GraphDataServlet") public class GraphDataServlet extends
 * HttpServlet { protected void doGet(HttpServletRequest request,
 * HttpServletResponse response) throws ServletException, IOException { int
 * total = UserDao.getTotalCount(); int pendingCases =
 * UserDao.getCountByStatus("OPEN"); int openCases =
 * UserDao.getCountByStatus("Waiting on vendor"); int resolvedCases =
 * UserDao.getCountByStatus("Resolved");
 * 
 * 
 * 
 * request.setAttribute("totalCases", total);
 * request.setAttribute("pendingCases", pendingCases);
 * request.setAttribute("openCases", openCases);
 * request.setAttribute("resolvedCases", resolvedCases);
 * 
 * request.getRequestDispatcher("graph.jsp").forward(request, response); } }
 */