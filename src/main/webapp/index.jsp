<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	  <title>员工信息维护系统</title>
	  <meta http-equiv="pragma" content="no-cache">
	  <meta http-equiv="cache-control" content="no-cache">
	  <meta http-equiv="expires" content="0">    
	  <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	  <meta http-equiv="description" content="This is my page">
	  <!-- 引入Bootstrap样式 -->
	  <link href="${path }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
 </head>
 <body>
  	<!-- 编辑模态框 -->
    <div class="modal fade" id="emp_update_Modal" tabindex="-1" role="dialog" aria-labelledby="updateModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="updateModalLabel">员工修改</h4>
	      </div>
	      <div class="modal-body">
	      	<form class="form-horizontal">
			  <div class="form-group">
			    <label for="empName_update_static" class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <p class="form-control-static" id="empName_update_static"></p>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email_update_input" class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_update_input">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			   <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
				    <label class="radio-inline">
					  <input type="radio" name="gender" id="gender_update_input1" value="M">男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender_update_input2" value="F">女
					</label>
				</div>
			  </div>
			  <div class="form-group">
				  <label class="col-sm-2 control-label">deptName</label>
				    <div class="col-sm-4">
				    <!-- 部门提交部门id即可 -->
				  	<select class="form-control" id="dept_update_select" name="dId"></select>
				  </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
	      </div>
	    </div>
	  </div>
	</div>
    <!-- 新增模态框 -->
    <div class="modal fade" id="emp_add_Modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	      	<form class="form-horizontal">
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email_add_input" class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@edu.cn">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			   <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
				    <label class="radio-inline">
					  <input type="radio" name="gender" id="gender_add_input1" value="M" checked="checked">男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender_add_input2" value="F">女
					</label>
				</div>
			  </div>
			  <div class="form-group">
				  <label class="col-sm-2 control-label">deptName</label>
				    <div class="col-sm-4">
				    <!-- 部门提交部门id即可 -->
				  	<select class="form-control" id="dept_add_select" name="dId"></select>
				  </div>
			  </div>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>
 	<!-- 主要显示信息 -->
 	<div class="container">
 	    <!-- 标题 -->
    	<div class="row">
    		<div class="col-md-12">
    			<h1>员工信息维护系统(SSM-CRUD)</h1>
    		</div>
 		</div>
 		<!-- 按钮 -->
 		<div class="row">
    		<div class="col-md-4 col-md-offset-8">
    			<button type="button" class="btn btn-primary" id="emp_add_btn">新增</button>
    			<button type="button" class="btn btn-danger" id="emp_batch_del_btn">删除</button>
    		</div>
 		</div>
 		<!-- 显示表格数据 -->
 		<div class="row">
    		<div class="col-md-12">
    			<table class="table table-hover"  id="emps_table">
    				<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>#</th>
							<th>empName</th>
							<th>email</th>
							<th>gender</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody></tbody>	
				</table>
    		</div>
 		</div>
 		<!-- 显示分页信息 -->
 		<div class="row">
			<div class="col-md-4 col-md-offset-12">
				<a href="#top"><button type="button" class="btn btn-primary" id="to_top_btn">返回顶部</button></a>
			</div>
 			<!--分页文字信息  -->
			<div class="col-md-6" id="page_info_area"></div>
			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav_area"></div>
 		</div>
 	</div>
  
  <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
  <script src="${path }/static/js/jquery-1.12.4.min.js" type="text/javascript"></script>
  <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
  <script src="${path }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
  <!-- 加载indexUtils.js文件 -->
  <script src="${path }/static/js/indexUtils.js" type="text/javascript"></script>
  
  <script type="text/javascript">
	  $(function(){
	  	to_page(1);
	  });
	  /**
	  	前往第几页的封装函数
	  */
	  function to_page(pageNum){
	  	$.ajax({
	  		url:"${path }/emps",
	  		data:"pn="+pageNum,
	  		type:"GET",
	  		success:function(result){
	  			//console.log(result);
	  			//1,解析员工表格数据
	  			build_emps_table(result);
	  			//2，解析显示分页汇总信息
	  			build_page_info(result);
	  			//3，解析显示分页条信息,并添加点击效果
	  			build_page_nav(result);
	  		}
	  	});
	  }
	
	  //点击新增按钮弹出模态框
	  $("#emp_add_btn").click(function(){
	  	//清除表单数据、样式及校验提示内容
	  	reset_form("#emp_add_Modal form"); 
	  	//发送ajax请求填充添加模态框表单中的deptName域(下拉列表)
	  	getDepts("#emp_add_Modal select");
	  	//弹出模态框
	  	$('#emp_add_Modal').modal({
	  		backdrop: 'static'
	  	});
	  });
	
	  //查出所有的部门信息并显示在下拉列表中
	  function getDepts(ele){
	  	//清空之前下拉列表的值
	  	$(ele).empty();
	  	$.ajax({
	  		url:"${path }/depts",
	  		type:"GET",
	  		success:function(result){
	  			//console.log(result);
	  			$.each(result.extend.depts,function(){
	  				$("<option></option>").append(this.deptName).attr("value",this.deptId).appendTo(ele);
	  			});
	  		}
	  	});
	  }
	
	  //点击保存，发送Ajax保存结果
	  $("#emp_save_btn").click(function(){
	  	//1,验证发送Ajax判断后之前的用户名校验是否成功
	  	if($(this).attr("ajax-empName-valid")=="error"){
	  		return false;
	  	}
	  	//2,Jquery前端校验表单数据
	  	if(!validate_add_form()){
	  		return false;
	  	}
	  	//3,发送Ajax，发送员工保存表单
	  	$.ajax({
	  		url:"${path }/emp",
	  		data:$("#emp_add_Modal form").serialize(),
	  		type:"POST",
	  		success:function(result){
	  			if(result.code==100){
	  				//1，关闭模态框
	  				$('#emp_add_Modal').modal('hide');
	  				//2，去新增后查看最后一页的结果(总记录数一般大于总页数)
	  				to_page(totalRecord);
	  			}else{
	  				//显示失败信息
	  				console.log(result);
	  				//用户名不可用
	  				if(undefined != result.extend.empNameError){
	  					//显示员工名字的错误信息
	  					show_validate_msg("#empName_add_input", "error", result.extend.empNameError);
	  				}
	  				//有哪个字段的错误信息就显示哪个字段的
	  				if(undefined != result.extend.errorFields){
	  					if(undefined != result.extend.errorFields.email){
	  						//显示邮箱错误信息
	  						show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
	  					}
	  					if(undefined != result.extend.errorFields.empName){
	  						//显示员工名字的错误信息
	  						show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
	  					}
	  				}
	  			}
	  		}
	  	});
	  });
	  
	  //给添加员工名输入栏添加change事件
	  $("#empName_add_input").change(function(){
	  	//发送Ajax验证用户名是否可用
	  	$.ajax({
	  		url:"${path }/checkuser",
	  		data:"empName="+$("#empName_add_input").val(),
	  		type:"GET",
	  		success:function(result){
	  			if(result.code==100){
	  				show_validate_msg("#empName_add_input","success","用户名可用");
	  				//用户名可用将保存按钮添加ajax-empName-valid属性且属性值为success
	  				$("#emp_save_btn").attr("ajax-empName-valid","success");
	  			}else{
	  				show_validate_msg("#empName_add_input","error",result.extend.valid_msg);
	  				//用户名不可用将保存按钮添加ajax-empName-valid属性且属性值为error
	  				$("#emp_save_btn").attr("ajax-empName-valid","error");
	  			}
	  		} 
	  	});
	  });
	  
	  //给编辑按钮添加点击事件
	  $(document).on("click",".emp-edit-btn",function(){
		//填充表单数据
	  	//发送ajax请求填充编辑模态框表单中的deptName域(下拉列表)
	  	getDepts("#emp_update_Modal select");
	    //获取员工信息
	    var id = $(this).attr("edit-id");
	    getEmp(id);
  	    //为模态框中的更新按钮添加一个自定义的属性，来表示当前员工id
  		$("#emp_update_btn").attr("edit-id",id);
	  	//弹出模态框
	  	$('#emp_update_Modal').modal({
	  		backdrop: 'static'
	  	});
	  });
	  
	  //获取员工信息
	  function getEmp(id){
  	    $.ajax({
	    	url:"${path }/emp/"+ id,
	    	type:"GET",
	    	success:function(result){
	    		var emp = result.extend.emp;
	    		$("#empName_update_static").text(emp.empName);
	    		$("#email_update_input").val(emp.email);
	    		$("#emp_update_Modal input[name=gender]").val([emp.gender]);
	    		$("#emp_update_Modal select").val([emp.dId]);
	    	}
	    }); 
	 }
	 //点击更新按钮更新员工
	 $("#emp_update_btn").click(function(){
		 //1，邮箱前端校验
		 var email = $("#email_update_input").val();
	  	 var regEmail = /^([A-Za-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
	  	 if(!regEmail.test(email)){
	  		 show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
	  		 return false;
	  	 }else{
	  		 show_validate_msg("#email_update_input", "success", "");
	  	 }
		 //2，发送ajax请求修改员工信息
		 $.ajax({
			 url:"${path }/emp/"+$(this).attr("edit-id"),
			 type:"PUT",
			 data:$("#emp_update_Modal form").serialize(),
			 success:function(result){
				//1，关闭模态框
  				$('#emp_update_Modal').modal('hide');
  				//2，去当前页
  				to_page(currentRecord); 
			 }
		 });
	 });
	 //单个删除按钮绑定单击事件
	 $(document).on("click",".emp-del-btn",function(){
		 //获取员工名
		 var empName = $(this).parents("tr").find("td:eq(2)").text();
		 
		 if(confirm("确认要删除员工【"+empName+"】吗?")){
			 $.ajax({
				 url:"${path }/emp/"+$(this).attr("del-id"),
				 type:"DELETE",
				 success:function(result){
					alert(result.msg);
					//去当前页
	  				to_page(currentRecord); 
				 }
			 });
		 }
	 });
	 //全选复选框绑定单击事件
	 $("#check_all").click(function(){
		//attr获取checked是undefined;
		//我们这些dom原生的属性；attr获取自定义属性的值；
		//prop修改和读取dom原生属性的值
		$(".check_item").prop("checked",$(this).prop("checked"));		 
	 });
	 //单个复选框绑定单击事件
	 $(document).on("click",".check_item",function(){
		 if($(".check_item:checked").length == $(".check_item").length){
			 $("#check_all").prop("checked",true);
		 }else{
			 $("#check_all").prop("checked",false); 
		 }
	 });
	 //给批量删除按钮绑定点击事件
	 $("#emp_batch_del_btn").click(function(){
		 //获取员工名和员工id
		 var empNames = "",ids = "";
		 $.each($(".check_item:checked"),function(){
			 empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
			 ids += $(this).parents("tr").find("td:eq(1)").text() + "-";
		 });
		 //去除员工名和员工id末尾多余符号
		 empNames = empNames.substring(0, empNames.length-1);
		 ids = ids.substring(0, ids.length-1);
		 //弹出确认框并发送ajax请求
		 if(confirm("确认要删除员工【"+empNames+"】吗?")){
			 $.ajax({
				 url:"${path }/emp/"+ids,
				 type:"DELETE",
				 success:function(result){
					alert(result.msg);
					//防止全选按钮状态不恢复
					if($("#check_all").prop("checked")){
						$("#check_all").prop("checked",false);
					}
					//去当前页
	  				to_page(currentRecord);
				 }
			 });
		 }
	 });
  </script>
 </body>
</html>