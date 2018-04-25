package cn.ccnu.crud.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.ccnu.crud.bean.Department;
import cn.ccnu.crud.dao.DepartmentMapper;
import cn.ccnu.crud.service.DepartmentService;

@Service
public class DepartmentServiceImpl implements DepartmentService {
	@Autowired
	private DepartmentMapper departmentMapper;

	public List<Department> getAllDepts() {
		List<Department> list = departmentMapper.selectByExample(null);
		return list;
	}

}
