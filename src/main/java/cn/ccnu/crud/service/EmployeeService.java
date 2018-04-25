package cn.ccnu.crud.service;

import java.util.List;

import cn.ccnu.crud.bean.Employee;

public interface EmployeeService {
	/**
	 * 查询所有员工信息
	 * @return 
	 */
	public List<Employee> findAll();

	/**
	 * 保存员工信息
	 * @param employee
	 */
	public void saveEmp(Employee employee);

	/**
	 * 检验用户名是否可用
	 * @param empName
	 * @return
	 */
	public boolean checkuser(String empName);

	/**
	 * 根据id获取员工
	 * @param id
	 * @return
	 */
	public Employee getEmp(Integer id);

	/**
	 * 修改员工信息
	 * @param emp
	 */
	public void updateEmp(Employee emp);

	/**
	 * 根据id删除单个员工
	 * @param id
	 */
	public void delEmp(Integer id);

	/**
	 * 根据id列表批量删除员工
	 * @param ids_list
	 */
	public void delEmps(List<Integer> ids_list);

}
