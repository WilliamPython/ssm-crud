<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	pageContext.setAttribute("path",path);
%>
<!-- web路径：
不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
		http://localhost:3306/crud
 -->
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <base href="<%=basePath%>">    
    <title>标题</title>        
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="cache-control" content="no-cache">
  <meta http-equiv="expires" content="0">    
  <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
  <meta http-equiv="description" content="This is my page">
  
  <!-- 引入Bootstrap样式 -->
  <link href="${path }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
  <script src="${path }/static/js/jquery-1.12.4.min.js" type="text/javascript"></script>
  <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
  <script src="${path }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
 </head>
 <body>
 	<div class="container">
 	    <!-- 标题 -->
    	<div class="row">
    		<div class="col-md-12">
    			<h1>SSM-CRUD</h1>
    		</div>
 		</div>
 		<!-- 按钮 -->
 		<div class="row">
    		<div class="col-md-4 col-md-offset-8">
    			<button type="button" class="btn btn-primary">新增</button>
    			<button type="button" class="btn btn-danger">删除</button>
    		</div>
 		</div>
 		<!-- 显示表格数据 -->
 		<div class="row">
    		<div class="col-md-12">
    			<table class="table table-hover">
						<tr>
							<th>#</th>
							<th>empName</th>
							<th>email</th>
							<th>gender</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
						<c:forEach items="${pageInfo.list }" var="emp">
							<tr>
								<td>${emp.empId }</td>
								<td>${emp.empName }</td>
								<td>${emp.email }</td>
								<td>${emp.gender=="M"?"男":"女" }</td>
								<td>${emp.dept.deptName }</td>
								<td>
									<button type="button" class="btn btn-info">
										<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> 编辑
									</button>
									<button type="button" class="btn btn-danger">
										<span class="glyphicon glyphicon-trash" aria-hidden="true"></span> 删除
									</button>
								</td>
							</tr>
						</c:forEach>
				</table>
    		</div>
 		</div>
 		<!-- 显示分页信息 -->
 		<div class="row">
 			<!--分页文字信息  -->
			<div class="col-md-6">
				当前第 ${pageInfo.pageNum }页,共有${pageInfo.pages }页,总计${pageInfo.total } 条记录
			</div>
			<!-- 分页条信息 -->
			<div class="col-md-6">
				<nav aria-label="Page navigation">
				  <ul class="pagination">
				  	<li><a href="${path }/emps?pn=1">首页</a></li>
				  	<c:if test="${pageInfo.hasPreviousPage }">
					    <li>
					      <a href="${path }/emps?pn=${pageInfo.prePage}" aria-label="Previous">
					        <span aria-hidden="true">&laquo;</span>
					      </a>
					    </li>
					</c:if>
					<c:if test="${!pageInfo.hasPreviousPage }">
					    <li class="disabled">
					      <a href="${path }/emps?pn=${pageInfo.prePage}" aria-label="Previous">
					        <span aria-hidden="true">&laquo;</span>
					      </a>
					    </li>
					</c:if>
				    <c:forEach items="${pageInfo.navigatepageNums }" var="num">
				    	<c:if test="${pageInfo.pageNum==num }">
				    		<li class="active"><a href="${path }/emps?pn=${num }">${num }</a></li>
				    	</c:if>
				    	<c:if test="${pageInfo.pageNum!=num }">
				    		<li><a href="${path }/emps?pn=${num }">${num }</a></li>
				    	</c:if>
				    </c:forEach>
				    <c:if test="${pageInfo.hasNextPage }">
					    <li>
					      <a href="${path }/emps?pn=${pageInfo.nextPage}" aria-label="Next">
					        <span aria-hidden="true">&raquo;</span>
					      </a>
					    </li>
				    </c:if>
				    <c:if test="${!pageInfo.hasNextPage }">
					    <li class="disabled">
					      <a href="${path }/emps?pn=${pageInfo.nextPage}" aria-label="Next">
					        <span aria-hidden="true">&raquo;</span>
					      </a>
					    </li>
				    </c:if>
				    <li><a href="${path }/emps?pn=${pageInfo.pages}">尾页</a></li>
				  </ul>
				</nav>
			</div>
 		</div>
 	</div>
 </body>
</html>