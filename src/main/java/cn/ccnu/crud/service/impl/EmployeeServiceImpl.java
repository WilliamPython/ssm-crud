package cn.ccnu.crud.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.ccnu.crud.bean.Employee;
import cn.ccnu.crud.bean.EmployeeExample;
import cn.ccnu.crud.bean.EmployeeExample.Criteria;
import cn.ccnu.crud.dao.EmployeeMapper;
import cn.ccnu.crud.service.EmployeeService;

@Service
public class EmployeeServiceImpl implements EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;

	public List<Employee> findAll() {
		return employeeMapper.selectByExampleWithDept(null);
	}

	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee);
	}

	public boolean checkuser(String empName) {
		EmployeeExample example = new EmployeeExample();
		Criteria Criteria = example.createCriteria();
		Criteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count == 0;
	}

	@Override
	public Employee getEmp(Integer id) {
		Employee emp = employeeMapper.selectByPrimaryKey(id);
		return emp;
	}

	@Override
	public void updateEmp(Employee emp) {
		employeeMapper.updateByPrimaryKeySelective(emp);
	}

	@Override
	public void delEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}

	@Override
	public void delEmps(List<Integer> ids_list) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpIdIn(ids_list);
		employeeMapper.deleteByExample(example);
	}
}
