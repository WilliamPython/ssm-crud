package cn.ccnu.crud.web.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.ccnu.crud.bean.Employee;
import cn.ccnu.crud.bean.Msg;
import cn.ccnu.crud.service.EmployeeService;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

/**
 * 处理员工CRUD请求的controller
 * 
 * @author William Python
 *
 */
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;

	/**
	 * 单个删除员工(1)+批量删除员工(1-2-3) 二合一
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
	@ResponseBody
	public Msg delEmp(@PathVariable("ids") String ids) {
		if (ids.contains("-")) {
			List<Integer> ids_list = new ArrayList<Integer>();
			for (String id_str : ids.split("-")) {
				ids_list.add(Integer.parseInt(id_str));
			}
			employeeService.delEmps(ids_list);
		} else {
			employeeService.delEmp(Integer.parseInt(ids));
		}
		return Msg.Success();
	}

	/**
	 * 修改员工信息
	 * 
	 * AJAX发送PUT请求引发的血案：
	 * 	PUT请求，请求体中的数据，request.getParameter("empName")拿不到
	 * 	Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
	 * 
	 * 解决方案二：
	 * 我们需要能支持直接发送PUT之类的请求还要封装请求体中数据的方法
	 * 1、配置上HttpPutFormContentFilter；
	 * 2、他的作用；将请求体中的数据解析包装成一个map。
	 * 3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据
	 * 
	 * @param emp
	 * @return
	 */
	@RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
	@ResponseBody
	public Msg updateEmp(Employee emp) {
		employeeService.updateEmp(emp);
		return Msg.Success();
	}

	/**
	 * 修改员工信息
	 * 
	 * AJAX发送PUT请求引发的血案：
	 * 	PUT请求，请求体中的数据，request.getParameter("empName")拿不到
	 * 	Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
	 * 
	 * 解决方案一：
	 *  1,通过SpringMVC过滤器HiddenHttpMethodFilter将页面普通的post请求转为指定的delete或者put请求
	 *  2，前端Ajax请求示例如下：
		    $.ajax({
				 url:"${path }/emp/"+$(this).attr("edit-id"),
				 type:"POST",  //请求方式为POST
				 data:$("#emp_update_Modal form").serialize()+"&_method=PUT",  //带上_method参数
				 success:function(result){
					//1，关闭模态框
					$('#emp_update_Modal').modal('hide');
					//2，去当前页
					to_page(currentRecord);
				 }
			 });
	 * 
	 * @param emp
	 * @return
	 */
	// @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
	// @ResponseBody
	public Msg updateEmpWithMethod(Employee emp) {
		employeeService.updateEmp(emp);
		return Msg.Success();
	}

	/**
	 * 根据id查询员工
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id) {
		Employee emp = employeeService.getEmp(id);
		return Msg.Success().add("emp", emp);
	}

	/**
	 * 保存某个员工数据
	 * 1、支持JSR303后端校验；
	 * 2、导入Hibernate-Validator；
	 * 3、加入注解和相关代码
	 * 
	 * @return
	 */
	@RequestMapping(value = "/emp", method = RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee, BindingResult result) {
		// 防止恶意修改与$("#emp_save_btn").attr("ajax-valid","error")相关的HTML代码后使得用户名已存在的不安全数据添加进来
		if (!employeeService.checkuser(employee.getEmpName())) {
			// System.out.println("用户名已经存在");
			return Msg.Failure().add("empNameError", "用户名已经存在");
		}
		// 若校验失败，应该返回失败，在模态框中显示校验失败的错误信息
		if (result.hasErrors()) {
			Map<String, Object> map = new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for (FieldError fieldError : errors) {
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.Failure().add("errorFields", map);
		} else {
			employeeService.saveEmp(employee);
			return Msg.Success();
		}
	}

	/**
	 * 检查用户名是否可用
	 * @param empName
	 * @return
	 */
	@RequestMapping(value = "/checkuser", method = RequestMethod.GET)
	@ResponseBody
	public Msg checkuser(@RequestParam("empName") String empName) {
		// 先判断用户名是否是合法的表达式,与前端校验保持一致，为了避免前端判断用户名可用，但后面后端有提示不可用，统一起来;
		String regx = "(^[A-Za-z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
		if (!empName.matches(regx)) {
			return Msg.Failure().add("valid_msg",
					"用户名必须是6-16位数字和字母的组合或者2-5位中文(后端校验)");
		}
		// 数据库用户名重复校验
		boolean b = employeeService.checkuser(empName);
		if (b) {
			return Msg.Success();
		} else {
			return Msg.Failure().add("valid_msg", "用户名不可用");
		}
	}

	/**
	 * 查询员工数据（json分页查询）
	 * 
	 * 注意：@ResponseBody需要导入类似Jackson包才能将Java对象转换成JSON串
	 * @param pn
	 * @return
	 */
	@RequestMapping(value = "/emps", method = RequestMethod.GET)
	@ResponseBody
	public Msg getEmpsWithJSON(
			@RequestParam(name = "pn", defaultValue = "1") Integer pn) {
		// 获取第pn页，5条内容，默认查询总数count
		PageHelper.startPage(pn, 5);
		List<Employee> emps = employeeService.findAll();// 返回增强对象
		// 用PageInfo对结果进行包装，并设置导航页码数量为5
		PageInfo pageInfo = new PageInfo(emps, 5);

		return Msg.Success().add("pageInfo", pageInfo);
	}

	/**
	 * 查询员工数据（分页查询）
	 * @param pn
	 * @param model
	 * @return
	 */
	// @RequestMapping(value = "/emps", method = RequestMethod.GET)
	public String getEmps(
			@RequestParam(name = "pn", defaultValue = "1") Integer pn,
			Model model) {
		// 获取第pn页，5条内容，默认查询总数count
		PageHelper.startPage(pn, 5);
		List<Employee> emps = employeeService.findAll();// 返回增强对象
		// System.out.println("emps.size()=" + emps.size());//打印结果：emps.size()=5
		// 用PageInfo对结果进行包装，并设置导航页码数量为5
		PageInfo<Employee> pageInfo = new PageInfo<Employee>(emps, 5);

		model.addAttribute("pageInfo", pageInfo);

		return "list";
	}

}
