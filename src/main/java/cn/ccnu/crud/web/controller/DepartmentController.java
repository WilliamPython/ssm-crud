package cn.ccnu.crud.web.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.ccnu.crud.bean.Department;
import cn.ccnu.crud.bean.Msg;
import cn.ccnu.crud.service.DepartmentService;

@Controller
public class DepartmentController {

	@Autowired
	DepartmentService departmentService;

	@RequestMapping(value = "/depts", method = RequestMethod.GET)
	@ResponseBody
	public Msg getDepts() {
		List<Department> list = departmentService.getAllDepts();

		return Msg.Success().add("depts", list);
	}
}
