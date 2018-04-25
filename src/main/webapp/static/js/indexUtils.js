  var totalRecord,currentRecord;
  
  /**
  	解析员工表格数据的函数
  */
  function build_emps_table(result){
  	//清空table表格
  	$("#emps_table tbody").empty();
  	
  	var emps = result.extend.pageInfo.list;
  	$.each(emps,function(index,emp){
  		var CheckBoxTD = $("<td></td>").append($("<input type='checkbox'/>").addClass("check_item"));
  		var EmpIdTD = $("<td></td>").append(emp.empId);
  		var EmpNameTD = $("<td></td>").append(emp.empName);
  		var EmpGenderTD = $("<td></td>").append(emp.gender=='M'?"男":"女");
  		var EmpEmailTD = $("<td></td>").append(emp.email);
  		var EmpDeptNameTD = $("<td></td>").append(emp.dept.deptName);
  		var EditBtn = $("<button></button>").addClass("btn btn-info btn-sm emp-edit-btn")
  					.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
  		//为编辑按钮添加一个自定义的属性，来表示当前员工id
  		EditBtn.attr("edit-id",emp.empId);
  		var DelBtn = $("<button></button>").addClass("btn btn-danger btn-sm emp-del-btn")
  			.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
  		//为编辑按钮添加一个自定义的属性，来表示当前员工id
  		DelBtn.attr("del-id",emp.empId);
  		var BtnTD = $("<td></td>").append(EditBtn).append(" ").append(DelBtn);
  		//将td都添加到tr中
  		$("<tr></tr>").append(CheckBoxTD).append(EmpIdTD)
  			.append(EmpNameTD).append(EmpGenderTD)
  			.append(EmpEmailTD).append(EmpDeptNameTD)
  			.append(BtnTD).appendTo("#emps_table tbody");
  	});
  }
  
  /**
  	解析显示分页汇总信息的函数
  */
  function build_page_info(result){
  	//清空page_info_area
  	$("#page_info_area").empty();
  	
  	var pageInfo = result.extend.pageInfo;
  	$("#page_info_area").html("当前第<kbd>"+pageInfo.pageNum+"</kbd>页,共有<kbd>"+pageInfo.pages+"</kbd>页,总计<kbd>"+pageInfo.total+"</kbd>条记录");
  	//$("#page_info_area").append("当前第"+pageInfo.pageNum+"页,共有"+pageInfo.pages+"页,总计"+pageInfo.total+" 条记录");
  	
  	totalRecord = pageInfo.total;
  	currentRecord = pageInfo.pageNum;
  }
  
  /**
  	解析显示分页条信息并添加点击效果的函数
  */
  function build_page_nav(result){
  	//清空 page_nav_area
  	$("#page_nav_area").empty();
  	
  	var ul = $("<ul></ul>").addClass("pagination");
  	//构建元素
  	var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
  	var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;").attr("href","#"));
  	if(result.extend.pageInfo.hasPreviousPage == false){
  		firstPageLi.addClass("disabled");
  		prePageLi.addClass("disabled");
  	}else{
  		//为元素添加点击翻页的事件
  		firstPageLi.click(function(){
  			to_page(1);
  		});
  		prePageLi.click(function(){
  			to_page(result.extend.pageInfo.pageNum -1);
  		});
  	}
  	
  	var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href","#"));
  	var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
  	if(result.extend.pageInfo.hasNextPage == false){
  		nextPageLi.addClass("disabled");
  		lastPageLi.addClass("disabled");
  	}else{
  		nextPageLi.click(function(){
  			to_page(result.extend.pageInfo.pageNum +1);
  		});
  		lastPageLi.click(function(){
  			to_page(result.extend.pageInfo.pages);
  		});
  	}
  	//添加首页和前一页 的提示
  	ul.append(firstPageLi).append(prePageLi);
  	//遍历来给ul中添加页码提示
  	$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
  		var numLi = $("<li></li>").append($("<a></a>").append(item).attr("href","#"));
  		if(result.extend.pageInfo.pageNum == item){
  			numLi.addClass("active");
  		}
  		numLi.click(function(){
  			to_page(item);
  		});
  		ul.append(numLi);
  	});
  	//添加下一页和末页 的提示
  	ul.append(nextPageLi).append(lastPageLi);
  	//把ul加入到nav
  	$("<nav></nav>").append(ul).appendTo("#page_nav_area");
  }

  /***
   * 清空表单数据、样式及内容及校验提示内容
   */
  function reset_form(ele){
  	//清空表单数据
  	$(ele)[0].reset(); //Jquery中没有reset方法，仅JavaScript的DOM元素有
  	//清空表单样式
  	$(ele).find("*").removeClass("has-error has-success");
  	//清空表单校验提示内容
  	$(ele).find(".help-block").text("");
  }
  
  /***
   * 校验表单数据
   */
  function validate_add_form(){
  	//1、拿到要校验的数据，使用正则表达式
  	var empName = $("#empName_add_input").val();
  	var regName = /(^[A-Za-z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
  	if(!regName.test(empName)){
  		//alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
  		show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
  		return false;
  	}else{
  		show_validate_msg("#empName_add_input", "success", "");
  	};
  	//2、校验邮箱信息
  	var email = $("#email_add_input").val();
  	var regEmail = /^([A-Za-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
  	if(!regEmail.test(email)){
  		//alert("邮箱格式不正确");
  		//应该清空这个元素之前的样式
  		show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
  		return false;
  	}else{
  		show_validate_msg("#email_add_input", "success", "");
  	}
  	return true;
  }

  /***
   * 显示校验结果的提示信息
   */
  function show_validate_msg(ele,status,msg){
  	//清除当前元素的校验状态
  	$(ele).parent().removeClass("has-success has-error");
  	//清除提示消息的内容
  	$(ele).next("span").text("");
  	
  	if("success" == status){
  		$(ele).parent().addClass("has-success");
  		$(ele).next("span").text(msg);
  	}else if("error" == status){
  		$(ele).parent().addClass("has-error");
  		$(ele).next("span").text(msg);
  	}
  }